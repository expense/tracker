
require 'rails_helper'

describe Chat do

  def chat(text)
    Chat.new(text).send
  end

  describe "adding" do
    it "add new item" do
      chat "100F a"
      expect(Item.first.command).to eq("100F")
    end
    it "add new item with time in context" do
      time = 2.days.ago
      Chat.new("100F a", time).send
      expect(Item.first.created_at).to eq(time)
    end
    it "add new item with time" do
      chat "100F @ 2 days ago a"
      expect(Item.first.command).to eq("100F")
      expect(Item.first.created_at).to be <= 2.days.ago
    end
    it "add multiple items" do
      response = chat "200F 100T a"
      expect(response).to match /200/
      expect(response).to match /100/
      expect(response).to match /300/
    end
    it "can change date" do
      item = Item.create(command: '100F')
      chat "#{item.id} @ 3 years ago"
      item.reload
      expect(item.created_at).to be <= 2.years.ago
    end
    it "can change date" do
      item = Item.create(command: '100F')
      chat "#{item.id} # taxi"
      item.reload
      expect(item.comment).to eq "taxi"
    end
    it "can change command" do
      item = Item.create(command: '100F')
      chat "#{item.id} = 100T"
      item.reload
      expect(item.command).to eq "100T"
    end
    it "can remove item" do
      item = Item.create(command: '100F')
      chat "#{item.id} rm"
      expect { item.reload }.to raise_error ActiveRecord::RecordNotFound
    end
    it "add multiple items with same date" do
      chat "100F, 200F, 300T @ 2 days ago a"
      expect(Item.all.length).to eq 3
      Item.all.each do |item|
        expect(item.created_at).to be <= 2.days.ago
      end
    end
  end

end
