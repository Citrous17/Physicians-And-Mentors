#!/bin/bash

set -e  # Exit if any command fails

echo "🚀 Starting Heroku database pull script..."

# Function to check if a container is running
check_container_running() {
    local container_name=$1

    # Check if running inside a Docker container
    if grep -q docker /proc/1/cgroup || [ -f /.dockerenv ]; then
        # Inside Docker, check if the container is accessible via Docker CLI
        if docker ps --filter "name=$container_name" --filter "status=running" | grep -q "$container_name"; then
            echo "✅ Container '$container_name' is running."
        else
            echo "❌ Container '$container_name' is not running. Please ensure it is started."
            exit 1
        fi
    else
        # On the host machine, check if the container is running
        if docker ps --filter "name=$container_name" --filter "status=running" | grep -q "$container_name"; then
            echo "✅ Container '$container_name' is running."
        else
            echo "⚠️ Container '$container_name' is not running. Starting it..."
            docker start "$container_name"
            if [ $? -eq 0 ]; then
                echo "✅ Container '$container_name' started successfully."
            else
                echo "❌ Failed to start container '$container_name'. Please check your Docker setup."
                exit 1
            fi
        fi
    fi
}

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

# Ensure both containers are running



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

# Detect if running inside a Docker container
if grep -q docker /proc/1/cgroup || [ -f /.dockerenv ]; then
    echo "🐳 Running inside a Docker container."

    echo "🔄 Setting up Heroku authentication in the container..."
    echo 'machine api.heroku.com login $HEROKU_APP password $HEROKU_API_KEY' > ~/.netrc
    chmod 600 ~/.netrc

    echo "🔄 Capturing a new Heroku database backup..."
    HEROKU_API_KEY=$HEROKU_API_KEY heroku pg:backups:capture --app $HEROKU_APP

    echo "🔄 Downloading the latest Heroku database backup..."
    HEROKU_API_KEY=$HEROKU_API_KEY heroku pg:backups:download --app $HEROKU_APP

    echo "🔄 Dropping the existing database (if it exists)..."
    if PGPASSWORD=$DATABASE_PASSWORD dropdb --if-exists -h $DATABASE_HOST -p ${DATABASE_PORT:-5432} -U $DATABASE_USERNAME $DATABASE_NAME; then
        echo "✅ Existing database dropped."
    else
        echo "⚠️ No existing database to drop."
    fi

    echo "🔄 Creating a new database..."
    if PGPASSWORD=$DATABASE_PASSWORD createdb -h $DATABASE_HOST -p ${DATABASE_PORT:-5432} -U $DATABASE_USERNAME $DATABASE_NAME; then
        echo "✅ Database created."
    else
        echo "❌ Failed to create the database. Please check your PostgreSQL configuration."
        exit 1
    fi

    echo "🔄 Restoring the database from the Heroku backup..."
    if cat latest.dump | PGPASSWORD=$DATABASE_PASSWORD pg_restore --clean --if-exists --no-owner -h $DATABASE_HOST -p ${DATABASE_PORT:-5432} -U $DATABASE_USERNAME -d $DATABASE_NAME; then
        echo "✅ Database restored successfully."
    else
        echo "❌ Failed to restore the database. Please check the dump file and PostgreSQL configuration."
        exit 1
    fi

else
    echo "💻 Running on the host machine."

    echo "🔍 Checking if containers are running..."
    check_container_running "$DATABASE_HOST"
    check_container_running "$APP_HOST"

    echo "🔄 Setting up Heroku authentication in the container..."
    docker exec -it $APP_HOST bash -c "
    echo 'machine api.heroku.com login $HEROKU_APP password $HEROKU_API_KEY' > ~/.netrc
    chmod 600 ~/.netrc"

    echo "🔄 Capturing a new Heroku database backup..."
    docker exec -it $APP_HOST bash -c "HEROKU_API_KEY=$HEROKU_API_KEY heroku pg:backups:capture --app $HEROKU_APP"

    echo "🔄 Downloading the latest Heroku database backup..."
    docker exec -it $APP_HOST bash -c "HEROKU_API_KEY=$HEROKU_API_KEY heroku pg:backups:download --app $HEROKU_APP"

    echo "🔄 Dropping the existing database (if it exists)..."
    if docker exec -it $APP_HOST bash -c "PGPASSWORD=$DATABASE_PASSWORD dropdb --if-exists -h $DATABASE_HOST -p ${DATABASE_PORT:-5432} -U $DATABASE_USERNAME $DATABASE_NAME"; then
        echo "✅ Existing database dropped."
    else
        echo "⚠️ No existing database to drop."
    fi

    echo "🔄 Creating a new database..."
    if docker exec -it $APP_HOST bash -c "PGPASSWORD=$DATABASE_PASSWORD createdb -h $DATABASE_HOST -p ${DATABASE_PORT:-5432} -U $DATABASE_USERNAME $DATABASE_NAME"; then
        echo "✅ Database created."
    else
        echo "❌ Failed to create the database. Please check your PostgreSQL configuration."
        exit 1
    fi

    echo "🔄 Restoring the database from the Heroku backup..."
    if cat latest.dump | docker exec -i $DATABASE_HOST bash -c "PGPASSWORD=$DATABASE_PASSWORD pg_restore --clean --if-exists --no-owner -h $DATABASE_HOST -p ${DATABASE_PORT:-5432} -U $DATABASE_USERNAME -d $DATABASE_NAME"; then
        echo "✅ Database restored successfully."
    else
        echo "❌ Failed to restore the database. Please check the dump file and PostgreSQL configuration."
        exit 1
    fi
fi

echo "✅ Database successfully pulled from Heroku to '$DATABASE_NAME'!"
echo "🧹 Cleaning up backup files..."
rm -f latest.dump
echo "✅ Backup files cleaned up."