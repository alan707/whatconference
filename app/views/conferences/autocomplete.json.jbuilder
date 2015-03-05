json.array!(conferences) do |conference|
  json.extract! conference, :title, :city_state
  json.set! :website_url, conference_url(conference)
  json.set! :date_range, conference_dates(conference)
  json.url conference_path(conference)
end
