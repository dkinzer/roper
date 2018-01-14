# frozen_string_literal: true

require "docker/compose"

module Roper
  class Driver
    def initialize(repo, branch)
      @repo = Octokit::Repository.new(repo)
      @branch = branch
      @mount_path = Roper::mount_path(repo, branch)
      @compose = Docker::Compose::Session.new(dir: @mount_path)
    end

    def up
      set_env_variables
      @compose.up(detached: true)
    end

    def down
      @compose.down
    end

    private
      def set_env_variables
        ENV["ROPER_REPO_OWNER"] = @repo.owner
        ENV["ROPER_REPO_NAME"] = @repo.name
        ENV["ROPER_REPO_BRANCH"] = @branch
      end
  end
end
