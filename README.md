# Roper [![Build Status](https://travis-ci.org/tulibraries/roper.svg?branch=master)](https://travis-ci.org/tulibraries/roper)

Roper is a cli tool used to help stage a dockerized web app.  There are some
assumptions made about the environment that roper runs in.  The main one is
that traefik has been configured to run via the docker backend and that the
dockerized web application uses a docker-compose.yml file that knows how to
communicate with traefik.

Another assuption made is that the repository for the web applications roper is
concerned with lives at GitHub: At this point I have no intention of supporting
another git repository service.

Once Roper is configured it knows how to:
* Post to a GitHub branch PR with an in progress status for the
  stage site setup. (TODO: make optional)
* Pull in a repo locally.
* Checkout a specific branch.
* Start docker-compose session
* Post back to GitHub branch PR with link for QA site or failure
  status. (TODO: make optinal)
* When a PR is merged or closed the resources can be released/recovered.

At this point Roper only defines a cli interface so there is no way for GitHub
to communicate with it direclty via a webhook or whatnot. It's assumed that it
will be used in conjuction with a service like jenkins ci to handle the webook
part of the communication and trigger a roper staging on a desired Github event
(PR creation, update to PR, merge of PR).

Eventually it would be nice for Roper to include a web service interface that
GitHub can post direclty to. But then again, that might just be scope creep
considering there are already good options for handling the webhook concern
(i.e. jenkins)

## Installation

Add this line to your application's Gemfile:

```ruby gem 'roper' ```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install roper

## Usage

`roper lasso "--repo=<REPO_OWNER>/<REPO_NAME>" [--branch=<BRANCH_NAME>] [--status-url=<STATUS_URL>]`

`roper release "--repo=<REPO_OWNER>/<REPO_NAME>" [--branch=<BRANCH_NAME>]`

OR:

You can use the individual components of the library as you wish.

## Github Authentication
Currenlty Roper uses netrc for github authentication.  I'm hoping to slap an interface to create this at setup but for now you will need to add a ~/.netrc file with an entry for `api.github.com` manually.

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
conduct](https://github.com/tulibraries/roper/blob/master/CODE_OF_CONDUCT.md).
