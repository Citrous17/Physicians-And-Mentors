#!/bin/bash

set -e  # Exit if any command fails

# Load environment variables from .env
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
else
    echo "❌ .env file not found! Make sure it exists."
    exit 1
fi

# Check for the '-s' (save) flag
SAVE_DUMPS=false
while getopts "s" opt; do
  case ${opt} in
    s ) SAVE_DUMPS=true ;;  # If -s is provided, we save dump files
    * ) echo "Usage: $0 [-s]"; exit 1 ;;  # Invalid option handling
  esac
done

# Check that required variables are set
REQUIRED_VARS=("DATABASE_USERNAME" "DATABASE_PASSWORD" "DATABASE_NAME" "DATABASE_HOST" "HEROKU_APP" "APP_HOST")
MISSING_VARS=()

for VAR in "${REQUIRED_VARS[@]}"; do
  if [ -z "${!VAR}" ]; then
    MISSING_VARS+=("$VAR")
  fi
done

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
    
    if grep -q "^HEROKU_API_KEY=" .env; then
        sed -i "/^HEROKU_API_KEY=/d" .env  # Remove existing entry
    fi
    echo -e "\nHEROKU_API_KEY=$HEROKU_API_KEY" >> .env
}

if [ -z "$HEROKU_API_KEY" ] || ! HEROKU_API_KEY=$HEROKU_API_KEY heroku auth:whoami >/dev/null 2>&1; then
    echo "⚠️ Heroku API key is missing, invalid, or expired."
    get_new_heroku_api_key
fi

export HEROKU_API_KEY

docker exec -it $APP_HOST bash -c "
echo 'machine api.heroku.com login $HEROKU_APP password $HEROKU_API_KEY' > ~/.netrc
chmod 600 ~/.netrc"

docker exec -it $APP_HOST bash -c "HEROKU_API_KEY=$HEROKU_API_KEY heroku pg:backups:download --app $HEROKU_APP"

echo "🔄 Ensuring the database exists locally..."
docker exec -it $APP_HOST rails db:create
echo "✅ Database exists locally."
cat latest.dump | docker exec -i $DATABASE_HOST pg_restore --clean --if-exists --no-owner -U $DATABASE_USERNAME -d $DATABASE_NAME

echo "✅ Database successfully pulled from Heroku to '$DATABASE_NAME' table!"

# Cleanup dump files unless -s (save) flag is set
if [ "$SAVE_DUMPS" = false ]; then
    echo -ne "🧹 Cleaning up backup files...\r"
    rm -f latest.dump latest.dump.*
    echo "✅ Cleaned backup files.          "
else
    echo "💾 Save flag detected. Keeping dump files."
fi
