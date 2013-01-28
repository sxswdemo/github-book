# Configure paths to all the JS libs
require.config

  # Since `master.html` is served from `/` we need to set the base to the static dir
  # This should probably become `/static/`
  baseUrl: 'static/'
  urlArgs: '' # If you want to force a reload every time use this: `cb=#{Math.random()}` (you lose JS breakpoints though)

  # # Configure Library Locations
  paths:
    # ## Requirejs plugins
    i18n: 'i18n-custom'
    text: 'lib/require-text/text'
    json: 'lib/requirejs-plugins/json'
    hbs: 'lib/require-handlebars-plugin/hbs'

    # ## Core Libraries
    jquery: 'lib/jquery-1.8.3'
    underscore: 'lib/underscore-1.4.3'
    backbone: 'lib/backbone-0.9.9'
    # Layout manager for backbone
    marionette: 'lib/backbone.marionette'

    # ## UI libraries
    # **FIXME:** Replace `../cdn/` with `lib/` when aloha is moved into `static/`
    aloha: '../cdn/aloha/src/lib/aloha'
    bootstrap: 'lib/bootstrap/js/bootstrap'
    select2: 'lib/select2/select2'
    spin: 'lib/spin'

    # ## Handlebars modules
    # The requirejs plugin to support handlebars has several dependencies
    # that need to be loaded
    handlebars: 'lib/require-handlebars-plugin/Handlebars'
    i18nprecompile: 'lib/require-handlebars-plugin/hbs/i18nprecompile'
    json2: 'lib/require-handlebars-plugin/hbs/json2'

    'font-awesome': 'lib/font-awesome/css/font-awesome'

  # # Shims
  # To support libraries that were not written for AMD
  # configure a shim around them that mimics a `define` call.
  #
  # List the dependencies and what global object is available
  # when the library is done loading (for jQuery plugins this can be `jQuery`)
  shim:

    # ## Core Libraries
    jquery:
      exports: 'jQuery'
      init: -> # this.jQuery.noConflict(true)

    underscore:
      exports: '_'

    backbone:
      deps: ['underscore', 'jquery']
      exports: 'Backbone'

    marionette:
      deps: ['underscore', 'backbone']
      exports: 'Backbone'
      # Since `marionette` is the last library that depends on a
      # global `Backbone` object we can delete it from the globals.
      #
      # We can also delete `_` at this point and can delete `Backbone.Marionette`
      # so we never always include `marionette` and never assume Marionette is already loaded as a dependency.
      #    init: -> ret = @Backbone.Marionette; delete @Backbone.Marionette; delete @Backbone; delete @_; ret
      init: -> ret = @Backbone.Marionette; delete @Backbone.Marionette; delete @Backbone; ret

    # ## UI Libraries
    bootstrap:
      deps: ['jquery', 'css!lib/bootstrap/css/bootstrap']
      exports: 'jQuery'

    select2:
      deps: ['jquery', 'css!./select2']
      exports: 'Select2'
      init: -> ret = @Select2; delete @Select2; ret

    # Some of the Aloha plugins depend on bootstrap being initialized on jQuery
    # (like the popover plugin).
    #
    # Also, configure Aloha for the application using the `aloha-config` module.
    aloha:
      deps: ['bootstrap', 'aloha-config', 'css!../cdn/aloha/src/css/aloha']
      exports: 'Aloha'

  # Maps prefixes (like `less!path/to/less-file`) to use the LESS CSS plugin
  map:
    '*':
      text: 'lib/require-text'
      css: 'lib/require-css/css'
      less: 'lib/require-less/less'
      json: 'lib/requirejs-plugins/src/json'

  # ## Module and requirejs Plugin Configuration
  # This configures `requirejs` plugins (like `'hbs!...'`) and our modules (like `'app/views'`).
  #
  # Modules can get to the configuration by including the `module` dependency
  # and then calling `module.config()`
  hbs:
    disableI18n: true

# requirejs special-cases jQuery and allows it to be a global (doesn't call the init code below to clean up the global vars)
# To stop it from doing that, we need to delete this property
#
# unlike the other jQuery plugins bootstrap depends on a global '$' instead of 'jQuery'
#
#`delete define.amd.jQuery`
