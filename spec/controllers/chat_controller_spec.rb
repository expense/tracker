require 'rails_helper'

RSpec.describe ChatController, :type => :controller do

  xdescribe "GET chat" do
    it "returns http success" do
      get :chat
      expect(response).to be_success
    end
  end

  describe "POST chat" do
    it "returns http success" do
      post :chat, { text: 'ha' }
      expect(response).to be_success
      expect(assigns(:response)).to be_a(String)
    end
    it "adds new expenses" do
      post :chat, { text: '400F a' }
      expect(Item.first.command).to eq("400F")
    end
    it "adds new expenses with time" do
      post :chat, { text: '400F a', time: '123456000' }
      expect(Item.first.created_at.to_f).to eq(123456.0)
    end
  end

end
