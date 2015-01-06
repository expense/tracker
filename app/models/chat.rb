class Chat

  def initialize(text, time: Time.now, options: { })
    @text = text
    @time = time
    @options = options.dup.with_indifferent_access
    @response = "(no response)"
  end

  def send
    Statement.transaction do
      handle
    end
    @response
  end

  def handle
    case @text
    when  /\A
            (s\s+|spend\s+|)
            (?<amount>[\d\.]+)
              (?<category>[a-z]+)?
              (?::(?<store>[a-z0-9]+))?
            (?:\s+(?<remark>[^@]+?))?
            (?:\s*@\s*(?<time>.+))?
          \Z/ix
      Statement.make!(:add_expense,
        :amount   => $~[:amount].to_f,
        :category => category_for($~[:category]),
        :store    => store_for($~[:store]),
        :time     => time_for($~[:time]),
        :remark   => $~[:remark],
      )
    else
      @response = "(unrecognized command)"
    end
  end

  private
  def category_for(text)
    return @options[:default_category] if text.blank?
    text = text.downcase
    @options["category_alias_#{text}"] || text
  end

  def store_for(text)
    return @options[:default_store] if text.blank?
    text.downcase
  end

  def time_for(text)
    return @time if text.blank?
    Chronic.parse(text, context: :past, now: @time) or @time
  end

end

