# frozen_string_literal: true

require "octokit"
require "netrc"
require "json"

module Roper
  class Hub
    def initialize(repo)
      @repo = repo
      @client = Octokit::Client.new(netrc: true)
    end

    def create_status(ref, state, options = {})
      @client.create_status(@repo, ref, state, options.merge(context: "Roper Stager"))
    end
  end
end
