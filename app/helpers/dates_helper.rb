module DatesHelper
  def date_range_format(date_range)
    if date_range
      "#{localize(date_range.begin)} - #{localize(date_range.end)}"
    end
  end
end

# if date_range_pretty
#       "#{date_range.begin.strftime("%b %d, %Y")} - #{date_range.end.strftime("%b %d, %Y")}"
#     end
