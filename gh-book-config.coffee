# Configures modules specific to talking to a github repository
require.config

  # # Configure Library Locations
  paths:

    # Point to our version of Aloha
    aloha: 'http://wysiwhat.github.com/Aloha-Editor/src/lib/aloha'

    # Change the Stub Auth piece
    'atc/auth': 'gh-book/auth'

    # Github-Specific libraries
    base64: 'lib/github/lib/base64'
    github: 'lib/github/github'

    angular: 'https://ajax.googleapis.com/ajax/libs/angularjs/1.0.1/angular'


  # # Shims
  # To support libraries that were not written for AMD
  # configure a shim around them that mimics a `define` call.
  #
  # List the dependencies and what global object is available
  # when the library is done loading (for jQuery plugins this can be `jQuery`)
  shim:

    # ## Github-Specific libraries
    github:
      deps: ['underscore', 'base64', 'angular']
      exports: 'Github'
