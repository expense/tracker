
require './app/models/expense'

describe Expense do

  describe "::total" do

    it 'should calculate totals' do
      array = [
        Expense.new(amount: 5),
        Expense.new(amount: 15),
      ]
      expect(Expense.total(array)).to eq 20
    end

    it 'should return 0 on empty array' do
      array = [ ]
      expect(Expense.total(array)).to eq 0
    end

  end

end
