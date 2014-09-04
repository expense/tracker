class Chat

  ADD_PATTERN = /\s+a(?:dd)?\Z/
  REPORT_BY_DATE_PATTERN = /\s+\.\Z/

  def initialize(text, time=Time.now)
    @text = text
    @time = time
    @response = "no response"
  end

  def send
    Item.transaction do
      handle
    end
    @response
  end

  def handle
    handle_help or
    handle_report or
    handle_ls or
    handle_report_by_date or
    handle_change_date_command or
    handle_comment_command or
    handle_command_change or
    handle_delete_command or
    handle_add_command or
      @response = "Invalid command!"
  end

  def handle_report
    return false unless @text == '.'
    @response = "#{short_report}\n#{category_report}\nToday:\n#{list(Item.today)}"
    true
  end

  def handle_ls
    return false unless @text == 'ls'
    @response = "#{report.money}"
    true
  end

  def handle_report_by_date
    return false unless @text =~ REPORT_BY_DATE_PATTERN
    text = @text.sub(REPORT_BY_DATE_PATTERN, '')
    date = parse_time(text).owner
    items = Item.on(date)
    total = Expense.total(ExpenseReport.new(items).expenses)
    @response = "#{date.to_formatted_s(:jd)}:\n#{list(items)}\nTotal: #{total.money}"
    true
  end

  def handle_help
    case @text
    when '?', 'help'
      @response = help
    when '?c'
      @response = help_category
    else
      return false
    end
    true
  end

  def handle_change_date_command

    if @text =~ /\A\s*(\d+)\s*@\s*(.+)\Z/
      id = $1.to_i
      raw_time = $2
      item = Item.find(id)
      item.created_at = parse_time(raw_time) or raise "Invalid"
      item.save!
      @response = "Updated! #{item.description}"
      true
    else
      false
    end

  end

  def handle_comment_command

    if @text =~ /\A\s*(\d+)\s*#\s*(\S.*)\Z/
      id = $1.to_i
      comment = $2
      item = Item.find(id)
      item.comment = $2
      item.save!
      @response = "Updated! #{item.description}"
      true
    else
      false
    end

  end

  def handle_command_change

    if @text =~ /\A\s*(\d+)\s*=\s*(\S+)\Z/
      id = $1.to_i
      command = $2
      item = Item.find(id)
      item.command = $2
      item.save!
      @response = "Updated! #{item.description}"
      true
    else
      false
    end

  end

  def handle_delete_command

    if @text =~ /\A(\d+)\s+rm\Z/
      id = $1.to_i
      raw_time = $2
      item = Item.find(id)
      @response = "Destroy! #{item.description}"
      item.destroy
      true
    else
      false
    end

  end

  def handle_add_command


    return false unless @text =~ ADD_PATTERN

    text = @text.sub(ADD_PATTERN, '')

    adder = Adder.new(@time)

    text.scan /(?:@\s*(\S[^#\r\n]*))|(?:#\s*(\S.*))|(\S+)/ do |raw_time, comment, command|
      if command
        adder.command command
      elsif raw_time
        adder.time parse_time(raw_time)
      elsif comment
        adder.comment comment
      end
    end

    items = adder.items
    return false if items.empty?

    items.each(&:save!)
    cats = items.map(&:info).map(&:category).compact.uniq

    @response = "#{short_report}\n#{category_report cats}\nAdded:\n#{list(items)}"

    return true

  end

  def list(items)
    item_text = -> item { "- #{item.description}" }
    texts = items.sort_by(&:created_at).map(&item_text)
    texts.empty? ? "- EMPTY" : texts.join("\n")
  end

  def help
    build_response do |o|
      o << "Usage:"
      o << "- . # report"
      o << "- <amount><category> # ?c"
      o << "- W<amount> # withdraw"
      o << "- H<amount> # have"
      o << "- T<amount> # tithe/giving"
    end
  end

  def help_category
    build_response do |o|
      Info::CATEGORIES.each do |k, name|
        o << "[#{k}] #{name}"
      end
    end
  end

  def build_response
    result = []
    yield result
    result.join("\n")
  end

  def parse_time(str)
    Chronic.parse(str, context: :past, now: @time)
  end


  private

  def short_report
    build_response do |o|
      x = ['@']
      x << "L:#{report.money[:cash].money_s}"
      x << "A:#{format_averages(report.expenses)}"
      if report.unprocess != 0
        x << "[U:#{report.unprocess}]"
      end
      o << x.join(' ')
    end
  end
  
  def category_report(list=Info::CATEGORIES.keys)
    build_response do |o|
      o << [].tap { |x|
        list.each do |k, v|
          list = report.expenses.select { |c| c.category == k }
          x << "(#{k} #{format_averages(list)})"
        end
      }.join(', ')
    end
  end

  def format_averages(expenses)
    filter = -> days { expenses.select { |e| e.time.owner >= Date.today - days + 1 } }
    [
      (Expense.total(filter[1]) / 1.0),
      (Expense.total(filter[7]) / 7.0).round,
      (Expense.total(filter[30]) / 30.0).round,
      (Expense.total(expenses) / Expense.days(expenses)).round
    ].map(&:money_s).join(' ')
  end

  def report
    @report ||= ExpenseReport.new
  end


  class Adder

    attr_reader :items

    def initialize(time)
      @items = []
      @time = time
      @apply_until = 0
    end

    def command(command)
      @items << Item.new(command: command, created_at: @time)
    end

    def comment(comment)
      @items.last.comment = comment
    end

    def time(time)
      apply do |item|
        item.created_at = time
      end
    end

    private
    def apply
      (@apply_until...@items.length).each do |index|
        yield @items[index]
      end
      @apply_until = @items.length
    end

  end

end

