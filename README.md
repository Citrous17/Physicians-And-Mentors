# Physicians-and-Mentors - HEROKU INSTRUCTIONS
## How to deploy app on Heroku:
1. Login to heroku.com.
2. Navigate to your dashboard.
3. Click on the p-a-m-pipeline.
4. Click on the NAME "p-a-m-test-app".
5. Click on the "deploy" tab.
6. Scroll down to the "Manual deploy" section and choose the "test" branch to deploy
7. Click "Deploy Branch" (and wait a few minutes for the app to start up).

## HOW TO pause/stop app on Heroku
1. Login on heroku.
2. Navigate to the p-a-m-pipeline
3. Click on the name "p-a-m-test-app".
4. Click on the "settings" tab.
5. Scroll down until you see the "maintenance mode" section, then turn it on.
* To turn the app back on, simply turn maintenance mode off.

# Physicians-and-Mentors - LOCAL TESTING AND DEVELOPMENT:
## TO MAKE SURE SCRIPTS CAN BE RAN, RUN the following with dos2unix installed:
```
chmod +x build_local.sh connect_local.sh pull_heroku_db.sh
find . -type f -name "*.rb" -o -name "*.sh" | xargs dos2unix
```
### Make sure .env file exists and is populated with the following variables before running scripts; replace "<any ...>" && "<exact ...>" from below with actual values:
```
GOOGLE_CLIENT_ID=[exact as found on heroku app config]
GOOGLE_CLIENT_SECRET=[exact as found on heroku app config]
IMAGE_NAME=[any given name different to pre-existing images]
HEROKU_APP=[exact app name as shown on heroku]
APP_HOST=[any given name]
DATABASE_HOST=[any given name different from APP_HOST]
DATABASE_PASSWORD=[any given password; only used locally]
DATABASE_USERNAME=[any given username; only used locally]
DATABASE_NAME=physicians_and_mentors_development
```

## First Time Setup or missing image/containers, run the following script with docker desktop up and running:
```
./build_local.sh
```
### NEXT STEP IS TO INITIALIZE DATABASE (as given by the two choices below)
#### Option 1: (IN CONTAINER BASH) run this to set up database locally:
```
rails db:create
rails db:migrate
```

#### Option 2: (OUTSIDE OF CONTAINER BASH) OR run this to pull to local db from the heroku database
```
./pull_heroku_db.sh
```

## To connect to existing container's command line / bash, wether its running or not, run this script:
```
./connect_local.sh
```

## (IN CONTAINER BASH) To locally host app, make a rails server with the command:
```
rails s -b 0.0.0.0
```

## (IN CONTAINER BASH) to run tests:
```
bundle exec rspec
```