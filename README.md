# Physicians and Mentors


## TO MAKE SURE SCRIPTS CAN BE RAN, RUN THE FOLLOWING: with dos2unix installed!
'''
chmod +x build_local.sh
chmod +x connect_local.sh
dos2unix build_local.sh
dos2unix connect_local.sh
'''
* Addendum- make sure these environment variables are set before running the build_local script!
'''
'''


## First Time Setup or missing image/containers, run the following script with docker desktop up and running:
'''
./build_local.sh
'''

### (IN CONTAINER BASH) also run this to setup the db:
'''
rails db:create
rails db:migrate
'''


## To connect to existing container's command line / bash, wether its running or not, run this script:
'''
./connect_local.sh
'''


## (IN CONTAINER BASH) To Pull from Heroku Postgres database to local:
### Login to heroku first:
'''
heroku login
'''
* and click the link provided to log in

### Run this to pull from the heroku database:
'''
heroku pg:pull DATABASE_URL mylocaldb --app example-app
heroku pg:pull DATABASE_URL localdb --app p-a-m-test-app
'''
#### The DATABASE_URL can be found in Heroku config variables under the test app.


## (IN CONTAINER BASH) To locally host app, make a rails server with the command:
rails s -b 0.0.0.0

The database url can be found in Heroku config variables under the test app.