
require 'active_support/core_ext/module/delegation'

class ExpenseReport

  class Context
    attr_reader :expenses, :money
    attr_accessor :currency
    def initialize
      @expenses = [ ]
      @money = Hash.new { |h, k| 0 }
      @currency = '?'
    end
  end

  delegate :expenses, to: :context
  delegate :money, to: :context
  delegate :currency, to: :context
  
  attr_reader :unprocess

  def initialize(items=Item.all)
    @current_context_name = :default
    @contexts = { }
    process!(items.sort_by(&:created_at))
  end

  def contexts
    @contexts.keys
  end

  def context(name=nil)
    @contexts[name || @current_context_name] ||= Context.new
  end

  private

  def process!(items)

    @unprocess = 0

    items.each do |item|
      info = item.info
      case info.type
      when :use
        expenses << Expense.new(amount: info.amount, category: info.category, time: item.created_at, id: item.id, comment: item.comment)
        money[info.from] -= info.amount
      when :withdraw
        money[info.to] += info.amount
      when :transfer
        money[info.from] -= info.amount
        money[info.to] += info.amount
      when :have
        money[info.in] = info.amount
      when :tithe
        money[info.from] -= info.amount
      when :switch
        @current_context_name = info.context
      when :set
        case info.option
        when :currency
          context.currency = info.value
        else
          @unprocess += 1
        end
      when :lost, :reset_drift
        # deprecated
      else
        @unprocess += 1
      end
    end

  end

end
