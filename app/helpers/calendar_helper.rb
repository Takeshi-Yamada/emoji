module CalendarHelper
  def login_emoji_by_wday(wday)
    case wday
    when 1 then "🌕" # 月曜
    when 2 then "🔥" # 火曜
    when 3 then "💧" # 水曜
    when 4 then "🍃" # 木曜
    when 5 then "🌈" # 金曜
    when 6 then "🎉" # 土曜
    when 0 then "🛌" # 日曜
    else "❓"
    end
  end
end