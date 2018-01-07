# frozen_string_literal: true

require "spec_helper"

RSpec.describe Roper do
  it "has a version number" do
    expect(Roper::VERSION).not_to be nil
  end

  it "defines root path" do
    expect(Roper::ROOT_PATH).not_to be nil
  end


  let(:repo) { Octokit::Repository.new @test_repo }
  let(:path) { Roper::mount_path(@test_repo, @test_branch) }

  describe "#mount_path" do
    it "takes a repo and branch to build a mount_path" do
      expect(path).to eq("#{Roper::ROOT_PATH}/#{repo.owner}/#{repo.name}/#{@test_branch}")
    end
  end
end
