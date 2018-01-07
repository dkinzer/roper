# frozen_string_literal: true

require "spec_helper"

RSpec.describe Roper::Repo do
  let (:repo) { Octokit::Repository.new @test_repo }
  let (:mount_path) {  Roper::mount_path(@test_repo, @test_branch) }
  let(:git) { Roper::Repo.new(@test_repo, @test_branch) }
  let(:repository) { instance_double("Git::Repository") }
  let(:object) { instance_double("Git::Object") }

  before(:example) do
    Git = class_double("Git::Base")
    allow(Git).to receive_messages(clone: repository, open: repository)
    allow(repository).to receive(:checkout)
    allow(repository).to receive(:pull)
    allow(repository).to receive(:object).and_return(object)
    allow(object).to receive(:sha)
  end

  describe ".mount" do
    it "clones a repo" do
      expect(Git).to receive(:clone).with(repo.url, mount_path)
      git.mount
    end

    it "checksout the passed in branch" do
      expect(repository).to receive(:checkout).with(@test_branch)
      git.mount
    end
  end

  describe ".update" do
    it "sets working directory to repo" do
      expect(Git).to receive(:open).with(mount_path)
      git.update
    end

    it "pulls the latest changes" do
      expect(repository).to receive(:pull).with("origin", @test_branch)
      git.update
    end
  end

  describe ".unmount" do
    it "deletes the repo working directory" do
      allow(FileUtils).to receive(:rm_r).and_return(nil)
      expect(FileUtils).to receive(:rm_r).with(mount_path)
      git.unmount
    end
  end

  describe ".ref" do
    it "sets working directory to repo" do
      expect(Git).to receive(:open).with(mount_path)
      git.ref
    end

    it "gets the HEAD commit" do
      expect(repository).to receive(:object).with("HEAD")
      expect(object).to receive(:sha)
      git.ref
    end
  end
end
