
require './app/models/expense_report'
require './app/models/info'
require './app/models/expense'

describe ExpenseReport do

  def t(n)
    Time.at(n)
  end

  def item(created_at, info)
    double(created_at: t(created_at), info: Info.new(info), id: nil, comment: nil)
  end

  describe 'With simple withdrawal and usage' do

    subject :report do
      ExpenseReport.new([
        item(0, type: :withdraw, to: :cash, amount: 45.0),
        item(2, type: :use, from: :cash, amount: 10.0),
        item(5, type: :use, from: :cash, amount: 20.0),
      ])
    end

    describe "#expenses" do
      it "should calculate expenses" do
        expect(report.expenses.length).to eq 2
      end
    end

    describe '#money' do
      it "should return money left" do
        expect(report.money[:cash]).to eq 15.0
      end
    end

  end

  describe 'Checking money' do
    it "should set money to latest value" do
      report = ExpenseReport.new([
        item(0, type: :have, in: :cash, amount: 123.0),
        item(1, type: :have, in: :cash, amount: 456.0),
      ])
      expect(report.money[:cash]).to eq 456.0
    end
  end

  describe 'Transfer' do
    subject :report do
      ExpenseReport.new([
        item(0, type: :withdraw, to: :cash, amount: 200.0),
        item(0, type: :withdraw, to: :abc, amount: 200.0),
        item(0, type: :transfer, from: :cash, to: :abc, amount: 100.0),
      ])
    end
    it "should transfer money" do
      expect(report.money[:cash]).to eq 100.0
      expect(report.money[:abc]).to eq 300.0
    end
  end

  describe 'Giving' do
    subject :report do
      ExpenseReport.new([
        item(0, type: :withdraw, to: :cash, amount: 200.0),
        item(0, type: :tithe, from: :cash, amount: 20.0),
      ])
    end
    it "should subtract money without adding to expense" do
      expect(report.money[:cash]).to eq 180.0
    end
  end

  describe 'Switching context' do
    it "should list all contexts" do
      report = ExpenseReport.new([
        item(0, type: :withdraw, to: :cash, amount: 200.0),
        item(1, type: :switch, context: :abc),
        item(2, type: :withdraw, to: :cash, amount: 200.0),
        item(3, type: :switch, context: :def),
        item(4, type: :withdraw, to: :cash, amount: 200.0),
      ])
      expect(report.contexts).to eq [:default, :abc, :def]
    end
    it "should subtract money without adding to expense" do
      report = ExpenseReport.new([
        item(0, type: :withdraw, to: :cash, amount: 200.0),
        item(1, type: :switch, context: :abc),
        item(2, type: :withdraw, to: :cash, amount: 300.0),
      ])
      expect(report.money[:cash]).to eq 300.0
      expect(report.context(:abc).money[:cash]).to eq 300.0
      expect(report.context(:default).money[:cash]).to eq 200.0
    end
  end

  describe 'Changing currency' do
    it "should change currency" do
      report = ExpenseReport.new([
        item(0, type: :set, option: :currency, value: "Z"),
      ])
      expect(report.currency).to eq "Z"
    end
  end

end
