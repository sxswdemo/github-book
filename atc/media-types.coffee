# ## Extension point for editing Custom Media Types
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
# Entries in here contain a mapping from mime-type to an object that provides:
#
# - A constructor for instantiating new content
# - An `.editAction` which will change the page to become an edit page
#
# Different plugins (Markdown, ASCIIDoc, cnxml) can add themselves to this
define ['backbone'], (Backbone) ->

  # Collection used for storing the various mediaTypes.
  # When something registers a new mediaType views can update
  MediaTypes = Backbone.Collection.extend
    # Just a glorified JSON holder
    model: Backbone.Model.extend
      sync: -> throw 'This model cannot be syncd'
    sync: -> throw 'This model cannot be syncd'

  # Singleton collection
  MEDIA_TYPES = new MediaTypes()

  return {
    add: (mediaType, config) ->
      prev = MEDIA_TYPES.get(mediaType)
      throw 'BUG: You must at least specify a constructor!' if not config.constructor and not prev
      MEDIA_TYPES.add _.extend(config, {id: mediaType}), {merge:true}

    get: (mediaType) ->
      type = MEDIA_TYPES.get mediaType
      if not type
        console.error "ERROR: No editor for media type '#{mediaType}'. Help out by writing one!"
        return MEDIA_TYPES.models[0]
        #     throw 'BUG: mediaType not found'
      return _.omit(type.toJSON(), 'id')

    # Provides a list of all registered media types
    list: ->
      return (type.get 'id' for type in MEDIA_TYPES.models)

    # So views can listen to changes
    asCollection: ->
      return MEDIA_TYPES
  }
