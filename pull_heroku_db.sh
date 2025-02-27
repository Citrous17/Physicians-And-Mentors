#!/bin/bash

set -e  # Exit if any command fails

# Load environment variables from .env
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
else
    echo "❌ .env file not found! Make sure it exists."
    exit 1
fi

# Check that required variables are set
REQUIRED_VARS=("DATABASE_USERNAME" "DATABASE_PASSWORD" "DATABASE_NAME" "DATABASE_HOST" "HEROKU_APP" "APP_HOST")
# once env file has all variables loaded, then check if we have all the right variables
MISSING_VARS=()

# find missing variables
for VAR in "${REQUIRED_VARS[@]}"; do
  if [ -z "${!VAR}" ]; then
    MISSING_VARS+=("$VAR")
  fi
done

# print out missing variables
if [ ${#MISSING_VARS[@]} -ne 0 ]; then
  echo "❌ Error: The following environment variables are missing:"
  for VAR in "${MISSING_VARS[@]}"; do
    echo "   - $VAR"
  done
  exit 1
fi

# Function to obtain a new Heroku API key
get_new_heroku_api_key() {
    echo "🔑 Obtaining a new Heroku API key..."
    heroku login
    HEROKU_API_KEY=$(heroku auth:token)

    if [ -z "$HEROKU_API_KEY" ]; then
        echo "❌ Failed to obtain Heroku API key."
        exit 1
    fi

    echo "🔐 Storing new Heroku API key in .env..."
    
    # Ensure a newline before appending, and avoid duplicate entries
    if grep -q "^HEROKU_API_KEY=" .env; then
        sed -i "/^HEROKU_API_KEY=/d" .env  # Remove existing entry
    fi
    echo -e "\nHEROKU_API_KEY=$HEROKU_API_KEY" >> .env
}

# Check if HEROKU_API_KEY exists and is valid
if [ -z "$HEROKU_API_KEY" ] || ! HEROKU_API_KEY=$HEROKU_API_KEY heroku auth:whoami >/dev/null 2>&1; then
    echo "⚠️ Heroku API key is missing, invalid, or expired."
    get_new_heroku_api_key
fi

# Export the Heroku API key for CLI authentication
export HEROKU_API_KEY

# Ensure Heroku authentication is set up
docker exec -it $APP_HOST bash -c "
echo 'machine api.heroku.com login $HEROKU_APP password $HEROKU_API_KEY' > ~/.netrc
chmod 600 ~/.netrc"

docker exec -it $APP_HOST bash -c "HEROKU_API_KEY=$HEROKU_API_KEY heroku pg:backups:download --app $HEROKU_APP"

echo "🔄 Ensuring the database exists locally..."
docker exec -it $APP_HOST rails db:create
echo "✅ Database exists locally."
cat latest.dump | docker exec -i $DATABASE_HOST pg_restore --clean --if-exists --no-owner -U $DATABASE_USERNAME -d $DATABASE_NAME

echo "✅ Database successfully pulled from Heroku to '$DATABASE_NAME' table!"
echo -ne "🧹 Cleaning up backup files...\r"
rm -f latest.dump
echo "✅ Cleaned backup files."