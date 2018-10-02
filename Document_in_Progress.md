# [NZSL](https://www.nzsl.nz)

## This Document is a work in progress and will become the README for this repo

## New Zealand Sign Language Dictionary

![Image of a NZSL search results page](/images/NZSl_search_results_example.png)

I think we need the following 2 non-tech sections to give context?

## Aotearoa's official sign language

New Zealand Sign Language (NZSL) is an official language of Aotearoa New Zealand. Like [Te Reo Māori](https://www.tpk.govt.nz/en/whakamahia/te-reo-maori) , it is important to foster understanding and use of the language in order to be an inclusive society. Victoria University of Wellington's Deaf Studies Research Unit [DSRU](https://www.victoria.ac.nz/lals/centres-and-institutes/dsru) produced the first paper based dictionary of NZSL 1997. An updated online dictionary website launched in 2011. The online dictionary contains over 5000 signs with equivalents in both English and Te Reo Māori with image and video references showing how a sign is produced and example videos showing how the sign is used in context. The online dictionary can be searched by the English or Te Reo Māori word, or by sign features, such as hand shape and location.

## Website and Apps

In 2013 [Ackama](https://www.ackama.com/) took over responsibility for the website and both the iOS and Android apps, which were originally built by an independent developer. As well as maintenance and open sourcing, both the website and the apps required considerable updating and redesign. We worked closely with the language experts at DSRU and with other developers including Dave Moskovitz (need github link), the creator of the ‘Freelex’ database that provides the back-end for the website, and Greg Hewgill (need github link), the developer of the original mobile app. Although much of this work was funded through grants obtained by the DSRU from the NZSL Fund and other sources, Ackama has also sponsored and funded time on the project and Ackama staff have also volunteered their own investment time to contribute to the project.

Together with the DSRU, Ackama went on a journey from using open source technology for reasons of price and flexibility to building an entirely open source ecosystem whereby the website, apps, data and scripts are all open source technical components which work together to provide the NZSL dictionary. The community has access to all of these components and can improve upon them or add new features. By open sourcing the NZSL dictionary we encourage the wider community to be involved in making NZSL more accessible. We are also enabling international reuse of the codebase for other countries to have a technical head start in creating their own online sign language dictionary.

In May 2018 the NZSL Android app got up to the number 6 ranking in the worldwide category “Top Free in Books and Reference” apps on Google Play.

New Zealand Sign Language Dictionary consists of 3 major units
* Ruby on Rails Website (this repo)
* Mobile apps <add address>
* Freelex, (add address) an open source project for maintaining the signs lexicon data.

[![Build Status](https://travis-ci.org/ODNZSL/nzsl-online.svg?branch=master)](https://travis-ci.org/ODNZSL/nzsl-online)
[![Code Climate](https://codeclimate.com/github/ODNZSL/nzsl-online/badges/gpa.svg)](https://codeclimate.com/github/ODNZSL/nzsl-online)
[![Test Coverage](https://codeclimate.com/github/ODNZSL/nzsl-online/badges/coverage.svg)](https://codeclimate.com/github/ODNZSL/nzsl-online/coverage)
[![Issue Count](https://codeclimate.com/github/ODNZSL/nzsl-online/badges/issue_count.svg)](https://codeclimate.com/github/ODNZSL/nzsl-online)

## The Set Up for you wonderful open source contributors

Please read carefully the CONTRIBUTORS.md (add link?) before you follow the setup steps.

Fork the official repo [ODNZSL repo](https://github.com/ODNZSL/nzsl-online), so you have a copy.
Clone your copy

```
git clone <your copy>
cp env-example .env
bundle
yarn
bundle exec rails s
```
A suggestion is to create a local staging branch ( You can really call it what you want ) that acts as your local master. Then branch from your staging/master branch when resolving issues or adding features.

Create your feature branch. For example `NZSL-##Bugfix/Back-to-search-results`
Make changes
Commit you changes
Push to the base staging branch 
Create a new pull request

## Issues (user stories) that require design and a design process

a high level design story outcome from design team

## Brand guidelines

## Tech requirements ??

Ruby on Rails, HAML, BEM

## Release History ??

## Meta ??

## Deployment

NZSL has taken ownership of the project at their [ODNZSL repo](https://github.com/ODNZSL/nzsl-online).

Open source contributors pull requests should be to the ODNZSL Staging branch. The admin for ODNZSL is currently [Elspeth Dick](elspeth@rabidtech.co.nz).

Open source contributors should merge the ODNZSL staging branch to your local staging branch so that your repo is up-to-date.


To deploy to production: merge ONZSL staging to ODNZSL master.

## Environments:

Current servers (2017-12-15)

| Environment        | URL                                       | Git Branch | Status       |
|--------------------|-------------------------------------------|------------|--------------|
| ODNZSL Staging     | http://nzsl-staging.herokuapp.com/        | staging    | staging      |
| ODNZSL Production  | http://nzsl.herokuapp.com/                | master     | live         |
