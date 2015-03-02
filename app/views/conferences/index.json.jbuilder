json.array!(conferences) do |conference|
  json.extract! conference, :id, :title, :city_state, :location, :latitude, :longitude
  json.set! :allDay, true
  json.set! :start, conference.start_date
  json.set! :end, conference.end_date
  json.set! :website_url, conference_url(conference)
  json.set! :date_range, conference_dates(conference)
  json.url conference_path(conference)
end
