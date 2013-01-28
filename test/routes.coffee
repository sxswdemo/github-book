# This file sets up all the routes for the mock AJAX object for all tests
# It can be used as documentation for how the webserver should behave
define ['jquery', 'jquery-mockjax'], ($) ->

  # a *short* but nonzero response time
  SHORT = 500 #ms

  # ## Example Content
  # This is returned by the `GET` by default.
  # It is also exported so it can be used for unit tests.
  MOCK_CONTENT =
    url: '/content/123.metadata'
    title: 'Test Module Title'
    language: 'sv-se'
    subjects: ['Arts', 'Business']
    keywords: ['Quantum Mechanics', 'physics']
    authors: ['John Smith']


  # ## Content and Metadata
  # This call handles changing the metadata on content.
  # It stores the state of the metadata in `RESPONSE_METADATA`
  # but because of a mockjax "annoyance" (`responseText` can never change)
  # the object needs to be cleared and repopulated when the `POST` occurs
  RESPONSE_METADATA = $.extend({}, MOCK_CONTENT)
  $.mockjax
    type: 'GET'
    url: '/content/*'
    responseTime: SHORT
    contentType: 'application/json'
    responseText: RESPONSE_METADATA

  $.mockjax
    type: 'POST'
    url: '/content/*'
    responseTime: SHORT
    contentType: 'application/json'
    response: (settings) ->
      # Clear and repopulate the METADATA for subsequent `GET` requests
      delete RESPONSE_METADATA[key] for key of RESPONSE_METADATA
      $.extend RESPONSE_METADATA, JSON.parse(settings.data)

  # ## Search Lookups
  # These allow searching for the tagit UI elements
  # TODO: They should probably be refactored to a more uniform search query like `/search?type=[NOUN]&q=...`
  $.mockjax
    type: 'GET'
    url: '/keywords/'
    responseTime: SHORT
    contentType: 'application/json'
    responseText: ['alpha', 'beta', 'water', 'physics', 'organic chemistry']

  $.mockjax
    type: 'GET'
    url: '/users/'
    responseTime: SHORT
    contentType: 'application/json'
    responseText: ['Bruce Wayne', 'Peter Parker', 'Clark Kent']

  # Return a deep copy of mock content for use in tests
  return $.extend(true, {}, MOCK_CONTENT)
