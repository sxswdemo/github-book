define ['github', 'backbone'], (Github, Backbone) ->

  # Singleton variables representing the Github user and current repo
  github = null
  repo = null

  # For the UI, provide a backbone "interface" to the auth piece
  AuthModel = Backbone.Model.extend
    defaults:
      username: 'philschatz'
      password: ''
      auth: 'basic'

      repoUser: 'philschatz'
      repoName: 'github-book'

      branch: 'sample-book'
      # **Remember:** `rootPath` always needs a trailing slash!
      rootPath: ''

    # Updates the singleton variables `github` and `repo`
    _update: ->
      credentials =
        username: @get 'username'
        password: @get 'password'
        token:    @get 'token'
        auth:     @get 'auth'
      github = new Github(credentials)
      repo = null

      json = @toJSON()
      if json.repoUser and json.repoName
        repo = github.getRepo json.repoUser, json.repoName

    initialize: ->
      @_update()

      @on 'change', @_update

    authenticate: (credentials) -> @set credentials
    setRepo: (repoUser, repoName) -> @set
      repoUser: repoUser
      repoName: repoName

    getRepo: -> repo
    getUser: -> github?.getUser()
    signOut: ->
      github = null
      repo = null
      @set {
        username: 'philschatz'
        password: ''
      }

    # When saving do not run `Backbone.sync`.
    sync: (method, model, options) ->
      @_update()
      # Fire the success callback if it exists
      options?.success?()

  return new AuthModel()
