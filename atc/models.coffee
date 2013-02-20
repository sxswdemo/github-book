# # Backbone Models
# This module contains backbone models used throughout the application
#
# It also has some hardcoded URLs for syncing with the server (GET/POST/PUT URLs)
define ['exports', 'jquery', 'backbone', 'i18n!atc/nls/strings'], (exports, jQuery, Backbone, __) ->

  # Contains a mapping from mime-type to a `Backbone.Model` constructor
  # Different plugins (Markdown, ASCIIDoc, cnxml) can add themselves to this
  MediaTypes = Backbone.Collection.extend
    # Just a glorified JSON holder
    model: Backbone.Model.extend
      sync: -> throw 'This model cannot be syncd'
    sync: -> throw 'This model cannot be syncd'

  MEDIA_TYPES = new MediaTypes()


  BaseContent = Backbone.Model.extend
    initialize: ->
      mediaType = @get 'mediaType'
      throw 'BUG: No mediaType set' if not mediaType
      throw 'BUG: No mediaType not registered' if not MEDIA_TYPES.get mediaType

      # Mixin the subclasses fields
      mediaTypeConfig = MEDIA_TYPES.get mediaType
      proto = mediaTypeConfig.get('constructor').prototype
      for key, value of proto
        @[key] = value

      # Call the mixed-in constructor
      proto.initialize.apply(this, arguments)

  # This should be read-only by others
  # New content models should be created by calling `newContent(id)`
  AllContent = Backbone.Collection.extend
    model: BaseContent

  ALL_CONTENT = new AllContent()


  # A model representing a piece of content may not have been fetched yet
  # Once it is loaded (fetched) call the callbacks.

  deferred= (cb) ->
    return cb(null, @) if @loaded
    @_defer = @fetch() if not @_defer
    @_defer
    .done (value) =>
      @loaded = true
      @_defer = null
      cb(null, @)
    .fail (err) =>
      @loaded = false
      @_defer = null
      cb(err, @)

  Deferrable = Backbone.Model.extend
    deferred: () -> deferred.apply(@, arguments)

  DeferrableCollection = Backbone.Collection.extend
    deferred: () -> deferred.apply(@, arguments)


  exports.FilteredCollection = Backbone.Collection.extend
    defaults:
      collection: null
    setFilter: (str) ->
      return if @filterStr == str
      @filterStr = str

      # Remove anything that no longer matches
      models = (@collection.filter (model) => @isMatch(model))
      @reset models

    isMatch: (model) ->
      return true if not @filterStr
      model.get('title').toLowerCase().search(@filterStr.toLowerCase()) >= 0

    initialize: (models, options) ->
      @filterStr = options.filterStr or ''
      @collection = options.collection
      throw 'BUG: Cannot filter on a non-existent collection' if not @collection

      @add (@collection.filter (model) => @isMatch(model))

      @collection.on 'add', (model) =>
        @add model if @isMatch(model)

      @collection.on 'remove', (model) => @remove model

      @collection.on 'change', (model) =>
        if @isMatch(model)
          @add model
        else
          @remove model



  # The `Content` model contains the following members:
  #
  # * `title` - an HTML title of the content
  # * `language` - the main language (eg `en-us`)
  # * `subjects` - an array of strings (eg `['Mathematics', 'Business']`)
  # * `keywords` - an array of keywords (eg `['constant', 'boltzmann constant']`)
  # * `authors` - an `Collection` of `User`s that are attributed as authors
  Content = Deferrable.extend
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


  # This represents a collection but is called a book so as not to confuse with Backbone.Collection
  Book = Deferrable.extend
    defaults:
      manifest: null
      navTree: null

    # Also used by the DnD edit view
    parseNavTree: (li) ->
      $li = jQuery(li)

      $a = $li.children 'a, span'
      $ol = $li.children 'ol'

      obj = {id: $a.attr('href') or $a.data('id'), title: $a.text()}

      # The custom class is either set on the $span (if parsing from the editor) or on the $a (if parsing from an EPUB)
      obj.class = $a.data('class') or $a.not('span').attr('class')

      obj.children = (@parseNavTree(li) for li in $ol.children()) if $ol[0]
      return obj

    deferred: () -> deferred.apply(@, arguments)
    initialize: ->
      @manifest = new Backbone.Collection()
      @manifest.on 'change:title', (model, newValue, oldValue) =>
        navTree = @getNavTree()
        # Find the node that has an id to this model
        recFind = (nodes) ->
          for node in nodes
            return node if model.id == node.id
            return recFind node.children if node.children
        node = recFind(navTree)
        throw 'BUG: There is an entry in the tree but no corresponding model in the manifest' if not node
        node.title = newValue
        @set 'navTree', navTree

      @manifest.on 'add', (model) -> ALL_CONTENT.add model
      @on 'change:navTree', (model, navTree) =>
        # **TODO:** Remove manifest entries if they are not referred to by the navTree or any modules in the book.
        recAdd = (nodes) =>
          for node in nodes
            if node.id
              ALL_CONTENT.add {id: node.id, title: node.title, mediaType: 'text/x-module'}
              contentModel = ALL_CONTENT.get node.id
              @manifest.add contentModel
            recAdd node.children if node.children
        recAdd(navTree) if navTree

      @trigger 'change:navTree', @, @getNavTree()

    prependNewContent: (config) ->
      uuid = b = (a) ->
        (if a then (a ^ Math.random() * 16 >> a / 4).toString(16) else ([1e7] + -1e3 + -4e3 + -8e3 + -1e11).replace(/[018]/g, b))
      config.id = uuid() if not config.id
      ALL_CONTENT.add config
      newContent = ALL_CONTENT.get config.id
      navTree = @getNavTree()
      navTree.unshift {id: config.id, title: config.title}
      @set 'navTree', navTree


    getNavTree: (tree) ->
      return JSON.parse JSON.stringify(@get 'navTree')

  SearchResults = DeferrableCollection.extend
    defaults:
      parameters: []


  MEDIA_TYPES.add
    id: 'text/x-module'
    constructor: Content

  MEDIA_TYPES.add
    id: 'text/x-collection'
    constructor: Book


  exports.ALL_CONTENT = ALL_CONTENT
  exports.MEDIA_TYPES = MEDIA_TYPES
  exports.SearchResults = SearchResults
  return exports
