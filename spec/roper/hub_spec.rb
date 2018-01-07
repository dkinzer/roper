# frozen_string_literal: true

require "spec_helper"

RSpec.describe Roper::Hub do
  describe ".create_status", :vcr do
    subject { Roper::Hub.new(@test_repo) }

    it "creates status" do
      info = {}
      subject.create_status(@test_ref, "success", info)
      assert_requested :post, github_url("/repos/#{@test_repo}/statuses/#{@test_ref}"),
        body: hash_including(context: "Roper Stager")
    end
  end

end
