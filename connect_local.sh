#!/bin/bash

CONTAINER_NAME_RAILS_APP="rails-app"
CONTAINER_NAME_SQL="postgres"

echo "Starting container..."
docker start $CONTAINER_NAME_RAILS_APP

echo "Starting container..."
docker start $CONTAINER_NAME_SQL

echo "Entering $CONTAINER_NAME_RAILS_APP bash/cmdline:"
docker exec -it $CONTAINER_NAME_RAILS_APP /bin/bash