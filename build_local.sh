#!/bin/bash
IMAGE_NAME="$IMAGE_NAME"
ENV_FILE=".env"
DOCKERIGNORE_FILE=".dockerignore"

# dont change the required vars unless you know what you're doing!!
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

# Remove .env from .dockerignore if it exists
if grep -q "^$ENV_FILE$" $DOCKERIGNORE_FILE; then
    echo -ne "🔄 Removing .env from .dockerignore...\r"
    grep -v "^$ENV_FILE$" $DOCKERIGNORE_FILE > temp_dockerignore && mv temp_dockerignore $DOCKERIGNORE_FILE
fi
echo "✅ Removed .env from .dockerignore if it wasn't removed already."

# Stop and remove the existing container if it exists
if [ "$(docker ps -aq -f name=$APP_HOST)" ]; then
    echo -ne "🔄 Stopping existing container: $APP_HOST...\r"
    if docker stop $APP_HOST >/dev/null 2>&1; then
        echo "✅ Container $APP_HOST stopped."
    else
        echo "❌ Failed to stop $APP_HOST."
        echo "Potential issues:"
        echo "1. Docker Desktop may not be running."
        echo "2. There is some other error with the container."
        exit 1
    fi

    echo -ne "🔄 Removing existing container: $APP_HOST...\r"
    if docker rm $APP_HOST >/dev/null 2>&1; then
        echo "✅ Container $APP_HOST removed."
    else
        echo "❌ Failed to remove $APP_HOST."
        echo "1. Docker Desktop may not be running."
        echo "2. There is some other error with the container."
        exit 1
    fi
else
    echo "ℹ️ No existing container named $APP_HOST found."
fi

# Stop and remove the existing container if it exists
if [ "$(docker ps -aq -f name=$DATABASE_HOST)" ]; then
    echo -ne "🔄 Stopping existing container: $DATABASE_HOST...\r"
    if docker stop $DATABASE_HOST >/dev/null 2>&1; then
        echo "✅ Container $DATABASE_HOST stopped."
    else
        echo "❌ Failed to stop $DATABASE_HOST."
        echo "potential fix: make sure docker desktop is running!"
        echo "1. Docker Desktop may not be running."
        echo "2. There is some other error with the container."
        exit 1
    fi

    echo -ne "🔄 Removing existing container: $DATABASE_HOST...\r"
    if docker rm $DATABASE_HOST >/dev/null 2>&1; then
        echo "✅ Container $DATABASE_HOST removed."
    else
        echo "❌ Failed to remove $DATABASE_HOST."
        echo "1. Docker Desktop may not be running."
        echo "2. There is some other error with the container."
        exit 1
    fi
else
    echo "ℹ️ No existing container named $DATABASE_HOST found."
fi

# Build the new Docker image
echo "🔄 Building new Docker image $IMAGE_NAME..."
# docker build -t $IMAGE_NAME -f Dockerfile.local .
if docker build -t $IMAGE_NAME -f Dockerfile.local .; then
    echo "✅ Successfully built Docker image: $IMAGE_NAME"
else
    echo "❌ Failed to build Docker image: $IMAGE_NAME"
    exit 1  # Exit the script if the build fails
fi

# Run the new container
echo -ne "🔄 Starting new container for database: $DATABASE_HOST...\r"
docker run --name $DATABASE_HOST \
  --network rails-net \
  -e POSTGRES_PASSWORD=$DATABASE_PASSWORD \
  -e POSTGRES_USER=$DATABASE_USERNAME \
  -p 5432:5432 \
  -d postgres:latest 

echo -ne "🔄 Starting new container for app: $APP_HOST...\r"
docker run --name $APP_HOST \
    --network rails-net \
    -p 3000:3000 \
    -v $(pwd):/app \
    -d $IMAGE_NAME:latest sleep infinity
    #-d $IMAGE_NAME:latest bash -c "rails db:create && rails db:migrate && rails server -b '0.0.0.0'"

docker exec -it $APP_HOST bash -c "sed -i 's/\r$//' bin/rails"

echo "✅ Docker container setup complete!"
chmod +x ./connect_local.sh
./connect_local.sh
