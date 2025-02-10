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

