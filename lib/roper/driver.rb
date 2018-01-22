# frozen_string_literal: true

require "docker/compose"

module Roper
  # This class is concerned with docker-compose process
  class Driver
    # @param [String] repo A GitHub reposiory in the form <user>/<name>
    # @param [branch] the name of a branch in the reposiory
    def initialize(repo, branch)
      @repo = Octokit::Repository.new(repo)
      @branch = branch
      @mount_path = Roper::mount_path(repo, branch)
      @compose = Docker::Compose::Session.new(dir: @mount_path)
    end

    # Runs docker-compose up in detached mode with a forced rebuild
    def up
      set_env_variables
      @compose.up(detached: true, build: true)
    end

    # Runs docker-compose down
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
