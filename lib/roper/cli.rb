# frozen_string_literal: true

require "roper/version"
require "roper/repo"
require "roper/hub"
require "roper/driver"

module Roper
  class CLI
    def initialize(repo, branch, options = {})
      @branch = branch
      @options = options
      @git = Roper::Repo.new(repo, branch)
      @driver = Roper::Driver.new(repo, branch)
      @hub = Roper::Hub.new(repo, ref)
    end

    def self.lasso(repo, branch, options = {})
      self.new(repo, branch, options).lasso
    end

    def self.release(repo, branch, options = {})
      self.new(repo, branch, options).release
    end

    def lasso
      @hub.create_status("pending", status_pending.merge(status_url))
      begin
        @git.mount || @git.update
        @driver.up
        @hub.create_status("success", status_success.merge(success_url))
      rescue
        @hub.create_status("failure", status_failure.merge(status_url))
      end
    end

    def release
      @driver.down
      @git.unmount
    end

    private
      def ref
        @options[:ref] || begin
          @git.mount || @git.update
          @git.ref
        end
      end

      def status_url
        status_url = @options[:status_url]
        status_url ? { status_url: status_url } : {}
      end

      def success_url
        protocol = @options[:protocol] || "https"
        domain = @options[:domain] || ENV["DOMAIN"]
        {  status_url: "#{protocol}://#{@branch}.#{domain}" }
      end

      def status_pending
        { description: "The build process is in progress." }
      end

      def status_error
        { description: "The build process had irrecoverrable error." }
      end

      def status_failure
        { description: "The PR branch failed to build." }
      end

      def status_success
        { description: "The PR brach was successfully built." }
      end
  end
end
