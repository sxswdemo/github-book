define [
  'exports'
  'underscore'
  'backbone'
  'atc/media-types'
  'atc/models'
  'hbs!./opf-file'
  'hbs!./container-file'
  'hbs!./nav-serialize'
], (exports, _, Backbone, MEDIA_TYPES, AtcModels, OPF_TEMPLATE, CONTAINER_TEMPLATE, NAV_SERIALIZE) ->

  BaseCollection = AtcModels.DeferrableCollection
  BaseContent = AtcModels.BaseContent
  BaseBook = AtcModels.BaseBook

  mixin = (src, dest) -> _.defaults dest, src


  TemplatedFileMixin =
    getterField: -> throw 'NO GETTER FIELD SET'
    template: -> throw 'NO TEMPLATE SET'

    parse: (xmlStr) ->
      # this method is called either:
      #
      # - when reading from a sync (`xmlStr` is a string of HTML)
      # - during construction (`xmlStr` is a dictionary of attributes)
      if 'string' == typeof xmlStr
        ret = {}
        ret[@getterField] = xmlStr
        return ret
      else
        return xmlStr
    serialize: -> @template @toJSON()

  HTMLFile = BaseContent.extend _.extend TemplatedFileMixin, {
    mediaType: 'application/xhtml+xml'
    getterField: 'body'
    serialize: -> @get @getterField
  }

  PackageFileMixin = mixin TemplatedFileMixin,
    defaults: _.defaults(BaseBook.prototype.defaults,
      language: 'en'
      title: null
      creator: null
      created: null
      modified: null
      publisher: null
      copyrightDate: null
    )
    getterField: 'content'
    mediaType: 'text/x-collection'

    template: OPF_TEMPLATE
    manifestType: Backbone.Collection.extend
      # Serialize all the spine items
      toJSON: -> model.toJSON() for model in @models

    initialize: ->
      BaseBook.prototype.initialize.apply(@, arguments)

      # When the `navTreeStr` is changed on the package,
      # CHange it on the navigation.html file
      @on 'change:navTreeStr', (model, navTreeStr) =>

        $newTree = jQuery(@navModel.get 'body')

        newTree = NAV_SERIALIZE JSON.parse navTreeStr
        $newTree = jQuery(newTree)

        $bodyNodes = jQuery(@navModel.get 'body')
        # wrap the elements in a div so we can call `$.find`
        $body = jQuery('<div></div>').append $bodyNodes

        $nav = $body.find('nav')
        if $nav
          $nav.replaceWith $newTree
        else
          $body.prepend $nav

        # Serialize the body back out to navigation.html

        if 'html' == $body[0].tagName.toLowerCase()
          bodyStr = $body[0].outerHTML
        else
          if $body.length != 1
            $wrap = jQuery('<div>/<div>')
            $wrap.append $body
            $body = $wrap
          # TODO: Add `<html><head>...</head>` tags around the `$body`
          bodyStr = $body[0].innerHTML
        @navModel.set 'body', bodyStr





      # Once the OPF is populated
      promise = jQuery.Deferred()
      @loaded().then =>
        # Now we know what the navigation HTML file is so go pull it.
        # Then, this model is loaded and views can stop spinning and waiting

        @navModel.loaded().then =>
          # Finally, we have the Navigation HTML!

          # If its contents changes then so does the navTree
          @navModel.on 'change:body', (model, xmlStr) =>
            # Re-parse the tree and set it as the navTree
            # `parseNavTree` is defined in `AppModels.Book`
            @_updateNavTreeFromXML xmlStr

          # Give the HTML files in the manifest some titles from navigation.html
          navTree = @_updateNavTreeFromXML(@navModel.get 'body')
          recSetTitles = (nodes=[]) ->
            for node in nodes
              if node.id
                model = AtcModels.ALL_CONTENT.get node.id
                model.set {title: node.title}
              recSetTitles(node.children)
          recSetTitles navTree

          # Finally, this model is completely loaded.
          # Begin callbacks
          promise.resolve(@)
      @_promise = promise

    _updateNavTreeFromXML: (xmlStr) ->
      # Re-parse the tree and set it as the navTree
      # `parseNavTree` is defined in `AppModels.Book`

      $xml = jQuery(xmlStr)
      return @trigger 'error', 'Could not parse XML' if not $xml[0]

      # `$xml` may contain several top-level elements.
      # Wrap the `$xml` with a `<div/>` so we can call `$body.find()`
      $body = jQuery('<div></div>').append $xml

      # Find the tree and parse it into a JSON object
      $nav = $body.find 'nav'
      throw 'ERROR: Currently only 1 nav element in the navigation document is supported' if $nav.length != 1
      navTree = @parseNavTree($nav).children
      @set 'navTreeStr', JSON.stringify navTree
      return navTree

    parse: (xmlStr) ->
      return xmlStr if 'string' != typeof xmlStr
      $xml = jQuery(jQuery.parseXML xmlStr)

      @manifest = new @manifestType if not @manifest

      # If we were unable to parse the XML then trigger an error
      return model.trigger 'error', 'INVALID_OPF' if not $xml[0]

      # For the structure of the TOC file see `OPF_TEMPLATE`
      bookId = $xml.find("##{$xml.get 'unique-identifier'}").text()

      title = $xml.find('title').text()

      # The manifest contains all the items in the spine
      # but the spine element says which order they are in

      $xml.find('package > manifest > item').each (i, item) =>
        $item = jQuery(item)

        # Add it to the set of all content and construct the correct model based on the mimetype
        mediaType = $item.attr 'media-type'
        ContentType = MEDIA_TYPES.get(mediaType).constructor
        model = new ContentType
          id: $item.attr 'href'
          properties: $item.attr 'properties'

        AtcModels.ALL_CONTENT.add model
        @manifest.add model

        # If we stumbled upon the special navigation document
        # then remember it.
        if 'nav' == $item.attr('properties')
          @navModel = model

      # Ignore the spine because it is defined by the navTree in EPUB3.
      # **TODO:** Fall back on `toc.ncx` and then the `spine` to create a navTree if one does not exist
      return {title: title, bookId: bookId}

    toJSON: ->
      json = BaseBook.prototype.toJSON.apply(@, arguments)
      json.manifest = @manifest.toJSON()
      json

  PackageFile = BaseBook.extend PackageFileMixin




  EPUBContainer = BaseCollection.extend
    template: CONTAINER_TEMPLATE
    model: PackageFile
    defaults:
      urlRoot: ''
    url: -> 'META-INF/container.xml'

    toJSON: -> model.toJSON() for model in @models
    parse: (xmlStr) ->
      $xml = jQuery(xmlStr)
      ret = []
      $xml.find('rootfiles > rootfile').each (i, el) =>
        href = jQuery(el).attr 'full-path'
        ret.push {id: href, title: 'Loading Book Title...'}
      return ret


  MEDIA_TYPES.add 'application/xhtml+xml', {constructor: HTMLFile, editAction: MEDIA_TYPES.get('text/x-module').editAction}

  exports.EPUB_CONTAINER = new EPUBContainer()

  return exports