class Numeric
  def money
    "%.2f" % [self]
  end
  def money_s
    "#{self.round(2)}".sub(/\.0+$/, '')
  end
end
