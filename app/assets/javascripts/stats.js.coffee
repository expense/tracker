
R = (tagName, properties=null) -> R.make(tagName)(properties)

R.make = (tagName) -> (properties) -> (children...) ->
  React.createElement(tagName, properties, children...)

CalendarView = React.createClass

  render: ->
    R('ul', className: 'cal-month')(
      this.props.data.map ({ year, month, weeks }) =>
        R('li')(
          R('h2')("#{year}年#{month}月")
          R('ul', className: 'cal-week')(
            weeks.map ({ dates }) =>
              R('li')(
                R('ul', className: 'cal-day')(
                  dates.map ({ mday, wday, list }) =>
                    R('li')(
                      R('h3')(
                        R('span', className: 'cal-day--mday')("#{mday}日")
                        R('span', className: 'cal-day--wday')(@wday(wday)))
                      R('div', className: 'cal-day--total')(@total(list))
                      R('ul', className: 'cal-item')(
                        list.map (item) =>
                          R('li',
                            className: 'expense-item'
                            'data-category': item.category
                            title: JSON.stringify(item)
                            style: @itemStyle(item))(item.amount))))))))

  wday: (i) -> "日月火水木金土"[i]

  itemStyle: (item) ->
    height: item.amount

  total: (list) -> list.reduce ((a, item) -> a + item.amount), 0

$ -> $('[data-expenses]').each ->

  $this = $(this)
  data = JSON.parse($this.attr('data-expenses'))
  React.render(R(CalendarView, data: data)(), $this[0])

