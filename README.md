# Physicians and Mentors

## Docker instructions
* Make a new directory and copy the Dockerfile to it

Docker file for local:

```
# Dockerfile
FROM ruby:3.3.6
# Install essential Linux packages
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    postgresql-client \
    nodejs \
    npm
# Install Yarn
RUN npm install -g yarn
# Install Rails
RUN gem install rails
# Set working directory
WORKDIR /app

COPY Gemfile* /app/
RUN bundle install
RUN bundle exec rails assets:precompile
EXPOSE 3000
RUN chmod +x bin/rails
RUN bin/rails db:create
RUN bin/rails db:migrate

# Keep container running for interactive use
CMD [“/bin/bash”]
```

* Run the command to build the dockerfile
```
docker build -t 502_fem_docker .
```

* Copy the contents from database.yml to config/database.yml
* Run the following commands to run start the database and the container

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

Remove `/.env*` from `.dockerignore`.

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
rails server -b 0.0.0.0
```

### Run existing

Make sure that `postgres` and `rails-app` are already started:

```
docker start rails-app  
docker start postgres 
```

Start

```
docker exec -it rails-app /bin/bash 
```

## Pull database from Heroku

Pull from Heroku Postgres database to local:

```
heroku pg:pull DATABASE_URL mylocaldb --app example-app
```

The database url can be found in Heroku config variables under the test app.
