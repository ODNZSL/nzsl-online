# NZSL

## New Zealand Sign Language Dictionary

![Image of a NZSL search results page]
(assets/images/img/NZSl_search_results_example)

## Aotearoa's official sign language

New Zealand Sign Language (NZSL) is an official language of Aotearoa New Zealand. Like Te Reo Māori, it is important to foster understanding and use of the language in order to be an inclusive society. Victoria University of Wellington's Deaf Studies Research Unit (DSRU) produced the first paper based dictionary of NZSL 1997. An updated online dictionary website launched in 2011. The online dictionary contains over 5000 signs with equivalents in both English and Te Māori with image and video references showing how a sign is produced and example videos showing how the sign is used in context. The online dictionary can be searched by the English or Te Reo Māori word, or by sign features, such as hand shape and location.

New Zealand Sign Language Dictionary consists of 2 major units
* Ruby on Rails Website (this repo)
* Freelex, and open source project for maintaining the signs lexicon data.

[![Build Status](https://travis-ci.org/ODNZSL/nzsl-online.svg?branch=master)](https://travis-ci.org/ODNZSL/nzsl-online)
[![Code Climate](https://codeclimate.com/github/ODNZSL/nzsl-online/badges/gpa.svg)](https://codeclimate.com/github/ODNZSL/nzsl-online)
[![Test Coverage](https://codeclimate.com/github/ODNZSL/nzsl-online/badges/coverage.svg)](https://codeclimate.com/github/ODNZSL/nzsl-online/coverage)
[![Issue Count](https://codeclimate.com/github/ODNZSL/nzsl-online/badges/issue_count.svg)](https://codeclimate.com/github/ODNZSL/nzsl-online)

## Set Up

```
git clone https://github.com/rabid/nzsl-online.git
cp env-example .env
bundle
yarn
bundle exec rails s
```

## Deployment

NZSL has taken ownership of the project at their [ODNZSL repo](https://github.com/ODNZSL/nzsl-online), with the Rabid Repo being forked from this.

Rabideers should branch from the Rabid Staging branch when resolving issues or adding features. Their pull requests should be to the ODNZSL Staging branch, rather than the Rabid Staging branch. The Rabid admin for ODNZSL is currently [Elspeth Dick](elspeth@rabidtech.co.nz); upon approval and merging, Rabid should merge the ODNZSL staging branch to the Rabid staging branch so that our repo is up-to-date.

To deploy to production: merge ONZSL staging to ODNZSL master.

## Environments:

Current servers (2017-12-15)

| Environment        | URL                                       | Git Branch | Status       |
|--------------------|-------------------------------------------|------------|--------------|
| ODNZSL Staging     | http://nzsl-staging.herokuapp.com/        | staging    | staging      |
| ODNZSL Production  | http://nzsl.herokuapp.com/                | master     | live         |
