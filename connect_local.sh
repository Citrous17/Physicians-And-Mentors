#!/bin/bash

echo "🔄 Starting container: $APP_HOST..."
if docker start $APP_HOST >/dev/null 2>&1; then
  echo "✅ Container $APP_HOST started."
else
  echo "❌ Failed to start $APP_HOST."
  exit 1
fi

echo "🔄 Starting database container: $DATABASE_HOST..."
if docker start $DATABASE_HOST >/dev/null 2>&1; then
  echo "✅ Database container $DATABASE_HOST started."
else
  echo "❌ Failed to start $DATABASE_HOST."
  exit 1
fi

echo "🔄 Entering $APP_HOST bash shell..."
docker exec -it $APP_HOST bash