# NZSL

New Zealand Sign Language Dictionary consists of 2 major units
* Ruby on Rails Website (this repo)
* Freelex, and open source project for maintaining the signs lexicon data.

[![Build Status](https://travis-ci.org/rabid/nzsl-online.svg?branch=master)](https://travis-ci.org/rabid/nzsl-online)
[![Code Climate](https://codeclimate.com/github/rabid/nzsl-online/badges/gpa.svg)](https://codeclimate.com/github/rabid/nzsl-online)
[![Test Coverage](https://codeclimate.com/github/rabid/nzsl-online/badges/coverage.svg)](https://codeclimate.com/github/rabid/nzsl-online/coverage)
[![Issue Count](https://codeclimate.com/github/rabid/nzsl-online/badges/issue_count.svg)](https://codeclimate.com/github/rabid/nzsl-online)

## Deployment

`staging` branch deploys to Staging

`master` branch deploy to Production.

Both deploy by heroku monitoring the github repo and pulling in the changes if it sees the tests pass.


## Servers

Current servers (2016-05-30

*Staging*: http://nzsl-staging.herokuapp.com

*Production* is on  heroku: http://nzsl.herokuapp.com. (http://nzsl.nz/)


## Dev environment set up

1. Clone from git
1. cp env-example .env
1. bundle
1. bundle exec rails s

