# frozen_string_literal: true

require "git"
require "octokit"
require "fileutils"

module Roper
  class Repo
    def initialize(repo, branch)
      @branch = branch
      @repo = Octokit::Repository.new(repo)
      @mount_path = Roper::mount_path(repo, branch)
    end

    def mount
      Git.clone(@repo.url, @mount_path)
        .checkout(@branch) rescue nil
    end

    def update
      Git.open(@mount_path)
        .pull("origin", @branch)
    end

    def unmount
      FileUtils.rm_r(@mount_path)
    end

    def ref
      Git.open(@mount_path).object("HEAD").sha
    end
  end
end
