
require 'rspec/its'
require 'active_support/core_ext/hash/indifferent_access'
require './app/models/info.rb'

describe Info do

  def parse(command)
    Info.parse(command)
  end

  describe "::parse_command" do

    subject { Info::parse_command command }

    def self.it_parses(c, r)
      describe "#{c}" do
        let(:command) { c }
        let(:result) { r }
        it { should eq r }
      end
    end

    describe 'usage' do
      it_parses "100F", type: :use, amount: 100.0, category: "F", from: :cash
    end

    describe 'withdrawal' do
      it_parses "W300", type: :withdraw, amount: 300.0, to: :cash
      it_parses "cash<<300.000", type: :withdraw, amount: 300.0, to: :cash
      it_parses "abc<<300.000", type: :withdraw, amount: 300.0, to: :abc
    end

    describe 'transfer' do
      it_parses "cash<<300.0000<<abc", type: :transfer, amount: 300.0, from: :abc, to: :cash
    end

    describe 'switching context' do
      it_parses "switch:jp", type: :switch, context: :jp
    end

    describe 'setting currency' do
      it_parses "currency:yen", type: :set, option: :currency, value: "yen"
    end

    describe 'have' do
      it_parses "H222", type: :have, amount: 222.0, in: :cash
    end

    describe 'reset_drift (obsolete)' do
      it_parses "R0", type: :reset_drift, amount: 0, from: :cash
    end

  end

end

