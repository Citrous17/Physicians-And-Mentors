# Physicians-and-Mentors


## TO MAKE SURE SCRIPTS CAN BE RAN, RUN the following with dos2unix installed:
'''
chmod +x build_local.sh connect_local.sh pullDB_heroku.sh
dos2unix build_local.sh connect_local.sh pullDB_heroku.sh
'''
### Make sure .env file exists and is populated with the following variables before running scripts; replace "<any ...>" && "<exact ...>" from below with actual values:
'''
GOOGLE_CLIENT_ID=<exact as found on heroku app config>
GOOGLE_CLIENT_SECRET=<exact as found on heroku app config>
IMAGE_NAME=<any given name different to pre-existing images>
HEROKU_APP=<exact app name as shown on heroku>
APP_HOST=<any given name>
DATABASE_HOST=<any given name different from APP_HOST>
DATABASE_PASSWORD=<any given password; only used locally>
DATABASE_USERNAME=<any given username; only used locally>
DATABASE_NAME=physicians_and_mentors_development
'''

## First Time Setup or missing image/containers, run the following script with docker desktop up and running:
'''
./build_local.sh
'''
### NEXT STEP IS TO INITIALIZE DATABASE (as given by the two choices below)
#### Option 1: (IN CONTAINER BASH) run this to set up database locally:
'''
rails db:create
rails db:migrate
'''

#### Option 2: (OUTSIDE OF CONTAINER BASH) OR run this to pull to local db from the heroku database
'''
./pullDB_heroku.sh
'''

## To connect to existing container's command line / bash, wether its running or not, run this script:
'''
./connect_local.sh
'''

## (IN CONTAINER BASH) To locally host app, make a rails server with the command:
rails s -b 0.0.0.0