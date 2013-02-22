require.onError = (err) -> console.error err

ALOHA_PATH = '../Aloha-Editor'

# Configure paths to all the JS libs
require.config

  # # Configure Library Locations
  paths:
    aloha: ALOHA_PATH + '/src/lib/aloha'

    'template/helpers/identstring': 'epub/hbs-helper-identstring'
