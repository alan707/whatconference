# Autocomplete sources
class ConferencesAutocompleteSource
  constructor: ->
    @source = new Bloodhound(
      prefetch:
        url: Routes.autocomplete_conferences_path(prefetch: true)
      remote: Routes.autocomplete_conferences_path(query: '%QUERY')
      datumTokenizer: Bloodhound.tokenizers.obj.whitespace('title')
      queryTokenizer: Bloodhound.tokenizers.whitespace)
    @source.initialize()

  noDirectMatch: (matches, query) ->
    if matches.length > 0
      alreadyContainsNoMatch = _.find matches, (match) -> match.noMatch
      if alreadyContainsNoMatch
        false
      else
        matches[0].title.toLowerCase() != query.toLowerCase()
    else
      true

  ttAdapter: (query, cb) =>
    @source.get query, (matches) =>
      # Unless the query matches exactly, add a special line that says "Add a new ..."
      if @noDirectMatch(matches, query)
        matches.push(
          noMatch: true
          query: query
        )
      cb(matches)

conferencesSource = new ConferencesAutocompleteSource

# Typeahead inputs
typeaheadOptions = null
$ ->
  # Search in navbar
  $input = $('.conference-search')
  $input.typeahead typeaheadOptions,
    name: 'conferences'
    displayKey: 'title'
    source: conferencesSource.ttAdapter
    templates:
      suggestion: (suggestion) ->
        if suggestion.noMatch
          JST['templates/add_new_conference'](suggestion)
        else
          JST['templates/autocomplete'](suggestion)

  $input.on 'typeahead:selected', (event, suggestion, dataset) ->
    if dataset == 'conferences'
      if suggestion.noMatch
        Turbolinks.visit Routes.new_conference_path(title: suggestion.query)
      else if suggestion.url
        Turbolinks.visit suggestion.url

