# # Backbone Views
# Most views have the following properties:
#
# 1. Load a Handlebar template using the `hbs` plugin (see `define` below)
# 2. Attach listeners to the corresponding model (see `initialize` methods)
# 3. Attach jQuery listeners to the rendered template (see `onRender` methods)
# 4. Navigate to a different "page" (see `Controller.*` in the `jQuery.on` handlers)
#
# Description of method naming:
#
# 1. `_change*` Modifies the model based on a change in the view
# 2. `_update*` Modifies the view based on changes to the model
#

#
define [
  'exports'
  'underscore'
  'backbone'
  'marionette'
  'jquery'
  'aloha'
  'app/urls'
  'app/controller'
  './languages'
  # Load the Handlebar templates
  'hbs!app/views/content-list'
  'hbs!app/views/content-list-item'
  'hbs!app/views/modal-wrapper'
  'hbs!app/views/edit-metadata'
  'hbs!app/views/edit-roles'
  'hbs!app/views/language-variants'
  'hbs!app/views/aloha-toolbar'
  'hbs!app/views/sign-in-out'
  # Load internationalized strings
  'i18n!app/nls/strings'
  # `bootstrap` and `select2` add to jQuery and don't export anything of their own
  # so they are 'defined' _after_ everything else
  'bootstrap'
  'select2'
  # Include CSS icons used by the toolbar
  'css!font-awesome'
], (exports, _, Backbone, Marionette, jQuery, Aloha, URLS, Controller, Languages, SEARCH_RESULT, SEARCH_RESULT_ITEM, DIALOG_WRAPPER, EDIT_METADATA, EDIT_ROLES, LANGUAGE_VARIANTS, ALOHA_TOOLBAR, SIGN_IN_OUT, __) ->

  # **FIXME:** Move this delay into a common module so the mock AJAX code can use them too
  DELAY_BEFORE_SAVING = 3000

  # Select2 is a multiselect UI library.
  # It queries the webserver to provide search results as you type
  #
  # Given a `url` to query (like `/users` or `/keywords`) this returns a config
  # used when binding select2 to an input.
  SELECT2_AJAX_HANDLER = (url) ->
    quietMillis: 500
    url: url
    dataType: 'json'
    data: (term, page) ->
      q: term # search term
    # parse the results into the format expected by Select2
    results: (data, page) ->
      return {
        results: ({id:id, text:id} for id in data)
      }

  # Make a multiselect widget sortable using jQueryUI.
  # Unfortunately jQueryUI is not available until Aloha finishes loading
  # so postpone making it sortable until `Aloha.ready`
  SELECT2_MAKE_SORTABLE = ($el) ->
    Aloha.ready ->
      $el.select2('container')
      .find('ul.select2-choices')
      .sortable
        cursor: 'move'
        containment: 'parent'
        start: ->  $el.select2 'onSortStart'
        update: -> $el.select2 'onSortEnd'


  # **FIXME:** Move these subjects to a common module so the mock code can use them and can be used elsewhere
  METADATA_SUBJECTS = ['Arts', 'Mathematics and Statistics', 'Business',
    'Science and Technology', 'Humanities', 'Social Sciences']

  # Given the language list in [languages.coffee](languages.html)
  # this reorganizes them so they can be shown in a dropdown.
  LANGUAGES = [{code: '', native: '', english: ''}]
  for languageCode, value of Languages.getLanguages()
    value = jQuery.extend({}, value)  # Clone the value.
    jQuery.extend(value, {code: languageCode})
    LANGUAGES.push(value)


  # ## "Generic" Views
  #
  # A list of search results (stubs of models only containing an icon, url, title)
  # need a generic view for an item.
  #
  # Since we don't really distinguish between a search result view and a workspace/collection/etc
  # just consider them the same.
  exports.SearchResultItemView = Marionette.ItemView.extend
    tagName: 'tr'
    template: SEARCH_RESULT_ITEM
    onRender: ->
      @$el.on 'click', =>
        id = @model.get 'id'
        Controller.editContent(id)

  # This can also be thought of as the Workspace view
  exports.SearchResultView = Marionette.CompositeView.extend
    template: SEARCH_RESULT
    itemViewContainer: 'tbody'
    itemView: exports.SearchResultItemView

    initialize: ->
      @listenTo @collection, 'reset',   => @render()
      @listenTo @collection, 'update',  => @render()
      @listenTo @collection, 'add',     => @render()
      @listenTo @collection, 'remove',  => @render()



  AlohaEditView = Marionette.ItemView.extend
    # **NOTE:** This template is not wrapped in an element
    template: () -> throw 'You need to specify a template, modelKey, and optionally alohaOptions'
    modelKey: null
    alohaOptions: null

    initialize: ->
      @listenTo @model, "change:#{@modelKey}", (model, value) =>
        alohaId = @$el.attr('id')
        # Sometimes Aloha hasn't loaded up yet
        if alohaId and @$el.parents()[0]
          alohaEditable = Aloha.getEditableById(alohaId)
          editableBody = alohaEditable.getContents()
          alohaEditable.setContents(value) if value != editableBody
        else
          @$el.empty().append(value)

    onRender: ->
      # Wait until Aloha is started before loading MathJax.
      # Also, wrap all math in a span/div. MathJax replaces the MathJax element
      # losing all jQuery data attached to it (like popover data, the original Math Formula, etc).
      #
      # Add `aloha-cleanme` so this span is unwrapped when serialized to XHTML
      @$el.find('math').wrap '<span class="math-element aloha-cleanme"></span>'
      MathJax.Hub.Configured() if MathJax?

      # Once Aloha has finished loading enable
      @$el.addClass('disabled')
      Aloha.ready =>
        @$el.aloha(@alohaOptions)
        @$el.removeClass('disabled')

      # Auto save after the user has stopped making changes
      updateModelAndSave = =>
        alohaId = @$el.attr('id')
        # Sometimes Aloha hasn't loaded up yet
        # Only save when the editable has changed
        if alohaId
          alohaEditable = Aloha.getEditableById(alohaId)
          editableBody = alohaEditable.getContents()
          @model.set @modelKey, editableBody
          @model.save() if @model.changedAttributes()

      # Grr, the `aloha-smart-content-changed` can only be listened to globally
      # (via `Aloha.bind`) instead of on each editable.
      #
      # This is problematic when we have multiple Aloha editors on a page.
      # Instead, autosave after some period of inactivity.
      @$el.on 'blur', updateModelAndSave



  # ## Edit Content Body
  exports.ContentEditView = AlohaEditView.extend
    # **NOTE:** This template is not wrapped in an element
    template: (serialized_model) -> "#{serialized_model.body or 'This module is empty. Please change it'}"
    modelKey: 'body'

  exports.TitleEditView = AlohaEditView.extend
    # **NOTE:** This template is not wrapped in an element
    template: (serialized_model) -> "#{serialized_model.title or 'Untitled'}"
    modelKey: 'title'
    tagName: 'span' # override the default tagName of `div` so titles can be edited inline.


  exports.ContentToolbarView = Marionette.ItemView.extend
    template: ALOHA_TOOLBAR

    onRender: ->
      # Wait until Aloha is started before enabling the toolbar
      @$el.addClass('disabled')
      Aloha.ready =>
        @$el.removeClass('disabled')


  exports.MetadataEditView = Marionette.ItemView.extend
    template: EDIT_METADATA

    # Bind methods onto jQuery events that happen in the view
    events:
      'change *[name=language]': '_updateLanguageVariant'

    initialize: ->
      @listenTo @model, 'change:language', => @_updateLanguage()
      @listenTo @model, 'change:subjects', => @_updateSubjects()
      @listenTo @model, 'change:keywords', => @_updateKeywords()

    # Update the UI when the language changes.
    # Also called during initial render
    _updateLanguage: () ->
      language = @model.get('language') or ''
      [lang] = language.split('-')
      @$el.find("*[name=language]").select2('val', lang)
      @_updateLanguageVariant()

    _updateLanguageVariant: () ->
      $language = @$el.find('*[name=language]')
      language = @model.get('language') or ''
      [lang, variant] = language.split('-')
      if $language.val() != lang
        lang = $language.val()
        variant = null
      $variant = @$el.find('*[name=variantLanguage]')
      $label = @$el.find('*[for=variantLanguage]')
      variants = []
      for code, value of Languages.getCombined()
        if code[..1] == lang
          jQuery.extend(value, {code: code})
          variants.push(value)
      if variants.length > 0
        # Generate the language variants dropdown.
        $variant.removeAttr('disabled')
        $variant.html(LANGUAGE_VARIANTS('variants': variants))
        $variant.find("option[value=#{language}]").attr('selected', true)
        $label.removeClass('hidden')
        $variant.removeClass('hidden')
      else
        $variant.empty().attr('disabled', true)
        $variant.addClass('hidden')
        $label.addClass('hidden')

    # Helper method to populate a multiselect input
    _updateSelect2: (key) ->
      @$el.find("*[name=#{key}]").select2('val', @model.get key)

    # Update the View with new subjects selected
    _updateSubjects: -> @_updateSelect2 'subjects'

    # Update the View with new keywords selected
    _updateKeywords: -> @_updateSelect2 'keywords'

    # Populate some of the dropdowns like language and subjects.
    # Also, initialize the select2 widget on elements
    onRender: ->
      # Populate the Language dropdown and Subjects checkboxes
      $languages = @$el.find('*[name=language]')
      for lang in LANGUAGES
        $lang = jQuery('<option></option>').attr('value', lang.code).text(lang.native)
        $languages.append($lang)

      $languages.select2
        placeholder: __('Select a language')

      $subjects = @$el.find('*[name=subjects]')
      $subjects.select2
        tags: METADATA_SUBJECTS
        tokenSeparators: [',']
        separator: '|' # String used to delimit ids in $('input').val()

      # Enable multiselect on certain elements
      $keywords = @$el.find('*[name=keywords]')
      $keywords.select2
        tags: @model.get('keywords') or []
        tokenSeparators: [',']
        separator: '|' # String used to delimit ids in $('input').val()
        ajax: SELECT2_AJAX_HANDLER(URLS.KEYWORDS)
        initSelection: (element, callback) ->
          data = []
          _.each element.val().split('|'), (str) -> data.push {id: str, text: str}
          callback(data)

      # Select the correct language (Handlebars can't do that)
      @_updateLanguage()
      @_updateSubjects()
      @_updateKeywords()

      @delegateEvents()

    # This is used by `DialogWrapper` which offers a "Save" and "Cancel" buttons
    attrsToSave: () ->
      language = @$el.find('*[name=language]').val()
      variant = @$el.find('*[name=variantLanguage]').val()
      language = variant or language
      # subjects could be the empty string in which case it would be set to `[""]`
      subjects = (kw for kw in @$el.find('*[name=subjects]').val().split('|'))
      subjects = [] if '' is subjects[0]
      # Keywords could be the empty string in which case it would be set to `[""]`
      keywords = (kw for kw in @$el.find('*[name=keywords]').val().split('|'))
      keywords = [] if '' is keywords[0]

      return {
        language: language
        subjects: subjects
        keywords: keywords
      }


  exports.RolesEditView = Marionette.ItemView.extend
    template: EDIT_ROLES

    onRender: ->
      $authors = @$el.find('*[name=authors]')
      $copyrightHolders = @$el.find('*[name=copyrightHolders]')

      $authors.select2
        # **FIXME:** The authors should be looked up instead of being arbitrary text
        tags: @model.get('authors') or []
        tokenSeparators: [',']
        separator: '|'
        #ajax: SELECT2_AJAX_HANDLER(URLS.USERS)
      $copyrightHolders.select2
        tags: @model.get('copyrightHolders') or []
        tokenSeparators: [',']
        separator: '|'
        #ajax: SELECT2_AJAX_HANDLER(URLS.USERS)

      SELECT2_MAKE_SORTABLE $authors
      SELECT2_MAKE_SORTABLE $copyrightHolders

      # Populate the multiselect widgets with data from the backbone model
      @_updateAuthors()
      @_updateCopyrightHolders()

      @delegateEvents()

    _updateAuthors: -> @$el.find('*[name=authors]').select2 'val', (@model.get('authors') or [])
    _updateCopyrightHolders: -> @$el.find('*[name=copyrightHolders]').select2 'val', (@model.get('copyrightHolders') or [])

    attrsToSave: () ->
      # Grab the authors from the multiselect input element.
      # They are separated with a `|` character defined when select2 was configured
      authors = (kw for kw in @$el.find('*[name=authors]').val().split('|'))
      copyrightHolders = (kw for kw in @$el.find('*[name=copyrightHolders]').val().split('|'))

      return {
        authors: authors
        copyrightHolders: copyrightHolders
      }



  # ## DialogWrapper
  # This class wraps a view in a div and only causes changes when
  # the 'Save' button is clicked.
  #
  # Looks like phil came to the same conclusion as the author of Marionette
  # (Don't make a Bootstrap Modal in a `Backbone.View`):
  # [http://lostechies.com/derickbailey/2012/04/17/managing-a-modal-dialog-with-backbone-and-marionette/]
  exports.DialogWrapper = Marionette.ItemView.extend
    template: DIALOG_WRAPPER
    onRender: ->
      @options.view.render()
      @$el.find('.dialog-body').append @options.view.$el

      # Fire a cancel event when the cancel button is pressed
      @$el.on 'click', '.cancel', => @trigger 'cancelled'

      # Trigger the `model.save` when the save button is clicked
      # using the attributes from `@options.view.attrsToSave()`
      @$el.on 'click', '.save', (evt) =>
        evt.preventDefault()
        attrs = @options.view.attrsToSave()

        @options.view.model.save attrs,
          success: (res) =>
            # Trigger a 'sync' because if 'success' is provided 'sync' is not triggered
            @options.view.model.trigger('sync')
            @trigger 'saved'

          error: (res) =>
            alert('Something went wrong when saving: ' + res)


  # ## Auth View
  # The top-right of each page should have either:
  #
  # 1. a Sign-up/Login link if not logged in
  # 2. a logoff link with the current user name if logged in
  #
  # This view updates when the login state changes
  exports.AuthView = Marionette.ItemView.extend
    template: SIGN_IN_OUT
    events:
      'click #sign-in': 'signIn'
      'submit #sign-out': 'signOut'
    onRender: ->
      @listenTo @model, 'change', => @render()
      @listenTo @model, 'change:userid', => @render()

    # Clicking on the link will redirect to the logoff page
    # Before it does, update the model
    signOut: -> @model.signOut()


  exports.WorkspaceView = exports.SearchResultView
  return exports
