== NZSL 

New Zealand Sign Language Dictionary consists of 2 major units
 # Ruby on Rails Website (this repo)
 # Freelex, and open source project for maintaining the signs lexicon data.


== Deployment

Current servers (2015-03-03)

_Staging_ is on http://nzsl.staging.rabid.co.nz, an ubuntu server. The App lives behind nginx and unicorn. (This is different to production). 

_Production_ is on http://nzsl.vuw.ac.nz, on a legacy VM @ Victoria University. This is near end of life. This app lives behind Apache and Passenger. The VM is maintained and monitored by VUW staff.

All instances use a SQLLite database.


Deploy to servers using Capistrana.

```
	nzsld$ bundle exec cap deploy staging
```


== Notes

* The development application uses [mailcatcher](http://mailcatcher.me/) to intercept outgoing mail
