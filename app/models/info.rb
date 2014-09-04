
class Info

  TYPES = [:use, :withdraw, :have, :reset_drift, :tithe]

  CATEGORIES = {
    "F" => "Food",
    "T" => "Transportation",
    "H" => "Health",
    "G" => "Game",
    "O" => "Other",
    "L" => "Lost",
  }

  attr_reader :type, :amount, :category, :from, :to, :in, :context, :option, :value

  def initialize(attributes)
    attributes.each do |k, v|
      instance_variable_set "@#{k}".to_sym, v
    end
  end

  TYPES.each do |type|
    define_method "#{type}?" do
      @type == type
    end
  end

  def category_for(c)
    CATEGORIES[c] || c
  end

  def to_s
    case type
    when :use
      "Spend #{amount.money} for #{category_for(category)}"
    when :withdraw
      "Withdraw #{amount.money} of #{self.to}"
    when :transfer
      "Transfer #{amount.money} from #{self.from} to #{self.to}"
    when :have
      "Now I have #{amount.money} of #{self.in}"
    when :reset_drift
      "Reset drift to #{amount.money}"
    when :tithe
      "Giving #{amount.money}"
    when :switch
      "Switching to #{context}"
    when :set
      "Setting #{option} to #{value}"
    when :unrecognized
      "Unrecognized: #{@raw}"
    else
      "#{inspect}"
    end
  end

  def self.parse(command)
    new parse_command(command)
  end

  def self.parse_command(command)
    Hash.new.tap do |info|
      if command =~ /\A([\d\.]+)([A-Z])\Z/
        info[:type] = :use
        info[:amount] = $1.to_f
        info[:category] = $2
        info[:from] = :cash
      elsif command =~ /\AW([\d\.]+)\Z/
        info[:type] = :withdraw
        info[:amount] = $1.to_f
        info[:to] = :cash
      elsif command =~ /\A(\w+)<<([\d\.]+)\Z/
        info[:type] = :withdraw
        info[:amount] = $2.to_f
        info[:to] = $1.to_sym
      elsif command =~ /\A(\w+)<<([\d\.]+)<<(\w+)\Z/
        info[:type] = :transfer
        info[:amount] = $2.to_f
        info[:to] = $1.to_sym
        info[:from] = $3.to_sym
      elsif command =~ /\AH([\d\.]+)\Z/
        info[:type] = :have
        info[:amount] = $1.to_f
        info[:in] = :cash
      elsif command =~ /\AT([\d\.]+)\Z/
        info[:type] = :tithe
        info[:amount] = $1.to_f
        info[:from] = :cash
      elsif command =~ /\AR([\d\.]+)\Z/
        info[:type] = :reset_drift
        info[:amount] = $1.to_f
        info[:from] = :cash
      elsif command =~ /\Aswitch:(\w+)\Z/
        info[:type] = :switch
        info[:context] = $1.to_sym
      elsif command =~ /\Acurrency:(\S+)\Z/
        info[:type] = :set
        info[:option] = :currency
        info[:value] = $1
      else
        info[:type] = :unrecognized
        info[:raw] = command
      end
    end
  end

end
