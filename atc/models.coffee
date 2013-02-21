# # Backbone Models
# This module contains backbone models used throughout the application
define ['exports', 'jquery', 'backbone', 'i18n!atc/nls/strings'], (exports, jQuery, Backbone, __) ->

  # ## Custom Media Types Plugin
  #
  # Several languages translate to HTML (Markdown, ASCIIDoc, cnxml).
  #
  # Developers can extend the types used by registering to handle different mime-types.
  # Making an extension requires the following:
  #
  # - `parse()` and `serialize()` functions for
  #     reading in the file and writing it to HTML
  # - An Edit View for editing the content
  #
  # Entries in here contain a mapping from mime-type to a `Backbone.Model` constructor
  # Different plugins (Markdown, ASCIIDoc, cnxml) can add themselves to this
  MediaTypes = Backbone.Collection.extend
    # Just a glorified JSON holder
    model: Backbone.Model.extend
      sync: -> throw 'This model cannot be syncd'
    sync: -> throw 'This model cannot be syncd'

  # This is exported at the end of the module
  MEDIA_TYPES = new MediaTypes()


  # Custom Models defined above are mixed in using `BaseContent.initialize`
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

  # ## All Content
  #
  # To prevent multiple copies of a model from floating around a single
  # copy of all referenced content (loaded or not) is kept in this Collection
  #
  # This should be read-only by others
  # New content models should be created by calling `ALL_CONTENT.add {}`
  AllContent = Backbone.Collection.extend
    model: BaseContent

  ALL_CONTENT = new AllContent()


  # ## Promises
  # A model representing a piece of content may have been instantiated
  # (ie an entry as a result of a search) but not fetched yet.
  #
  # When dealing with a model (except for `id`, `title`, or `mediaType`)
  # be sure to call `deferred(cb)` first.
  #
  # Once the model is loaded (fetched) call the callbacks.

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


  # When searching for text, perform a local filter on content while we wait
  # for the server to respond.
  #
  # This Collection takes another Collection and maintains an active filter on it.
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


  # Represents a "collection" in [Connexions](http://cnx.org) terminology and an `.opf` file in an EPUB
  Book = Deferrable.extend
    defaults:
      manifest: null
      navTree: null

    # Takes an element representing a `<nav epub:type="toc"/>` element
    # and returns a JSON tree with the following structure:
    #
    #     [
    #       {id: 'path/to/file1.html', title: 'Appendix', children: [...] },
    #       {title: 'Unit 3', class: 'unit', children: [...] }
    #     ]
    # See [The toc nav Element](http://idpf.org/epub/30/spec/epub30-contentdocs.html#sec-xhtml-nav-def-types-toc) for more information.
    #
    # This method is also used by the DnD edit view.
    #
    # Example from an ePUB3:
    #
    #     <nav epub:type="toc">
    #       <ol>
    #         <li><a href="path/to/file1.html">Appendix</a></li>
    #         <li class="unit"><span>Unit 3</span><ol>[...]</ol></li>
    #       </ol>
    #     </nav>
    #
    # Example from the Drag-and-Drop Book editor (Tree View):
    #
    #     <div>
    #       <ol>
    #         <li><span data-id="path/to/file1.html">Appendix</a></li>
    #         <li class="unit"><span>Unit 3</span><ol>[...]</ol></li>
    #       </ol>
    #     </nav>
    parseNavTree: (li) ->
      $li = jQuery(li)

      $a = $li.children 'a, span'
      $ol = $li.children 'ol'

      obj = {id: $a.attr('href') or $a.data('id'), title: $a.text()}

      # The custom class is either set on the `$span` (if parsing from the editor) or on the `$a` (if parsing from an EPUB)
      obj.class = $a.data('class') or $a.not('span').attr('class')

      obj.children = (@parseNavTree(li) for li in $ol.children()) if $ol[0]
      return obj

    # Creates a Manifest collection of all content it should listen to.
    #
    # For example, changes to `id` or `title` of a piece of content will update the navigation tree.
    #
    # Similarly, an update to the navigation tree will create new models.
    initialize: ->
      @manifest = new Backbone.Collection()
      @manifest.on 'change:title', (model, newValue, oldValue) =>
        navTree = @getNavTree()
        # Find the node that has an `id` to this model
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

    # **FIXME:** Somewhat hacky way of creating a new piece of content
    prependNewContent: (config) ->
      uuid = b = (a) ->
        (if a then (a ^ Math.random() * 16 >> a / 4).toString(16) else ([1e7] + -1e3 + -4e3 + -8e3 + -1e11).replace(/[018]/g, b))
      config.id = uuid() if not config.id
      ALL_CONTENT.add config
      newContent = ALL_CONTENT.get config.id
      navTree = @getNavTree()
      navTree.unshift {id: config.id, title: config.title}
      @set 'navTree', navTree


    # Since the nav tree is just a plain JSON object and changes to it will not trigger model changes
    # return a deep clone of the tree before making a change to it.
    #
    # **FIXME:** This should be implemented using a Tree-Like Collection that has a `.toJSON()` and methods like `.insertBefore()`
    getNavTree: (tree) ->
      return JSON.parse JSON.stringify(@get 'navTree')

  SearchResults = DeferrableCollection.extend
    defaults:
      parameters: []

  # Add the 2 basic Media Types already defined above
  MEDIA_TYPES.add
    id: 'text/x-module'
    constructor: Content

  MEDIA_TYPES.add
    id: 'text/x-collection'
    constructor: Book

  # Finally, export only the pieces needed (so as not to accidentally create 2 copies of a `Book`)
  exports.ALL_CONTENT = ALL_CONTENT
  exports.MEDIA_TYPES = MEDIA_TYPES
  exports.SearchResults = SearchResults
  return exports
