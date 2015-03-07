# Track events in Google Analytics
$ ->
  # Track page load by Turbolinks
  _gaq.push(['_trackPageview'])

  $('.omniauth-sign-in').on 'click', ->
    provider = $(this).data('provider')
    trackUserEvent 'Sign in', provider

  $('.user-sign-out').on 'click', ->
    trackUserEvent 'Sign out'

  $('.search-form').on 'submit', ->
    query = $(this).find('[name="query"]').val()
    trackConferenceEvent 'Search', query

  $('.conference-search').on('conference:new', (event, title) ->
    trackConferenceEvent 'Autocomplete new', title
  ).on('conference:show', (event, title) ->
    trackConferenceEvent 'Autocomplete show', title
  )

  $('.btn-radar').on 'click', ->
    title = $(this).data('title')
    action = $(this).data('following') == '1' ? 'Unfollow' : 'Follow'
    trackConferenceEvent action, title

  $('.new_conference').on 'submit', ->
    title = $(this).find('[name="conference[title]"]').val()
    trackConferenceEvent "New", title

  $('.edit_conference').on 'submit', ->
    title = $(this).find('[name="conference[title]"]').val()
    trackConferenceEvent "Edit", title

trackUserEvent = ->
    _gaq.push ['_trackEvent', 'Users'].concat([].splice.call(arguments,0))

trackConferenceEvent = ->
    _gaq.push ['_trackEvent', 'Conferences'].concat([].splice.call(arguments,0))

