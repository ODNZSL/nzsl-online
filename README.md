
<a href="https://www.nzsl.nz" target="_blank"><h1>NZSL</h1></a>

## New Zealand Sign Language Dictionary

## Aotearoa's official sign language


<a href="https://www.odi.govt.nz/nzsl/about" target="_blank">New Zealand Sign Language (NZSL)</a> is an official language of Aotearoa New Zealand. Like <a href="https://www.tpk.govt.nz/en/whakamahia/te-reo-maori" target="_blank">Te Reo Māori</a>, it is important to foster understanding and use of the language in order to be an inclusive society. Victoria University of Wellington's <a href="https://www.victoria.ac.nz/lals/centres-and-institutes/dsru" target="_blank">Deaf Studies Research Unit (DSRU)</a> produced the first paper based dictionary of NZSL 1997. An updated online dictionary website launched in 2011. The online dictionary contains over 5000 signs with equivalents in both English and Te Reo Māori with image and video references showing how a sign is produced and example videos showing how the sign is used in context. The online dictionary can be searched by the English or Te Reo Māori word, or by sign features, such as hand shape and location.

## Website and Apps

In 2013 <a href="https://www.ackama.com/" target="_blank">Ackama</a> took over responsibility for the website and both the iOS and Android apps, which were originally built by an independent developer. As well as maintenance and open sourcing, both the website and the apps required considerable updating and redesign. We worked closely with the language experts at DSRU and with other developers including <a href="https://dave.moskovitz.co.nz" target="_blank">Dave Moskovitz</a>, the creator of the ‘Freelex’ database that provides the back-end for the website, and
<a href="https://hewgill.com" target="_blank">Greg Hewgill</a>, the developer of the original mobile app. Although much of this work was funded through grants obtained by the DSRU from the <a href="https://www.odi.govt.nz/nzsl/nzsl-fund/" target="_blank">NZSL Fund</a> and other sources, Ackama has also sponsored and funded time on the project and Ackama staff have also volunteered their own investment time to contribute to the project.

Together with the DSRU, Ackama went on a journey from using open source technology for reasons of price and flexibility to building an entirely open source ecosystem whereby the website, apps, data and scripts are all open source technical components which work together to provide the NZSL dictionary. The community has access to all of these components and can improve upon them or add new features. By open sourcing the NZSL dictionary we encourage the wider community to be involved in making NZSL more accessible. We are also enabling international reuse of the codebase for other countries to have a technical head start in creating their own online sign language dictionary.

In May 2018 the NZSL Android app got up to the number 6 ranking in the worldwide category “Top Free in Books and Reference” apps on Google Play.

New Zealand Sign Language Dictionary consists of 3 major units
* Ruby on Rails Website (this repo)
* Mobile apps (transfer of ownership currently in motion)
* Freelex, an open source project for maintaining the signs lexicon data.

[![Build Status](https://travis-ci.org/ODNZSL/nzsl-online.svg?branch=master)](https://travis-ci.org/ODNZSL/nzsl-online)
[![Code Climate](https://codeclimate.com/github/ODNZSL/nzsl-online/badges/gpa.svg)](https://codeclimate.com/github/ODNZSL/nzsl-online)
[![Test Coverage](https://codeclimate.com/github/ODNZSL/nzsl-online/badges/coverage.svg)](https://codeclimate.com/github/ODNZSL/nzsl-online/coverage)
[![Issue Count](https://codeclimate.com/github/ODNZSL/nzsl-online/badges/issue_count.svg)](https://codeclimate.com/github/ODNZSL/nzsl-online)
[![Waffle.io - Columns and their card count](https://badge.waffle.io/ODNZSL/nzsl-online.svg?columns=all)](https://waffle.io/ODNZSL/nzsl-online)

## Getting Started

Please read the accompanying CONTRIBUTING.md (in progress) before you follow the setup steps.

Fork the base repo [ODNZSL repo](https://github.com/ODNZSL/nzsl-online), so you have a copy then clone your fork.

```
git clone <your fork>
cp env-example .env
bundle
yarn
bundle exec rspec spec

```

A suggestion is to create a local staging branch that acts as your local master. Then branch from your staging/master branch when resolving issues or adding features.

  * Create your feature branch. For example `Bugfix/Back-to-search-results`
  * Make changes
  * Commit your changes
  * Push to your remote branch. For example `git push origin <your feature branch>`
  * Ensure all changes to existing functionality and additions of new functionality have tests
  * Create a new pull request to the ODNZSL Staging branch.
  * If you are not sure on any of the steps please do not hesitate to ask.
  * The PR process requires that 2 reviewers must approve before the PR progresses.
  * [Waffle](https://waffle.io) is used for project management. Contributors sign in with your github username.

## Running the tests

`bundle exec rails test`

## Design and brand guidelines  

  * The design should follow brand guidelines (Link TBA)
  * The design must follow [accessibility guidelines](https://material.io/design/usability/accessibility.html#composition)
  * Must follow the sign off process
  * Choose a story from the backlog
  * Get any other information you might need from the product owner
  * Create your design
  * Present to product owner and iterate depending on feedback
  * Once the product owner is happy with the design and signs off on it, then it can go to the development team.
  * The Ackama team uses Sketch app to create their designs. We recommend using Sketch when working on this project.  [Sketch](https://www.sketchapp.com/)

## Brand guidelines

Functionality over Form

Because of the visual nature of NZSL, it is important that the videos take centre stage and are not obscured by playback controls or watermarks.

## Deployment

NZSL has taken ownership of the project at their [ODNZSL repo](https://github.com/ODNZSL/nzsl-online).

Open source contributors pull requests should be to the ODNZSL Staging branch. The administrators for ODNZSL is currently [Elspeth Dick](https://github.com/elspeth-rabid) and [Brenda Wallace](https://github.com/Br3nda).

Open source contributors should merge the ODNZSL staging branch to your local staging branch so that your repo is up-to-date.

## The deployment process explained to open source contributors

Deployment is managed only by Brenda and Elspeth - the site administrators mentioned above.

## For site administrators

To deploy to production: merge ODNZSL staging to ODNZSL master.

## Environments:

Current servers (2017-12-15)

| Environment        | URL                                       | Git Branch | Status       |
|--------------------|-------------------------------------------|------------|--------------|
| ODNZSL Staging     | http://nzsl-staging.herokuapp.com/        | staging    | staging      |
| ODNZSL Production  | http://nzsl.herokuapp.com/                | master     | live         |

## Built with

  * [Ruby on Rails](https://rubyonrails.org) - web framework
  * [Bundler](https://bundler.io) - dependency management ++
  * [Rspec](http://rspec.info) - Ruby testing framework
  * [JQuery](https://jquery.com)- frontend javascript library
  * [HAML](http://haml.info) - frontend templating
  * [Foundation](https://foundation.zurb.com) - responsive front-end frameworks
  * [SCSS](https://sass-lang.com) - CSS extension language
  * [BEM](https://css-tricks.com/bem-101/) -  Block, Element, Modifier methodology
  * [videojs](https://docs.videojs.com/docs/guides/setup.html)

## LICENSE

This project is licensed under the GNU License - see the [GNU General Public License](https://github.com/ODNZSL/nzsl-online/blob/staging/LICENSE) for details.
