# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## Docker instructions
* Make a new directory and copy the Dockerfile to it
* Run the command to build the dockerfile
```
docker build -t 502_fem_docker .
```

* Copy the contents from database.yml to config/database.yml
* Run the following commands to run start the databased and the container

### Create network
```
docker network create rails-net
```

### Start PostgreSQL
```
docker run --name postgres \
  --network rails-net \
  -e POSTGRES_PASSWORD=password \
  -e POSTGRES_USER=postgres \
  -d postgres:latest
```

### Env file
In the `.env` file, add variables `GOOGLE_CLIENT_ID`, `GOOGLE_CLIENT_SECRET`, and `SECRET_KEY_BASE`.  Do not add any other variables.

### Start Rails
```
docker run -it \
  --name rails-app \
  --network rails-net \
  -p 3000:3000 \
  -v $(pwd):/app \
  502_fem_docker bash
```

* Inside the container run the following commands

```
bundle install
rails db:create
rails db:migrate
rails server -b 0.0.0.0
```
