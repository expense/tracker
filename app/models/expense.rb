
class Expense < Struct.new(:amount, :category, :time, :id, :comment)

  def initialize(amount:, category: nil, time: nil, id: nil, comment: nil)
    super amount, category, time, id, comment
  end

  def self.total(expenses)
    expenses.map(&:amount).reduce(0, &:+)
  end

  def self.days(expenses)
    return 1 if expenses.empty?
    expenses.map(&:time).map(&:owner).minmax.reverse.reduce(&:-) + 1
  end

end
