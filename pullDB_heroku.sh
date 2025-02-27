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
for VAR in "${REQUIRED_VARS[@]}"; do
    if [ -z "${!VAR}" ]; then
        echo "❌ Error: $VAR is not set in .env"
        exit 1
    fi
done

# Handle Heroku API key
if [ -z "$HEROKU_API_KEY" ]; then
    echo "🔑 HEROKU_API_KEY is missing. Logging into Heroku to obtain it..."
    heroku login
    HEROKU_API_KEY=$(heroku auth:token)

    if [ -z "$HEROKU_API_KEY" ]; then
        echo "❌ Failed to obtain Heroku API key."
        exit 1
    fi

    echo "🔐 Storing Heroku API key in .env..."
    echo -e "\nHEROKU_API_KEY=$HEROKU_API_KEY" >> .env
fi

# Ensure Heroku authentication is set up
docker exec -it $APP_HOST bash -c "
echo 'machine api.heroku.com login $HEROKU_APP password $HEROKU_API_KEY' > ~/.netrc
chmod 600 ~/.netrc"

echo "🔄 Downloading backup from Heroku..."
docker exec -it $APP_HOST bash -c "HEROKU_API_KEY=$HEROKU_API_KEY heroku pg:backups:download --app $HEROKU_APP"

echo "🔄 Ensuring the database exists locally..."
docker exec -it $APP_HOST rails db:create
echo "🔄 Restoring to local database from dump file..."
cat latest.dump | docker exec -i $DATABASE_HOST pg_restore --clean --if-exists --no-owner -U $DATABASE_USERNAME -d $DATABASE_NAME

echo "✅ Database successfully pulled from Heroku and restored!"
echo "🧹 Cleaning up backup files..."
rm -f latest.dump