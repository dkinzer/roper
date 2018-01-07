# frozen_string_literal: true

require "spec_helper"

RSpec.describe Roper::CLI do

  before(:example) do
    @git = instance_double("Roper::Repo")
    @hub = instance_double("Roper::Hub")
    @driver = instance_double("Roper::Driver")
    @ref = "x" * 40
    @target_url = "https://foobar.com/details"

    allow(Roper::Driver).to receive(:new).and_return(@driver)
    allow(Roper::Repo).to receive(:new).and_return(@git)
    allow(Roper::Hub).to receive(:new).and_return(@hub)

    allow(@git).to receive_messages(mount: nil, update: nil, unmount: nil, ref: @ref)
    allow(@hub).to receive(:create_status)
    allow(@driver).to receive_messages(up: nil, down: nil)
  end

  describe "#lasso" do
    after(:example) do
      options = { status_url: @target_url, domain: "foobar.net" }
      Roper::CLI.lasso(@test_repo, @test_branch, options)
    end

    it "mounts the repository" do
      expect(@git).to receive(:mount)
    end

    it "updates the repository" do
      expect(@git).to receive(:update)
    end

    it "gets the reference for repo HEAD" do
      expect(@git).to receive(:ref)
    end

    it "sets github pr status to in progress" do
      expect(@hub).to receive(:create_status).with(@ref, "pending",
        description: "The build process is in progress.",
        status_url: @target_url)
    end

    it "builds the project" do
      expect(@driver).to receive(:up)
    end

    it "returns a successful build" do
      expect(@hub).to receive(:create_status).with(@ref, "success",
        description: "The PR brach was successfully built.",
        status_url: "https://#{@test_branch}.foobar.net")
    end

    context "An error occurs durring docker up process." do
      before(:example) do
        allow(@driver).to receive(:up).and_raise("error")
      end

      it "sets github pr status to failure" do
        expect(@hub).to receive(:create_status).with(@ref, "failure",
          description: "The PR branch failed to build.",
          status_url: @target_url)
      end
    end
  end

  describe "#release" do
    after(:example) do
      Roper::CLI.release @test_repo, @test_branch
    end

    it "powers down the containers" do
      expect(@driver).to receive(:down)
    end

    it "unmounts the repository" do
      expect(@git).to receive(:unmount)
    end
  end
end
