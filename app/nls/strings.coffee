# # i18n Strings
#
# Contains internationalized strings that do not already occur in handlebars templates
# (the handlebars plugin already has a way of loading internationalized templates)
#
# These can be organized into separate files if they become too large or make
# more sense separately.
# See [requirejs i18n](http://requirejs.org/docs/api.html#i18n) for more.
#
# I extended the original `i18n` plugin to return a function that can be used to
# look up a string and return the original string if none is found hopefully
# making it easier to internationalize.
# (all strings should be wrapped with that function)
#
# ## Example Use:
#     define ['jquery', ..., 'i18n!app/nls/strings'], ($, ..., __) ->
#       alert __('Hello World')
define 'root':
  'gray': 'grey'
  'blue': 'azul'
  'green': 'verde'
  # Different language files are stored in a separate `.js` file
  # You can define regional variants as well and these will be
  # assembled based on the language set by the browser.
  'fr': false
  'en-ca': false
