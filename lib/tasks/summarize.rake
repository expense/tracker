
task :summarize => [:environment] do

  items = Item.all.take_while { |c| c.command != 'MOct2014' }
  
  date_range = items.map(&:created_at).minmax.map(&:owner)
  days = date_range.reverse.reduce(&:-) + 1
  infos = items.map(&:info)

  puts "#{date_range.join(' – ')}"

  puts " - #{days} days"

  Info::CATEGORIES.each do |category, description|
    usage = infos.select(&:use?).select { |c| c.category == category }
    puts " [#{category}] #{usage.map(&:amount).reduce(0, &:+)} for #{description}"
  end

  tithe = infos.select(&:tithe?).map(&:amount).reduce(0, &:+)
  total = infos.select(&:use?).map(&:amount).reduce(0, &:+)

  puts " - Giving #{tithe}"
  puts " - Total #{total + tithe}"

end

