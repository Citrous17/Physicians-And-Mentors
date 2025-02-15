# Physicians and Mentors

## First Time Setup or missing image/containers, run the following script:
'''
./build_local.sh
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
#### and click the link provided to log in

### Run this to pull from the heroku database:
'''
heroku pg:pull DATABASE_URL mylocaldb --app example-app
'''
#### The DATABASE_URL can be found in Heroku config variables under the test app.


## (IN CONTAINER BASH) To locally host app, make a rails server with the command:
'''
rails s -b 0.0.0.0
'''

## (IN CONTAINER BASH) To apply database changes, run:
'''
db:migrate
'''