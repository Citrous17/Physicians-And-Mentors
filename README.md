* Docker Instructions

# STEP 1 (run once): BUILD THE DOCKER IMAGE
docker build -t 502_fem_docker -f Dockerfile.local .


# Step 2 (run once): create a network using docker, called 'rails-net'
docker network create rails-net

# Step 3 (run once): Start PostgreSQL, which is necessary for database testing/operations
docker run --name postgres \
  --network rails-net \
  -e POSTGRES_PASSWORD=password \
  -e POSTGRES_USER=postgres \
  -d postgres:latest
# for powershell
docker run --name postgres --network rails-net -e POSTGRES_PASSWORD=password -e POSTGRES_USER=postgres -d postgres:latest


# Give PostgreSQL a moment to start up (Optional?)
sleep 5

# Step 4 (run once): Start new container using the image we created (502_fem_docker)
docker run -it \
  --name rails-app \
  --network rails-net \
  -p 3000:3000 \
  -v $(pwd):/app \
  502_fem_docker bash
# for powershell
docker run -it --name rails-app --network rails-net -p 3000:3000 502_fem_docker bash

# Step 5 (run when necessary) to connect to bash/cmd line of an already running container:
docker exec -it rails-app bash

** Inside the container run the following commands
# Step 6 (run once, IN THE CONTAINER BASH)
bundle install
rails db:create
rails db:migrate

# Step 6.5, if not done already, may need to setup .env file
** Create a .env file manually
** in the .env file, include variables of GOOGLE_CLIENT_ID and GOOGLE_CLIENT_SECRET

# Step 7 (run when necessary, test the rails server, IN THE CONTAINER BASH)
rails server -b 0.0.0.0



# NOTE, for the following to work you need heroku-cli installed!
# HEROKU - how to connect to bash and database within app!
* Step 1: login to heroku. run the following command:
heroku login
* This should bring up a link in the terminal, click it and log in

* step 2: to connect to heroku bash, run:
heroku run bash -a p-a-m-test-app
* step 3: to connect to database within app:
# insert command here when it gets figured out