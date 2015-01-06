class Chat

  def initialize(text, time=Time.now)
    @text = text
    @time = time
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
    when /\A(s\s+|spend\s+)(?<amount>[\d\.]+)\Z/
      Statement.make!(:add_expense,
        :amount => $~[:amount].to_f)
    else
      @response = "(unrecognized command)"
    end
  end

end

