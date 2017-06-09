# NZSL

New Zealand Sign Language Dictionary consists of 2 major units
* Ruby on Rails Website (this repo)
* Freelex, and open source project for maintaining the signs lexicon data.
[ ![Codeship Status for rabidtech/nzsl](https://app.codeship.com/projects/842bb6e0-c58b-0134-119d-0ea6e9886ab2/status?branch=master)](https://app.codeship.com/projects/198337)

## Deployment

`staging` branch deploys to Staging 

`master` branch deploy to Production.

both deploy via codeship.

## Servers

Current servers (2016-05-30

*Staging*: http://nzsl-staging.herokuapp.com

*Pre-Prod* is on  heroku: http://nzsl.herokuapp.com.

*Production* is on http://nzsl.vuw.ac.nz, on a legacy VM @ Victoria University. This is near end of life. This app lives behind Apache and Passenger. The VM is maintained and monitored by VUW staff.
Note: This instance at VUW runs from a SQLLite database

## Dev environment set up

1. Clone from git
1. cp env-example .env
1. bundle
1. bundle exec rails s
