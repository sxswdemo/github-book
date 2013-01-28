# Provides a simple HTML page with buttons to open the edit modals.
#
# We need to define a name `Sandbox` for this module
# (which matches the requirejs data-main attribute)
define 'Sandbox', [
  'jquery'
  'app/models'
  'app/views'
  'test/routes'
  'css!app'
], ($, Models, Views, MOCK_CONTENT) =>
  model = new Models.Content()
  model.set MOCK_CONTENT
  metadataView = new Views.MetadataEditView {model: model}
  rolesView    = new Views.RolesEditView {model: model}

  metadataModal = new Views.ModalWrapper(metadataView, 'Edit Metadata (test)')
  rolesModal    = new Views.ModalWrapper(rolesView, 'Edit Roles (test)')

  # Log when model changes are saved (not changed)
  model.on 'sync', ->
    console.log 'Model Saved!', @
    alert "Model Saved!\n#{JSON.stringify(@)}"

  $('.show-metadata').on 'click', => metadataModal.show()
  $('.show-roles'   ).on 'click', => rolesModal.show()
