# Roper [![Build Status](https://travis-ci.org/tulibraries/roper.svg?branch=main)](https://travis-ci.org/tulibraries/roper) [![Coverage Status](https://coveralls.io/repos/github/tulibraries/roper/badge.svg?branch=main)](https://coveralls.io/github/tulibraries/roper?branch=main) [![Docs](https://img.shields.io/badge/docs-rubydoc-blue.svg)](http://www.rubydoc.info/github/tulibraries/roper/main)

<p align="center"><img src="Figure-eight_knot.svg"></p>

Roper is a CLI tool used to help stage a Dockerized web app.  It's name is
a play on it's two main commands (`lasso` and `release`).

There are some assumptions made about the environment that roper runs in.  The
main one is that Traefik has been configured to run via the docker back-end and
that the Dockerized web application uses a `docker-compose.ym` file that knows
how to communicate with Traefik.

Another assumption made is that the repository for the web applications roper is
concerned with lives at GitHub: At this point I have no intention of supporting
another git repository service.

Once Roper is configured it knows how to:
* Post to a GitHub branch PR with an in progress status for the
  stage site setup.
* Pull in a repo locally.
* Checkout a specific branch.
* Start docker-compose session
* Post back to GitHub branch PR with link for QA site or failure
  status.
* When a PR is merged or closed the resources can be released/recovered.

Roper also defines the following environment variables which are made available
during the `docker-compose up` phase and can therefore be referenced in your
`docker-compose.yml` file

| variable | description |
| -------- | ------------|
| ROPER_REPO_OWNER | The GitHub repository owner |
| ROPER_REPO_NAME | The GitHub repository name |
| ROPER_REPO_BRANCH | The GitHub repository branch |

Currently, Roper only defines a CLI interface so there is no way for GitHub
to communicate with it directly via a web-hook or whatnot. It's assumed that it
will be used in conjunction with a service like Jenkins CI to handle the web-hook
part of the communication and trigger a roper staging on a desired GitHub event
(PR creation, update to PR, merge of PR).

Eventually it would be nice for Roper to include a web service interface that
GitHub can post directly to. But then again, that might just be scope creep
considering there are already good options for handling the web-hook concern
(i.e. Jenkins)

## Installation

Add this line to your application's Gemfile:

```
ruby gem 'roper'
```

And then execute:

```
bundle
```
Or install it yourself as:

```
gem install roper
```

## Usage

`roper lasso --repo=<user>/<repo> [--branch=<branch>] [--status_url=<url>]`

`roper release --repo=<user>/<repo>`

OR:

You can use the individual components of the library as you wish.

## Configuration
`roper` is configure ready. Use `roper initconfig`. This command will create
a `.roper.rc` configuration file in your home directory.  The file is in yaml
format and you can provide default arguments for any roper command.

The following `roper.rc` configuration file example provides a default value
for the repository:

```
---
:version: false
:help: false
commands:
  :lasso:
    :r: "tulibraries/tul_cob"
  :release:
    :r: "tulibraries/tul_cob"
```


## Github Authentication
Currenlty Roper uses netrc for github authentication.  I'm hoping to slap an
interface to create this at setup but for now you will need to add a ~/.netrc
file with an entry for `api.github.com` manually.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/tulibraries/roper. This project is intended to be a safe,
welcoming space for collaboration, and contributors are expected to adhere to
the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT
License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Roper project’s codebases, issue trackers, chat
rooms and mailing lists is expected to follow the [code of
conduct](https://github.com/tulibraries/roper/blob/main/CODE_OF_CONDUCT.md).
