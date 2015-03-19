# Autocomplete sources
class ConferencesAutocompleteSource
  constructor: ->
    @source = new Bloodhound(
      prefetch:
        url: Routes.autocomplete_conferences_path(prefetch: true)
      remote: Routes.autocomplete_conferences_path() + "?query=%QUERY"
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

  ttAdapter: ->
    (query, cb) =>
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

class TagsAutoCompleteSource
  constructor: (tags) ->
    @source = new Bloodhound(
      local: _.map(tags, (tag) -> value: tag)
      datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value')
      queryTokenizer: Bloodhound.tokenizers.whitespace
    )
    @source.initialize()

  ttAdapter: ->
    @source.ttAdapter()

# Typeahead inputs
typeaheadOptions = null
$ ->
  tagsSource = new TagsAutoCompleteSource(SearchTags) # From HTML script tag

  # Search in navbar
  $input = $('.conference-search')
  $input.typeahead typeaheadOptions,
    {
      name: 'conferences'
      displayKey: 'title'
      source: conferencesSource.ttAdapter()
      templates:
        header: JST['templates/autocomplete/header'](name: "Conferences")
        suggestion: (suggestion) ->
          if suggestion.noMatch
            JST['templates/autocomplete/add'](suggestion)
          else
            JST['templates/autocomplete/suggestion'](suggestion)
    },
    {
      name: 'tags'
      source: tagsSource.ttAdapter()
      templates:
        suggestion: JST['templates/autocomplete/tag']
        header: JST['templates/autocomplete/header'](name: "Topics")
    }

  $input.on 'typeahead:selected', (event, suggestion, dataset) ->
    switch dataset
      when 'conferences'
        if suggestion.noMatch
          title = suggestion.query
          $(this).trigger 'conference:new', title
          Turbolinks.visit Routes.new_conference_path({ title })
        else if suggestion.url
          $(this).trigger 'conference:show', suggestion.title
          Turbolinks.visit suggestion.url

      when 'tags'
        tag = suggestion.value
        $(this).trigger 'tags:show', tag
        Turbolinks.visit Routes.conferences_path(query: tag)

