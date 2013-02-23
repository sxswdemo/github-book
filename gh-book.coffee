define [
  'underscore'
  'backbone'
  'atc/controller'
  'atc/models'
  'epub/models'
  'atc/auth'
  'gh-book/views'
  'css!atc'
], (_, Backbone, Controller, AtcModels, EpubModels, Auth, Views) ->

  DEBUG = true

  # Generate UUIDv4 id's (from http://stackoverflow.com/questions/105034/how-to-create-a-guid-uuid-in-javascript)
  uuid = b = (a) ->
    (if a then (a ^ Math.random() * 16 >> a / 4).toString(16) else ([1e7] + -1e3 + -4e3 + -8e3 + -1e11).replace(/[018]/g, b))


  defer = (fn) ->
    return () ->
      # splice off the callback (the last arg)
      [args..., cb] = arguments

      deferred = jQuery.Deferred()
      callback = (err, value) ->
        cb(err, value)
        if err
          deferred.reject err, value
        else
          deferred.resolve value

      # Put our callback which updates the promise on as the last argument
      args.push callback
      # Do the asynchronous work (read/write)
      fn.apply(@, args)

      return deferred.promise()



  writeFile = defer (path, text, commitText, cb) ->
    Auth.getRepo().write Auth.get('branch'), "#{Auth.get('rootPath')}#{path}", text, commitText, cb

  readFile = defer (path, cb) -> Auth.getRepo().read Auth.get('branch'), "#{Auth.get('rootPath')}#{path}", cb
  readDir =  defer (path, cb) -> Auth.getRepo().contents Auth.get('branch'), path, cb




  Backbone.sync = (method, model, options) ->
    success = options?.success
    error = options?.error

    callback = (err, value) ->
      return error?(model, err, options) if err
      return success?(model, value, options)

    path = model.id or model.url?() or model.url

    console.log method, path if DEBUG
    switch method
      when 'read' then return readFile(path, callback)
      when 'update' then return writeFile(path, model.serialize(), 'Editor Save', callback)
      when 'create'
        # Create an id if this model has not been saved yet
        id = _uuid()
        model.set 'id', id
        return writeFile(path, model.serialize(), callback)
      else throw "Model sync method not supported: #{method}"








  AtcModels.SearchResults = AtcModels.SearchResults.extend
    initialize: ->
      for model in AtcModels.ALL_CONTENT.models
        if model.get('mediaType') != 'text/x-module'
          @add model, {at: 0}
        else
          @add model

      AtcModels.ALL_CONTENT.on 'reset',  () => @reset()
      AtcModels.ALL_CONTENT.on 'add',    (model) => @add model
      AtcModels.ALL_CONTENT.on 'remove', (model) => @remove model



  resetDesktop = ->
    # Clear out all the content and reset `EPUB_CONTAINER` so it is always fetched
    AtcModels.ALL_CONTENT.reset()
    EpubModels.EPUB_CONTAINER.reset()
    EpubModels.EPUB_CONTAINER._promise = null


    # Change how the workspace is loaded (from `META-INF/content.xml`)
    #
    # `EPUB_CONTAINER` will fill in the workspace just by requesting files
    EpubModels.EPUB_CONTAINER.loaded().then () ->

      # fetch all the book contents so the workspace is populated
      EpubModels.EPUB_CONTAINER.each (book) -> book.loaded().then () ->
        console.log book.id


      # Begin listening to route changes
      # and load the initial views based on the URL.
      if not Backbone.History.started
        Controller.start()
      Backbone.history.navigate('workspace')




  # Clear everything and refetch when the
  Auth.on 'change', () ->
    if not _.isEmpty(_.pick Auth.changed, 'repoUser', 'repoName', 'branch', 'rootPath')
      resetDesktop()
  #Auth.on 'change:repoName', resetDesktop
  #Auth.on 'change:branch', resetDesktop
  #Auth.on 'change:rootPath', resetDesktop


  # Auth.set 'password', prompt('Enter password')
  resetDesktop()
