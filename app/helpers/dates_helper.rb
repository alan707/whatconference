module DatesHelper
  def date_range_format(date_range)
    if date_range
      "#{localize(date_range.begin)} - #{localize(date_range.end)}"
    end
  end
end
