# NZSL

New Zealand Sign Language Dictionary consists of 2 major units
* Ruby on Rails Website (this repo)
* Freelex, and open source project for maintaining the signs lexicon data.

[ ![Codeship Status for rabidtech/nzsl](https://app.codeship.com/projects/842bb6e0-c58b-0134-119d-0ea6e9886ab2/status?branch=master)](https://app.codeship.com/projects/198337)

## Deployment

Current servers (2016-12-19)

*Staging*: Does not exist anymore.

*Production* is on http://nzsl.vuw.ac.nz, on a legacy VM @ Victoria University. This is near end of life. This app lives behind Apache and Passenger. The VM is maintained and monitored by VUW staff.

*Pre-Prod* is on  heroku: http://nzsl.herokuapp.com. A matching staging is http://nzsl-staging.herokuapp.com

All instances use a SQLLite database.

Deploy to servers using Capistrana.

Staging:

```
  nzsld$ bundle exec cap staging deploy
```

Production
```
  nzsld$ bundle exec cap production deploy
```
