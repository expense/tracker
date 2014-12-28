require 'rails_helper'

RSpec.describe "Statements", :type => :request do
  describe "GET /statements" do
    it "works! (now write some real specs)" do
      get statements_path
      expect(response.status).to be(200)
    end
  end
end
