# Autocomplete source
conferencesSource = new Bloodhound(
  remote: '/conferences/autocomplete?query=%QUERY'
  datumTokenizer: Bloodhound.tokenizers.obj.whitespace('title')
  queryTokenizer: Bloodhound.tokenizers.whitespace)
conferencesSource.initialize()

noDirectMatch = (matches, query) ->
  if matches.length > 0
    matches[0].title.toLowerCase() != query.toLowerCase()
  else
    true

conferencesTTAdapter = (query, cb) ->
  conferencesSource.get query, (matches) ->
    # Unless the query matches exactly, add a special line that says "Add a new ..."
    if noDirectMatch(matches, query)
      matches.push(
        noMatch: true
        query: query
      )
    cb(matches)

# Typeahead inputs
typeaheadOptions = null
$ ->
  # Search in navbar
  $input = $('#conference-search')
  $input.typeahead typeaheadOptions,
    name: 'conferences'
    displayKey: 'title'
    source: conferencesTTAdapter
    templates:
      suggestion: JST['templates/autocomplete']
