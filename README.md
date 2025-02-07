* Docker Instructions
** Make a new directory and copy the Dockerfile to it
** Run the command to build the dockerfile

docker build -t 502_fem_docker .

** Copy the contents from database.yml to config/database.yml
** Run the following commands to run start the databased and the container
# Create network
docker network create rails-net

# Start PostgreSQL
docker run --name postgres \
  --network rails-net \
  -e POSTGRES_PASSWORD=password \
  -e POSTGRES_USER=postgres \
  -d postgres:latest

# Give PostgreSQL a moment to start up
sleep 5

# Start Rails
docker run -it \
  --name rails-app \
  --network rails-net \
  -p 3000:3000 \
  -v $(pwd):/app \
  502_fem_docker bash

** Inside the container run the following commands
bundle install
rails db:create
rails db:migrate
rails server -b 0.0.0.0

