
require 'rails_helper'

describe Chat do

  def chat(text)
    Chat.new(text).send
  end

  describe "spend command" do
    it "should work with just number" do
      chat "spend 100"
      statement = Statement.last
      expect(statement).to be_command :add_expense, amount: 100.0
    end
    it "should work with fractional number" do
      chat "spend 6.25"
      statement = Statement.last
      expect(statement).to be_command :add_expense, amount: 6.25
    end
  end

end
