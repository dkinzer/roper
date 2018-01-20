# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "roper/version"

Gem::Specification.new do |spec|
  spec.name          = "roper"
  spec.version       = Roper::VERSION
  spec.authors       = ["David Kinzer"]
  spec.email         = ["dtkinzer@gmail.com"]

  spec.summary       = " Stages dockerized web apps in a Traefik environment. "
  spec.description   = " Command line tool for staging dockerized Github web apps in a Traefik docker environment."
  spec.homepage      = "https://github.com/tulibraries/roper"
  spec.platform      = Gem::Platform::RUBY
  spec.license       = "MIT"

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "docker-compose"
  spec.add_dependency "git"
  spec.add_dependency "gli"
  spec.add_dependency "netrc"
  spec.add_dependency "octokit"

  spec.add_development_dependency "binding_of_caller"
  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "multi_json"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"

end
