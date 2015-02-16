module ConferencesHelper
  def conference_dates(conference)
    s = conference.start_date
    e = conference.end_date
    if s.present? && e.present?
      date_range s, e
    end
  end
end
