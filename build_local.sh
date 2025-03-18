#!/bin/bash

IMAGE_NAME="$IMAGE_NAME"
ENV_FILE=".env"
DOCKERIGNORE_FILE=".dockerignore"
APP_PORT=3000
DB_PORT=5432

# Required environment variables
REQUIRED_VARS=("GOOGLE_CLIENT_ID" "GOOGLE_CLIENT_SECRET" "DATABASE_USERNAME" "DATABASE_PASSWORD" "DATABASE_HOST" "IMAGE_NAME")

# Function to check if a port is in use
is_port_in_use() {
    local port=$1
    if lsof -i :$port >/dev/null 2>&1 || netstat -tuln | grep -q ":$port "; then
        return 0  # Port is in use
    else
        return 1  # Port is available
    fi
}

# Check if required ports are open
if is_port_in_use $DB_PORT; then
    echo "❌ Error: Port $DB_PORT is already in use. Stop the process/container using it before continuing."
    exit 1
fi

if is_port_in_use $APP_PORT; then
    echo "❌ Error: Port $APP_PORT is already in use. Stop the process/container using it before continuing."
    exit 1
fi

# Load environment variables
echo -ne "🔄 Loading environment variables from .env file...\r"
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
    echo "✅ Environment variables loaded."
else
    echo "❌ Error: .env file not found. Please create it before running this script."
    exit 1
fi

# Check for missing environment variables
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

# Remove .env from .dockerignore
if grep -q "^$ENV_FILE$" $DOCKERIGNORE_FILE; then
    echo -ne "🔄 Removing .env from .dockerignore...\r"
    grep -v "^$ENV_FILE$" $DOCKERIGNORE_FILE > temp_dockerignore && mv temp_dockerignore $DOCKERIGNORE_FILE
fi
echo "✅ Removed .env from .dockerignore if it wasn't removed already."

# Stop and remove existing containers if they exist
for CONTAINER in $APP_HOST $DATABASE_HOST; do
    if [ "$(docker ps -aq -f name=$CONTAINER)" ]; then
        echo -ne "🔄 Stopping and removing container: $CONTAINER...\r"
        docker stop $CONTAINER >/dev/null 2>&1 && docker rm $CONTAINER >/dev/null 2>&1
        echo "✅ Container $CONTAINER stopped and removed."
    else
        echo "ℹ️ No existing container named $CONTAINER found."
    fi
done

# Build the new Docker image
echo "🔄 Building new Docker image $IMAGE_NAME..."
if docker build -t $IMAGE_NAME -f Dockerfile.local .; then
    echo "✅ Successfully built Docker image: $IMAGE_NAME"
else
    echo "❌ Failed to build Docker image: $IMAGE_NAME"
    exit 1
fi

# Run the new containers
echo -ne "🔄 Starting new container for database: $DATABASE_HOST...\r"
docker run --name $DATABASE_HOST \
  --network rails-net \
  -e POSTGRES_PASSWORD=$DATABASE_PASSWORD \
  -e POSTGRES_USER=$DATABASE_USERNAME \
  -p $DB_PORT:5432 \
  -d postgres:latest 

echo -ne "🔄 Starting new container for app: $APP_HOST...\r"
docker run --name $APP_HOST \
    --network rails-net \
    -p $APP_PORT:3000 \
    -v $(pwd):/app \
    -d $IMAGE_NAME:latest sleep infinity

docker exec -it $APP_HOST bash -c "sed -i 's/\r$//' bin/rails"

echo "✅ Docker container setup complete!"
chmod +x ./connect_local.sh
./connect_local.sh
