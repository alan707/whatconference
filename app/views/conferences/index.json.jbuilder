json.array!(conferences) do |conference|
  json.extract! conference, :id, :title, :location, :latitude, :longitude
  json.set! :allDay, true
  json.set! :start, conference.start_date
  json.set! :end, conference.end_date
  json.url conference_url(conference)
end
