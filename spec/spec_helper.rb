# frozen_string_literal: true

require "coveralls"
Coveralls.wear!

require "bundler/setup"
require "roper"
require "pry"
require "pry-byebug"
require "binding_of_caller"
require "webmock/rspec"
require "vcr"
require "json"
require "netrc"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:all) do
    @test_repo = "tulibraries/tul_cob"
    @test_ref = "b492f9df84fa8f26328cf220b401795d321cfeb6"
    @test_branch = "foobar"
  end
end

def debugger
  Pry.start(binding.of_caller(1))
end

alias :debug :debugger
alias :bp :debugger

VCR.configure do |c|
  c.configure_rspec_metadata!

  c.filter_sensitive_data("<<ACCESS_TOKEN>>") do
    Netrc.read("#{ENV['HOME']}/.netrc")["api.github.com"][1] rescue "x" * 40
  end

  c.filter_sensitive_data("<<GITHUB_LOGIN>>") do
    Netrc.read("#{ENV['HOME']}/.netrc")["api.github.com"][0] rescue  "github-api-user"
  end

  c.default_cassette_options = {
    serialize_with: :json,
    preserve_exact_body_bytes: true,
    decode_compressed_response: true,
    record: ENV["TRAVIS"] ? :none : :once
  }
  c.cassette_library_dir = "spec/cassettes"
  c.hook_into :webmock
end

def github_url(url)
  return url if url =~ /^http/

  url = File.join(Octokit.api_endpoint, url)
  uri = Addressable::URI.parse(url)
  uri.path.gsub!("v3//", "v3/")

  uri.to_s
end
