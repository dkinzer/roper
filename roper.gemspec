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

  spec.add_dependency "docker-compose", "~> 1.1"
  spec.add_dependency "git", "~> 1.3"
  spec.add_dependency "gli", "~> 2.17"
  spec.add_dependency "netrc", "~> 0.11"
  spec.add_dependency "octokit", "~> 4.8"

  spec.add_development_dependency "binding_of_caller", "~> 1.0"
  spec.add_development_dependency "coveralls", "~> 0.7"
  spec.add_development_dependency "guard", "~> 2.14"
  spec.add_development_dependency "guard-rspec", "~> 4.7"
  spec.add_development_dependency "multi_json", "~> 1.12"
  spec.add_development_dependency "pry", "~> 0.11"
  spec.add_development_dependency "pry-byebug", "~> 3.5"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 1.0"
  spec.add_development_dependency "vcr", "~> 6.0"
  spec.add_development_dependency "webmock", "~> 3.2"

end
