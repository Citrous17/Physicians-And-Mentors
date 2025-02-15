#!/bin/bash

CONTAINER_NAME_RAILS_APP="rails-app"
CONTAINER_NAME_SQL="postgres"
IMAGE_NAME="502_fem_docker"
ENV_FILE=".env"
DOCKERIGNORE_FILE=".dockerignore"

# Ensure only GOOGLE_CLIENT_ID and GOOGLE_CLIENT_SECRET are in .env
echo "Ensuring .env contains only GOOGLE_CLIENT_ID and GOOGLE_CLIENT_SECRET..."
grep -E '^GOOGLE_CLIENT_ID=|^GOOGLE_CLIENT_SECRET=' $ENV_FILE > temp_env && mv temp_env $ENV_FILE

# Remove .env from .dockerignore if it exists
if grep -q "^$ENV_FILE$" $DOCKERIGNORE_FILE; then
    echo "Removing .env from .dockerignore..."
    grep -v "^$ENV_FILE$" $DOCKERIGNORE_FILE > temp_dockerignore && mv temp_dockerignore $DOCKERIGNORE_FILE
fi

# Stop and remove the existing container if it exists
if [ "$(docker ps -aq -f name=$CONTAINER_NAME_RAILS_APP)" ]; then
    echo "Stopping and removing existing container..."
    docker stop $CONTAINER_NAME_RAILS_APP
    docker rm $CONTAINER_NAME_RAILS_APP
fi

if [ "$(docker ps -aq -f name=$CONTAINER_NAME_SQL)" ]; then
    echo "Stopping and removing existing container..."
    docker stop $CONTAINER_NAME_SQL
    docker rm $CONTAINER_NAME_SQL
fi

# Build the new Docker image
echo "Building new Docker image..."
docker build -t 502_fem_docker -f Dockerfile.local .

# Run the new container
echo "Starting new container: $CONTAINER_NAME_SQL..."
docker run --name $CONTAINER_NAME_SQL \
  --network rails-net \
  -e POSTGRES_PASSWORD=password \
  -e POSTGRES_USER=postgres \
  -d postgres:latest

echo "Starting new container: $CONTAINER_NAME_RAILS_APP..."
docker run -it \
--name $CONTAINER_NAME_RAILS_APP \
--network rails-net \
-p 3000:3000 \
-v $(pwd):/app \
502_fem_docker bash -c "bin/rails db:create && bin/rails db:migrate"

echo "Docker container setup complete! Database created and migrations completed."
./connect_local.sh
