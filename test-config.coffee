require.onError = (err) -> console.error err

ALOHA_PATH = 'http://wysiwhat.github.com/Aloha-Editor' # '../Aloha-Editor'

# Configure paths to all the JS libs
require.config

  # # Configure Library Locations
  paths:
    aloha: ALOHA_PATH + '/src/lib/aloha'



require ['app/models'], (Models) ->
  Models.ALL_CONTENT.add
    id: 'test1'
    mediaType: 'text/x-module'
    title: 'Test Module'
    body: '<h1>Hello</h1>'

  Models.ALL_CONTENT.add
    id: 'test2'
    mediaType: 'text/x-module'
    title: 'Another Test Module'
    body: '<h1>Hello2</h1>'

  Models.ALL_CONTENT.add
    id: 'col1'
    mediaType: 'text/x-collection'
    title: 'Test Collection'
    navTree: [
      {title:'Test 1', href: 'test1'}
      {title:'Bob', href: 'test2'}
    ]


  Models.SearchResults = Models.SearchResults.extend
    initialize: ->
      for model in Models.ALL_CONTENT.models
        @add model

  # SEt the loaded flag so we don't try and populate them from the server
  Models.ALL_CONTENT.each (model) -> model.loaded = true
