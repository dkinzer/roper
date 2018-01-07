# frozen_string_literal: true

require "spec_helper"

RSpec.describe Roper::Driver do

  let(:driver) { Roper::Driver.new(@test_repo, @test_branch) }
  let(:compose) { Docker::Compose.new }
  let(:mount_path) { Roper::mount_path(@test_repo, @test_branch) }
  let(:repo) { Octokit::Repository.new @test_repo }

  before(:example) do
    allow(Dir).to receive_messages(chdir: nil, pwd: nil)
    allow(Docker::Compose).to receive(:new).and_return(compose)
    allow(compose).to receive(:up)
    allow(compose).to receive(:down)
  end

  describe ".up" do
    it "changes working directory to mount_path" do
      expect(Dir).to receive(:chdir).with(mount_path)
      driver.up
    end

    it "runs docker compose up" do
      expect(compose).to receive(:up)
      driver.up
    end

    it "sets some environment variables" do
      expect(ENV["ROPER_REPO_BRANCH"]).to eq(@test_branch)
      expect(ENV["ROPER_REPO_OWNER"]).to eq(repo.owner)
      expect(ENV["ROPER_REPO_NAME"]).to eq(repo.name)
    end

  end

  describe ".down" do
    it "changes working directory to mount_path" do
      expect(Dir).to receive(:chdir).with(mount_path)
      driver.down
    end

    it "runs docker compose down" do
      expect(compose).to receive(:down)
      driver.down
    end
  end
end
