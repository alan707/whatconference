# Autocomplete source
conferencesSource = new Bloodhound(
  prefetch:
    url: Routes.autocomplete_conferences_path(prefetch: true)
  remote: Routes.autocomplete_conferences_path(query: '%QUERY')
  datumTokenizer: Bloodhound.tokenizers.obj.whitespace('title')
  queryTokenizer: Bloodhound.tokenizers.whitespace)
conferencesSource.initialize()

noDirectMatch = (matches, query) ->
  if matches.length > 0
    alreadyContainsNoMatch = _.find matches, (match) -> match.noMatch
    if alreadyContainsNoMatch
      false
    else
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
      suggestion: (suggestion) ->
        if suggestion.noMatch
          JST['templates/add_new_conference'](suggestion)
        else
          JST['templates/autocomplete'](suggestion)
