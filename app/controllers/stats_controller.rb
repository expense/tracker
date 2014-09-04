class StatsController < ApplicationController

  CATEGORIES = %w(F T E G A)

  def index

    days = report.expenses
      .group_by { |expense| expense.time.owner }.sort
      .last(30)

    @data = days
      .group_by { |date, list| [date.year, date.month] }.sort
      .map { |(year, month), dates|
        weeks = dates
          .group_by { |date, list| (date + 1).cweek }.sort
          .map { |week, list|
            dates = list.map { |date, list|
              { date: date, mday: date.mday, wday: date.wday, list: list.sort_by { |item| CATEGORIES.index(item.category) or Float::INFINITY } } }
            { week: week, dates: dates } }
        { year: year, month: month, weeks: weeks } }
            

  end

  private
  def report
    @report ||= ExpenseReport.new
  end

end
