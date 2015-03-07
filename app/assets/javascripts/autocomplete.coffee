# Autocomplete sources
class ConferencesAutocompleteSource
  constructor: ->
    @source = new Bloodhound(
      prefetch:
        url: Routes.autocomplete_conferences_path(prefetch: true)
      remote: Routes.autocomplete_conferences_path(query: '%QUERY')
      datumTokenizer: Bloodhound.tokenizers.obj.whitespace('title')
      queryTokenizer: Bloodhound.tokenizers.whitespace
      dupDetector: (remoteMatch, localMatch) ->
        remoteMatch.id == localMatch.id
    )
    @source.initialize()

  noDirectMatch: (matches, query) ->
    if matches.length > 0
      matches[0].title.toLowerCase() != query.toLowerCase()
    else
      true

  ttAdapter: (query, cb) =>
    @source.get query, (matches) =>
      # Already contains noMatch?
      noMatchIndex = _.findIndex matches, (match) -> match.noMatch
      if noMatchIndex >= 0
        # Make sure the noMatch is at the end
        noMatch = matches.splice noMatchIndex, 1
        matches.push noMatch[0] # splice returns an array
      else
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
        title = suggestion.query
        $(this).trigger 'conference:new', title
        Turbolinks.visit Routes.new_conference_path({ title })
      else if suggestion.url
        $(this).trigger 'conference:show', suggestion.title
        Turbolinks.visit suggestion.url

