# frozen_string_literal: true

require "octokit"
require "netrc"
require "json"

module Roper
  # This class is concerned with GitHub API communications.
  class Hub
    # Create and instance of the Hub class
    #
    # @param [String] repo A GitHub reposiory in the form <user>/<name>
    # @param [String] ref The sha for a commit
    def initialize(repo, ref)
      @repo = repo
      @ref = ref
      @client = Octokit::Client.new(netrc: true)
    end

    # Changes the status on a GitHub PR
    #
    # @see https://octokit.github.io/octokit.rb/Octokit/Client/Statuses.html
    #
    # @param state [String] The state: pending, success, failure
    # @param options [Hash] A customizable set of options
    #
    # @options :context [String] A context to differentiate this status from others (default: "roper")
    # @options :target_url [String] A link to more details about this status
    # @options :description [String] A short human-readable description of this status
    #
    # @return [Sawyer::Resource] A short human-readable description of this status
    def create_status(state, options = {})
      @client.create_status(@repo, @ref, state, options.merge(context: "roper"))
    end
  end
end
