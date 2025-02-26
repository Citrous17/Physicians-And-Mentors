#!/bin/bash
IMAGE_NAME="$IMAGE_NAME"
ENV_FILE=".env"
DOCKERIGNORE_FILE=".dockerignore"

REQUIRED_VARS=("GOOGLE_CLIENT_ID" "GOOGLE_CLIENT_SECRET" "DATABASE_USERNAME" "DATABASE_PASSWORD" "DATABASE_HOST" "IMAGE_NAME")

# Load environment variables from .env file if it exists
echo "🔄 Loading environment variables from .env file..."
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
  echo "✅ Environment variables loaded."
else
  echo "❌ Error: .env file not found. Please create it before running this script."
  exit 1
fi

# once env file has all variables loaded, then check if we have all the right variables
echo "🔄 Checking required environment variables..."
for VAR in "${REQUIRED_VARS[@]}"; do
  if [ -z "${!VAR}" ]; then
    echo "❌ Error: $VAR is not set. Please ensure it is defined in the .env file."
    exit 1
  fi
done
echo "✅ All required environment variables are set."

# Remove .env from .dockerignore if it exists
if grep -q "^$ENV_FILE$" $DOCKERIGNORE_FILE; then
    echo "🔄 Removing .env from .dockerignore..."
    grep -v "^$ENV_FILE$" $DOCKERIGNORE_FILE > temp_dockerignore && mv temp_dockerignore $DOCKERIGNORE_FILE
fi
echo "✅ Removed .env from .dockerignore if it wasn't removed already."

# Stop and remove the existing container if it exists
if [ "$(docker ps -aq -f name=$APP_HOST)" ]; then
    echo "🔄 Stopping existing container: $APP_HOST..."
    if docker stop $APP_HOST >/dev/null 2>&1; then
        echo "✅ Container $APP_HOST stopped."
    else
        echo "❌ Failed to stop $APP_HOST."
        exit 1
    fi

    echo "🔄 Removing existing container: $APP_HOST..."
    if docker rm $APP_HOST >/dev/null 2>&1; then
        echo "✅ Container $APP_HOST removed."
    else
        echo "❌ Failed to remove $APP_HOST."
        exit 1
    fi
else
    echo "ℹ️ No existing container named $APP_HOST found."
fi

# Stop and remove the existing container if it exists
if [ "$(docker ps -aq -f name=$DATABASE_HOST)" ]; then
    echo "🔄 Stopping existing container: $DATABASE_HOST..."
    if docker stop $DATABASE_HOST >/dev/null 2>&1; then
        echo "✅ Container $DATABASE_HOST stopped."
    else
        echo "❌ Failed to stop $DATABASE_HOST."
        exit 1
    fi

    echo "🔄 Removing existing container: $DATABASE_HOST..."
    if docker rm $DATABASE_HOST >/dev/null 2>&1; then
        echo "✅ Container $DATABASE_HOST removed."
    else
        echo "❌ Failed to remove $DATABASE_HOST."
        exit 1
    fi
else
    echo "ℹ️ No existing container named $DATABASE_HOST found."
fi

# Build the new Docker image
echo "🔄 Building new Docker image $IMAGE_NAME..."
docker build -t $IMAGE_NAME -f Dockerfile.local .

# Run the new container
echo "🔄 Starting new container for database: $DATABASE_HOST..."
docker run --name $DATABASE_HOST \
  --network rails-net \
  -e POSTGRES_PASSWORD=$DATABASE_PASSWORD \
  -e POSTGRES_USER=$DATABASE_USERNAME \
  -p 5432:5432 \
  -d postgres:latest 

echo "🔄 Starting new container for app: $APP_HOST..."
docker run --name $APP_HOST \
    --network rails-net \
    -p 3000:3000 \
    -v $(pwd):/app \
    -d $IMAGE_NAME:latest sleep infinity
    #-d $IMAGE_NAME:latest bash -c "rails db:create && rails db:migrate && rails server -b '0.0.0.0'"

echo "✅ Docker container setup complete!"
chmod +x ./connect_local.sh
./connect_local.sh
