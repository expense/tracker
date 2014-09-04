
Time::DATE_FORMATS[:j] = ->(time) {
  wday = "日月火水木金土"[time.wday]
  time.strftime("%-m/%-d#{wday} %H:%M")
}

Time::DATE_FORMATS[:jd] = ->(time) {
  wday = "日月火水木金土"[time.wday]
  time.strftime("%-m/%-d#{wday}")
}
