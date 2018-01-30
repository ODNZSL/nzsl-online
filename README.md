# NZSL

New Zealand Sign Language Dictionary consists of 2 major units
* Ruby on Rails Website (this repo)
* Freelex, and open source project for maintaining the signs lexicon data.

[![Build Status](https://travis-ci.org/rabid/nzsl-online.svg?branch=master)](https://travis-ci.org/rabid/nzsl-online)
[![Code Climate](https://codeclimate.com/github/rabid/nzsl-online/badges/gpa.svg)](https://codeclimate.com/github/rabid/nzsl-online)
[![Test Coverage](https://codeclimate.com/github/rabid/nzsl-online/badges/coverage.svg)](https://codeclimate.com/github/rabid/nzsl-online/coverage)
[![Issue Count](https://codeclimate.com/github/rabid/nzsl-online/badges/issue_count.svg)](https://codeclimate.com/github/rabid/nzsl-online)

## Deployment

NZSL has taken ownership of the project at their [ODNZSL repo](https://github.com/ODNZSL/nzsl-online), with the Rabid Repo being forked from this.

Rabideers should branch from the rabid staging branch when resolving issues or adding features. Their pull requested should be to the ODNSL staging branch, rather than the Rabid Staging branch. The Rabid Admin for ODNZSL is currently [Elspeth Dick](elspeth@rabidtech.co.nz); upon approval and merge, Rabid should merge the ODNZSL staging branch to the Rabid staging branch so that our repo is up-to-date.

ODNZSL staging deploys to http://nzsl-staging.herokuapp.com.

## Servers

Current servers (2017-12-15)

*Staging*: http://nzsl-staging.herokuapp.com

*Production* is on  heroku: http://nzsl.herokuapp.com. (http://nzsl.nz/)


## Dev environment set up

1. Clone from git
1. cp env-example .env
1. bundle
1. bundle exec rails s

