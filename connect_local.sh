#!/bin/bash

REQUIRED_VARS=("GOOGLE_CLIENT_ID" "GOOGLE_CLIENT_SECRET" "DATABASE_USERNAME" "DATABASE_PASSWORD" "DATABASE_HOST" "IMAGE_NAME")

# Load environment variables from .env file if it exists
echo -ne "🔄 Loading environment variables from .env file...\r"
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
  echo "✅ Environment variables loaded."
else
  echo "❌ Error: .env file not found. Please create it before running this script."
  exit 1
fi

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

if [[ -z "$APP_HOST" || -z "$DATABASE_HOST" ]]; then
  echo "❌ APP_HOST or DATABASE_HOST is not set."
  exit 1
fi

echo -ne "🔄 Starting container: $APP_HOST...\r"
if docker start "$APP_HOST" >/dev/null 2>&1; then
  echo "✅ Container $APP_HOST started."
else
  echo "❌ Failed to start $APP_HOST."
  exit 1
fi

echo -ne "🔄 Starting database container: $DATABASE_HOST...\r"
if docker start "$DATABASE_HOST" >/dev/null 2>&1; then
  echo "✅ Database container $DATABASE_HOST started."
else
  echo "❌ Failed to start $DATABASE_HOST."
  exit 1
fi

if ! docker ps --format '{{.Names}}' | grep -q "^$APP_HOST$"; then
  echo "❌ $APP_HOST is not running. Exiting."
  exit 1
fi

echo "🔄 Entering $APP_HOST bash shell..."
exec docker exec -it "$APP_HOST" bash
