# frozen_string_literal: true

require "spec_helper"

RSpec.describe Roper::Driver do

  let(:driver) { Roper::Driver.new(@test_repo, @test_branch) }
  let(:compose) { Docker::Compose::Session.new }
  let(:mount_path) { Roper::mount_path(@test_repo, @test_branch) }
  let(:repo) { Octokit::Repository.new @test_repo }

  before(:example) do
    allow(Dir).to receive_messages(chdir: nil, pwd: nil)
    allow(Docker::Compose::Session).to receive(:new).and_return(compose)
    allow(compose).to receive(:up)
    allow(compose).to receive(:down)
  end

  describe ".initialize" do
    it "Uses mount_path to initialize docker compose session" do
      expect(Docker::Compose::Session).to receive(:new).with(dir: mount_path)
      Roper::Driver.new(@test_repo, @test_branch)
    end
  end

  describe ".up" do
    it "runs docker compose up in detached mode with forced rebuild" do
      expect(compose).to receive(:up).with(detached: true, build: true)
      driver.up
    end

    it "sets some environment variables" do
      expect(ENV["ROPER_REPO_BRANCH"]).to eq(@test_branch)
      expect(ENV["ROPER_REPO_OWNER"]).to eq(repo.owner)
      expect(ENV["ROPER_REPO_NAME"]).to eq(repo.name)
    end

  end

  describe ".down" do
    it "runs docker compose down" do
      expect(compose).to receive(:down)
      driver.down
    end
  end
end
