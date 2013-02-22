# # Application Root
# This is the start of the application. Steps:
#
# 1. Load dependencies (JS/CSS/JSON)
# 2. Register client-side routes
#
# **TODO:** Load any HTML/JSON sent from the server that is sprinkled in the HTML file.
#
# For example, if the user goes to a piece of content we already send
# the content inside a `div` tag.
# The same can be done with metadata/roles (as a JSON object sent in the HTML)
define [ 'atc', 'epub/models' ], (Atc, Models) ->

  # # Application Code

  # Change how the workspace is loaded (from `META-INF/content.xml`)
  #
  # `EPUB_CONTAINER` will fill in the workspace just by requesting files
  Models.EPUB_CONTAINER.deferred ->
    console.log 'Workspace loaded!'

    # Begin listening to route changes
    # and load the initial views based on the URL.
    Atc.start()
