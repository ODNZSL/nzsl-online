# NZSL 

New Zealand Sign Language Dictionary consists of 2 major units
* Ruby on Rails Website (this repo)
* Freelex, and open source project for maintaining the signs lexicon data.

[ ![Codeship Status for rabidtech/nzsl](https://codeship.com/projects/e3e03080-8d5e-0132-422a-669677a474c3/status?branch=master)](https://codeship.com/projects/60682)

## Deployment

Current servers (2015-03-03)

*Staging* is on http://nzsl.staging.rabid.co.nz, an ubuntu server. The App lives behind nginx and unicorn. (This is different to production). 

*Production* is on http://nzsl.vuw.ac.nz, on a legacy VM @ Victoria University. This is near end of life. This app lives behind Apache and Passenger. The VM is maintained and monitored by VUW staff.

All instances use a SQLLite database.


Deploy to servers using Capistrana.

```
	nzsld$ bundle exec cap deploy staging
```