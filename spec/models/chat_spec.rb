
require 'rails_helper'

describe Chat do

  def chat(*args)
    Chat.new(*args).send
  end

  describe "spend command" do

    describe "amount" do
      it "should work with just number" do
        chat "spend 100"
        expect(Statement.last).to be_command :add_expense, amount: 100.0
      end
      it "should work with fractional number" do
        chat "spend 6.25"
        expect(Statement.last).to be_command :add_expense, amount: 6.25
      end
    end

    describe "category" do
      it "should put into default category when not specified" do
        chat "spend 100", options: { default_category: 'food' }
        expect(Statement.last).to be_command :add_expense, category: 'food'
      end
      it "should put into specified category" do
        chat "spend 100travel"
        expect(Statement.last).to be_command :add_expense, category: 'travel'
      end
      it "should allow category aliasing" do
        chat "spend 100f", options: { category_alias_f: 'food' }
        expect(Statement.last).to be_command :add_expense, category: 'food'
      end
    end

    describe "stores" do
      it "should select a default store when not specified" do
        chat "spend 100", options: { default_store: 'default' }
        expect(Statement.last).to be_command :add_expense, store: 'default'
      end
      it "should select a specified store" do
        chat "spend 100:bank"
        expect(Statement.last).to be_command :add_expense, store: 'bank'
      end
    end

    describe "time" do
      it "should use current time" do
        time = Time.now
        chat "spend 100", time: time
        expect(Statement.last.time).to eq time
      end
      it "should use specified time" do
        time = Time.now
        chat "spend 100 @ 1 day ago", time: time
        expect(Statement.last.time).to eq(time - 1.day)
      end
    end

    describe "remarks" do
      it "should allow adding remarks" do
        chat "spend 55t taxi"
        expect(Statement.last).to be_command :add_expense, remark: 'taxi'
      end
    end

    describe "combinations" do
      it "should all work together" do
        time = Time.now
        options = { category_alias_t: 'transportation' }
        chat "spend 55t:cash taxi @ 3 hours ago", options: options, time: time
        expect(Statement.last).to be_command(:add_expense,
          amount: 55.0,
          store: 'cash',
          category: 'transportation',
          remark: 'taxi')
        expect(Statement.last.time).to eq(time - 3.hours)
      end
    end

    describe "shorthand" do
      it "when text starts with number, default to spend command" do
        chat "123"
        expect(Statement.last).to be_command :add_expense, amount: 123.0
      end
    end

  end

end
