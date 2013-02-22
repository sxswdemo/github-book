# Creates a singleton `Backbone.Model` which represents the logged-in state
# of the user.
#
# If the user logs in/out listeners are fired so views that depend on the
# state are updated (enabled and loaded or disabled).
define ['underscore', 'backbone'], (_, Backbone) ->

  # For the UI, provide a backbone "interface" to the auth piece
  AuthModel = Backbone.Model.extend

    # Returns the `User` model corresponding to the currently logged-in user
    #
    # Used for filtering "Me" from a list of users to share with or listing who
    # last edited a piece of content.
    me: (usersCollection) ->
      _.find usersCollection, (user) => @isMe

    isMe: (user) ->
      userId == user.get 'id'

    signOut: ->
      @set 'id', null, {unset: true}

  # Create a singleton model that represents the authenticated user.
  return new AuthModel()
