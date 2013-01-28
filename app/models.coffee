# # Backbone Models
# This module contains backbone models used throughout the application
define ['backbone', 'exports', 'app/urls', 'i18n!app/nls/strings'], (Backbone, exports, URLS, __) ->

  # The `Content` model contains the following members:
  #
  # * `title` - an HTML title of the content
  # * `language` - the main language (eg `en-us`)
  # * `subjects` - an array of strings (eg `['Mathematics', 'Business']`)
  # * `keywords` - an array of keywords (eg `['constant', 'boltzmann constant']`)
  # * `authors` - an `Collection` of `User`s that are attributed as authors
  exports.Content = Backbone.Model.extend
    defaults:
      title: __('Untitled')
      subjects: []
      keywords: []
      authors: []
      copyrightHolders: []
      # Default language for new content is the browser's language
      language: (navigator?.userLanguage or navigator?.language or 'en').toLowerCase()

    # Set a URL to POST/PUT to when sync'ing the model with the server
    url: -> if @get 'id' then "#{URLS.CONTENT_PREFIX}#{@get 'id'}" else URLS.CONTENT_PREFIX

    # Perform some validation before saving
    validate: (attrs) ->
      isEmpty = (str) -> str and not str.trim().length
      return 'ERROR_EMPTY_BODY' if isEmpty(attrs.body)
      return 'ERROR_EMPTY_TITLE' if isEmpty(attrs.title)
      return 'ERROR_UNTITLED_TITLE' if attrs.title == __('Untitled')

  # The `SearchResultItem` model contains the following members:
  #
  # * `title` - a short title of the item
  # * `type` - the type of the result
  #   This needs to match the prefix used to GET the item
  #   (ie `type="content"` so `GET /#{type}/#{id}` returns an element)
  #
  # Depending on the `type` the result can have additional members.
  #
  # ## type="content"
  #
  # * `created` - Timestamp
  # * `modified` - Timestamp
  # * `modifiedBy` - User that last modified the content (maybe just the user id for now)
  # * `icon?` - for collections (optional) that have a custom book cover
  exports.SearchResultItem = Backbone.Model.extend
    defaults:
      type: 'BUG_UNSPECIFIED_TYPE'
      title: 'BUG_UNSPECIFIED_TITLE'

  exports.Workspace = Backbone.Collection.extend
    model: exports.SearchResultItem
    url: URLS.WORKSPACE

  return exports
