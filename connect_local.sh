#!/bin/bash

echo "🚀 Starting local container connection script..."

REQUIRED_VARS=("GOOGLE_CLIENT_ID" "GOOGLE_CLIENT_SECRET" "DATABASE_USERNAME" "DATABASE_PASSWORD" "DATABASE_HOST" "IMAGE_NAME")

# Load environment variables from .env file if it exists
if [ -f .env ]; then
  echo "🔄 Loading environment variables from .env file..."
  export $(grep -v '^#' .env | xargs)
  echo "✅ Environment variables loaded."
else
  echo "❌ Error: .env file not found. Please create it before running this script."
  exit 1
fi

# Check for missing variables
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

if [[ -z "$APP_HOST" || -z "$DATABASE_HOST" ]]; then
  echo "❌ APP_HOST or DATABASE_HOST is not set in your .env file."
  exit 1
fi

echo "🔄 Starting container: $APP_HOST..."
if docker start "$APP_HOST" >/dev/null 2>&1; then
  echo "✅ Container $APP_HOST started."
else
  echo "❌ Failed to start $APP_HOST. Please check if the container exists."
  exit 1
fi

echo "🔄 Starting database container: $DATABASE_HOST..."
if docker start "$DATABASE_HOST" >/dev/null 2>&1; then
  echo "✅ Database container $DATABASE_HOST started."
else
  echo "❌ Failed to start $DATABASE_HOST. Please check if the container exists."
  exit 1
fi

if ! docker ps --format '{{.Names}}' | grep -q "^$APP_HOST$"; then
  echo "❌ $APP_HOST is not running. Exiting."
  exit 1
fi

echo "🔄 Connecting to $APP_HOST bash shell..."
exec docker exec -it "$APP_HOST" bash
