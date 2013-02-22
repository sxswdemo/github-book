define [
  'backbone'
  'marionette'
  'atc/controller'
  'atc/models'
  'epub/models'
  'atc/auth'
  'atc/views'
  'hbs!gh-book/sign-in-out'
  'hbs!gh-book/fork-book-item'
  'css!atc'
], (Backbone, Marionette, Controller, AtcModels, EpubModels, Auth, Views, SIGN_IN_OUT, FORK_BOOK_ITEM) ->


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

    switch method
      when 'read' then return readFile(path, callback)
      when 'update' then return writeFile(path, model.serialize(), 'Editor Save', callback)
      when 'create'
        # Create an id if this model has not been saved yet
        id = _uuid()
        model.set 'id', id
        return writeFile(path, model.serialize(), callback)
      else throw "Model sync method not supported: #{method}"



  # Save each model in sequence.
  # **FIXME:** This should be done in a commit batch
  _saveContent = ->
    allContent = AtcModels.ALL_CONTENT.filter (model) -> model.hasChanged()

    console.log "Saving #{allContent.length} files back to github"

    recSave = ->
      if allContent.length == 0
        AtcModels.ALL_CONTENT.trigger 'sync'
      else
        model = allContent.shift()
        saving = model.save null,
            success: recSave
        if not saving
          console.log "Skipping #{model.id} because it is not valid"
          recSave()

    recSave()



  # ## Auth View
  # The top-right of each page should have either:
  #
  # 1. a Sign-up/Login link if not logged in
  # 2. a logoff link with the current user name if logged in
  #
  # This view updates when the login state changes
  Views.AuthView = Marionette.ItemView.extend
    template: SIGN_IN_OUT
    events:
      'click #sign-in':       'signIn'
      'click #sign-out':      'signOut'
      'click #save-settings': 'saveSettings'
      'click #save-content':  'saveContent'
      'click #fork-book':     'forkBook'

    initialize: ->
      # Listen to all changes made on Content so we can update the save button
      @listenTo AtcModels.ALL_CONTENT, 'change', =>
        $save = @$el.find '#save-content'
        $save.removeClass('disabled')
        $save.addClass('btn-primary')

      # If the repo changes and all of the content is reset, update the button
      disableSave = =>
        $save = @$el.find '#save-content'
        $save.addClass('disabled')
        $save.removeClass('btn-primary')

      @listenTo AtcModels.ALL_CONTENT, 'sync', disableSave
      @listenTo AtcModels.ALL_CONTENT, 'reset', disableSave

    onRender: ->
      # Enable tooltips
      @$el.find('*[title]').tooltip()

      # Listen to model changes
      @listenTo @model, 'change', => @render()

    signIn: ->
      # Set the username and password in the `Auth` model
      @model.set
        username: @$el.find('#github-username').val()
        password: @$el.find('#github-password').val()

    # Clicking on the link will redirect to the logoff page
    # Before it does, update the model
    signOut: -> @model.signOut()

    forkBook: ->
      # Show an alert if the user is not logged in
      return alert 'Please log in to fork or just go to the github page and fork the book!' if not @model.get 'password'

      # Populate the fork modal before showing it
      $fork = @$el.find '#fork-book-modal'


      forkHandler = (org) -> () ->
        Auth.getRepo().fork (err, resp) ->
          # Close the modal dialog
          $fork.modal('hide')

          throw "Problem forking: #{err}" if err
          alert 'Thanks for forking!\nThe current repo (in settings) has been updated to point to your fork. \nThe next time you click Save the changes will (hopefully) be saved to your forked book.\nIf not, refresh the page and change the Repo User in Settings.'

          Auth.set 'repoUser', org


      Auth.getUser().orgs (err, orgs) ->
        $list = $fork.find('.modal-body').empty()

        $item = @$(FORK_BOOK_ITEM {login: Auth.get 'username'})
        $item.find('button').on 'click', forkHandler(null)
        $list.append $item

        _.each orgs, (org) ->
          $item = @$(FORK_BOOK_ITEM {login: "#{org.login} (Organization)"})
          # For now disallow forking to organizations.
          #     $item.find('button').on 'click', forkHandler(org)
          $item.addClass 'disabled'

          $list.append $item


        # Show the modal
        $fork.modal('show')



    saveSettings: ->
      # Add a trailing slash to the root path if one is set
      rootPath = @$el.find('#github-rootPath').val()
      rootPath += '/' if rootPath and rootPath[rootPath.length-2] != '/'

      # Update the repo settings
      @model.set
        repoUser: @$el.find('#github-repoUser').val()
        repoName: @$el.find('#github-repoName').val()
        branch:   @$el.find('#github-branch').val()
        rootPath: rootPath

    saveContent: -> _saveContent()






  resetDesktop = ->
    # Change how the workspace is loaded (from `META-INF/content.xml`)
    #
    # `EPUB_CONTAINER` will fill in the workspace just by requesting files
    EpubModels.EPUB_CONTAINER.loaded().then ->

      AtcModels.SearchResults = AtcModels.SearchResults.extend
        initialize: ->
          for model in AtcModels.ALL_CONTENT.models
            if model.get('mediaType') != 'text/x-module'
              @add model, {at: 0}
            else
              @add model

      # Begin listening to route changes
      # and load the initial views based on the URL.
      Controller.start()




  # Clear everything and refetch when the
  #Auth.on 'change:repoUser', resetDesktop
  #Auth.on 'change:repoName', resetDesktop
  #Auth.on 'change:branch', resetDesktop
  #Auth.on 'change:rootPath', resetDesktop


  # Auth.set 'password', prompt('Enter password')
  resetDesktop()
