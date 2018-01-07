# frozen_string_literal: true

require "roper/cli"
require "gli"

module Roper
  # Your code goes here...
  ROOT_PATH = "#{ENV["HOME"]}/.roper"

  def self.mount_path(repo, branch)
    repo = Octokit::Repository.new(repo)
    "#{Roper::ROOT_PATH}/#{repo.owner}/#{repo.name}/#{branch}"
  end
end
