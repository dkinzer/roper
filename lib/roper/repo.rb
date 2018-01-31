# frozen_string_literal: true

require "git"
require "octokit"
require "fileutils"

module Roper
  # This class is concerned with the repository resource itself
  class Repo
    # @param [String] repo A GitHub reposiory in the form <user>/<name>
    # @param [String] branch The name of a branch in the reposiory
    def initialize(repo, branch)
      @branch = branch
      @repo = Octokit::Repository.new(repo)
      @mount_path = Roper::mount_path(repo, branch)
    end

    # Pulls in the initialized repository and checkout the initialized branch
    def mount
      Git.clone(@repo.url, @mount_path)
        .checkout(@branch) rescue nil
    end

    # Pulls the latest commit to branch from origin
    def update
      Git.open(@mount_path)
        .pull("origin", @branch)
    end

    # Deletes the local copy of the reposiory
    def unmount
      FileUtils.rm_r(@mount_path)
    end

    # Helper function to get HEAD commit sha for the initialized branch
    def ref
      Git.open(@mount_path).object("HEAD").sha
    end
  end
end
