
class Date
  def begin
    in_time_zone + 4.hours
  end
end

class Time
  def owner
    t = (in_time_zone - 4.hours)
    t.to_date
  end
end

class ActiveSupport::TimeWithZone
  def owner
    t = (in_time_zone - 4.hours)
    t.to_date
  end
end

