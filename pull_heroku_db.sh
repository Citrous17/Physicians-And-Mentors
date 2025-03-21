#!/bin/bash

set -e  # Exit if any command fails

echo "🚀 Starting Heroku database pull script..."

# Load environment variables from .env
if [ -f .env ]; then
    echo "🔄 Loading environment variables from .env file..."
    export $(grep -v '^#' .env | xargs)
    echo "✅ Environment variables loaded."
else
    echo "❌ .env file not found! Make sure it exists in the project root."
    exit 1
fi

# Check that required variables are set
REQUIRED_VARS=("DATABASE_USERNAME" "DATABASE_PASSWORD" "DATABASE_NAME" "DATABASE_HOST" "HEROKU_APP" "APP_HOST")
MISSING_VARS=()

for VAR in "${REQUIRED_VARS[@]}"; do
  if [ -z "${!VAR}" ]; then
    MISSING_VARS+=("$VAR")
  fi
done

if [ ${#MISSING_VARS[@]} -ne 0 ]; then
  echo "❌ Error: The following environment variables are missing in your .env file:"
  for VAR in "${MISSING_VARS[@]}"; do
    echo "   - $VAR"
  done
  echo "💡 Please update your .env file and try again."
  exit 1
fi

# Function to obtain a new Heroku API key
get_new_heroku_api_key() {
    echo "🔑 Obtaining a new Heroku API key..."
    heroku login
    HEROKU_API_KEY=$(heroku auth:token)

    if [ -z "$HEROKU_API_KEY" ]; then
        echo "❌ Failed to obtain Heroku API key. Please check your Heroku credentials."
        exit 1
    fi

    echo "🔐 Storing new Heroku API key in .env..."
    if grep -q "^HEROKU_API_KEY=" .env; then
        sed -i "/^HEROKU_API_KEY=/d" .env  # Remove existing entry
    fi
    echo -e "\nHEROKU_API_KEY=$HEROKU_API_KEY" >> .env
    echo "✅ Heroku API key updated in .env."
}

# Check if HEROKU_API_KEY exists and is valid
if [ -z "$HEROKU_API_KEY" ] || ! HEROKU_API_KEY=$HEROKU_API_KEY heroku auth:whoami >/dev/null 2>&1; then
    echo "⚠️ Heroku API key is missing, invalid, or expired."
    get_new_heroku_api_key
fi

# Export the Heroku API key for CLI authentication
export HEROKU_API_KEY

echo "🔄 Setting up Heroku authentication in the container..."
docker exec -it $APP_HOST bash -c "
echo 'machine api.heroku.com login $HEROKU_APP password $HEROKU_API_KEY' > ~/.netrc
chmod 600 ~/.netrc"

echo "🔄 Downloading the latest Heroku database backup..."
docker exec -it $APP_HOST bash -c "HEROKU_API_KEY=$HEROKU_API_KEY heroku pg:backups:download --app $HEROKU_APP"

echo "🔄 Ensuring the database exists locally..."
docker exec -it $APP_HOST rails db:create
echo "✅ Database exists locally."

echo "🔄 Restoring the database from the Heroku backup..."
cat latest.dump | docker exec -i $DATABASE_HOST pg_restore --clean --if-exists --no-owner -U $DATABASE_USERNAME -d $DATABASE_NAME

echo "✅ Database successfully pulled from Heroku to '$DATABASE_NAME'!"
echo "🧹 Cleaning up backup files..."
rm -f latest.dump
echo "✅ Backup files cleaned up."