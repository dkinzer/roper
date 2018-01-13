# frozen_string_literal: true

require "octokit"
require "netrc"
require "json"

module Roper
  class Hub
    def initialize(repo, ref)
      @repo = repo
      @ref = ref
      @client = Octokit::Client.new(netrc: true)
    end

    def create_status(state, options = {})
      @client.create_status(@repo, @ref, state, options.merge(context: "Roper Stager"))
    end
  end
end
