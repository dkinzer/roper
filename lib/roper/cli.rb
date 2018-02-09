# frozen_string_literal: true

require "roper/version"
require "roper/repo"
require "roper/hub"
require "roper/driver"

module Roper
  # This is a controller, and the main entry point into the rest of the
  # library.  It composes Hub, Repo and Driver to define the main entry
  # methods, lasso and release.
  class CLI
    # @param [String] repo A GitHub repository in the form <user>/<name>
    # @param [String] branch The name of a branch in the repository
    #
    # @param [Hash] options A customizable set of options
    # @option options [String] :context A context to differentiate this status from others (default: "roper")
    # @option options [String] :status_url A link to more details about this status
    # @option options [String] :sha ref The sha for a commit
    # @option options [String] :protocol https or http
    # @option options [String] :domain Domain for Traefik server
    def initialize(repo, branch, options = {})
      @repo = repo
      @branch = branch
      @options = options
      @git = Roper::Repo.new(repo, branch)
      @driver = Roper::Driver.new(repo, branch)
    end

    # Creates an instance of CLI and runs release
    #
    # @see initialize
    # @see release
    def self.lasso(repo, branch, options = {})
      self.new(repo, branch, options).lasso
    end

    # Creates an instance of CLI and runs lasso
    #
    # @see initialize
    # @see lasso
    def self.release(repo, branch, options = {})
      self.new(repo, branch, options).release
    end

    # Update the GitHub PR with a pending status, then pull in the repository
    # and build it by running docker-compose up on it
    def lasso
      @hub ||= Roper::Hub.new(@repo, ref)
      @hub.create_status("pending", status_pending.merge(status_url))
      begin
        @git.mount || @git.update
        @driver.up
        @hub.create_status("success", status_success.merge(success_url))
      rescue
        @hub.create_status("failure", status_failure.merge(status_url))
      end
    end

    # Run docker-compose down on the project and delete the assets
    def release
      @driver.down
      @git.unmount
    end

    private
      def ref
        @options[:sha] || begin
          @git.mount || @git.update
          @git.ref
        end
      end

      def status_url
        status_url = @options[:status_url]
        status_url ? { target_url: status_url } : {}
      end

      def success_url
        protocol = @options[:protocol] || "https"
        domain = @options[:domain] || ENV["DOMAIN"]
        {  target_url: "#{protocol}://#{@branch}.#{domain}" }
      end

      def status_pending
        { description: "The build process is in progress." }
      end

      def status_failure
        { description: "The PR branch failed to build." }
      end

      def status_success
        { description: "The PR brach was successfully built." }
      end
  end
end
