module DateRangeAccessor

  def date_range_accessor(name, start_attr, end_attr, options = {})
    separator = options[:separator] || '-'

    define_method name do
      start_date = self.send(start_attr)
      end_date = self.send(end_attr)
      if start_date && end_date
        start_date..end_date
      end
    end

    define_method "#{name}_format" do |view_context|
      range = self.send(name)
      if range
        "#{view_context.localize(range.begin)} #{separator} #{view_context.localize(range.end)}"
      end
    end

    define_method "#{name}=" do |date_range|
      unless date_range.is_a? Range
        date_range = Range.new *date_range.split(separator).map { |str| Date.parse(str) }
      end

      self.send("#{start_attr}=", date_range.begin)
      self.send("#{end_attr}=", date_range.end)
    end
  end
end
