# Dockerfile
FROM ruby:3.3.0
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
# Keep container running for interactive use
CMD [“/bin/bash”]

