define [ 'jquery', 'backbone', 'atc/controller', 'atc/models', 'epub/models', 'css!atc' ], (jQuery, Backbone, AtcController, AtcModels, Models) ->

  # # Application Code

  # path-to-text Repository
  window.FILES = FILES = {}


  # Replace `Backbone.sync()` with one that reads and writes to memory
  Backbone.sync = (method, model, options) ->
    deferred = jQuery.Deferred()

    # handle Syncing Backbone.Model (id and URL) and Backbone.Collection (no id, just a URL) elements
    path = model.id or model.url?() or model.url

    if method == 'update'
      text = model.serialize()
      FILES[path] = text

      # Fire off the callback
      options?.success?(model, 'SUCCESSFULLY_SAVED_IN_MEMORY', options)
      deferred.resolve(model)
    if method == 'read'
      if path of FILES
        text = FILES[path]
        options?.success?(model, text, options)
        deferred.resolve(model)
      else
        options?.error?("PATH NOT FOUND: '#{path}'")
        deferred.reject("PATH NOT FOUND: '#{path}'")

    return deferred.promise()

  # Populate with some test data

  # The number of milliseconds before calling a callback
  # If set to 0 then the callback will be called immediately

  # Setting a delay simulates network latency while 0 delay simulates loading the content on page load
  CALLBACK_DELAY = 0

  OPF_ID = '12345'
  OPF_TITLE = 'Github EPUB Editor'
  OPF_LANGUAGE = 'en'

  OPF_PATH = 'book.opf'
  NAV_PATH = 'navigation.html'
  CH1_PATH = 'background.html'
  CH2_PATH = 'introduction.html'

  CH1_ID = 'id-1-background'
  CH2_ID = 'id-2-intro'

  FILES['META-INF/container.xml'] = """
        <?xml version='1.0' encoding='UTF-8'?>
        <container xmlns="urn:oasis:names:tc:opendocument:xmlns:container" version="1.0">
         <rootfiles>
            <rootfile full-path="#{OPF_PATH}" media-type="application/oebps-package+xml"/>
         </rootfiles>
        </container>
    """
  FILES[OPF_PATH] = """
        <?xml version="1.0"?>
        <package version="3.0"
                 xml:lang="en"
                 xmlns="http://www.idpf.org/2007/opf"
                 unique-identifier="pub-id">
            <metadata xmlns:dc="http://purl.org/dc/elements/1.1/">
                <dc:identifier
                      id="pub-id">#{OPF_ID}</dc:identifier>
                <meta refines="#pub-id"
                      property="identifier-type"
                      scheme="xsd:string">uuid</meta>

                <dc:language>#{OPF_LANGUAGE}</dc:language>
                <dc:title>#{OPF_TITLE}</dc:title>

            </metadata>

            <manifest>
                <item id="id-navigation"
                      properties="nav"
                      href="#{NAV_PATH}"
                      media-type="application/xhtml+xml"/>
                <item id="#{CH2_ID}"
                      href="#{CH2_PATH}"
                      media-type="application/xhtml+xml"/>
                <item id="#{CH1_ID}"
                      href="#{CH1_PATH}"
                      media-type="application/xhtml+xml"/>
            </manifest>
            <spine>
                <itemref idref="#{CH1_ID}"/>
                <itemref idref="#{CH2_ID}"/>
            </spine>
        </package>
        """
  FILES[NAV_PATH] = """
      <p>Example Navigation</p>
      <nav>
        <ol>
          <li><a href="#{CH1_PATH}">#{CH1_ID}</a></li>
          <li><a href="#{CH2_PATH}">#{CH2_ID}</a></li>
        </ol>
      </nav>
      """
  FILES[CH1_PATH] = '<h1>Background</h1>'
  FILES[CH2_PATH] = '<h1>Introduction</h1>'
  FILES['background.json'] = JSON.stringify {title: 'Background Module Title'}




  # Change how the workspace is loaded (from `META-INF/content.xml`)
  #
  # `EPUB_CONTAINER` will fill in the workspace just by requesting files
  Models.EPUB_CONTAINER.loaded().then ->
    console.log 'Workspace loaded!'


    AtcModels.SearchResults = AtcModels.SearchResults.extend
      initialize: ->
        for model in AtcModels.ALL_CONTENT.models
          if model.get('mediaType') != 'text/x-module'
            @add model, {at: 0}
          else
            @add model

    # Set the loaded flag so we don't try and populate them from the server
    #AtcModels.ALL_CONTENT.each (model) -> model.loaded(true)

    # Begin listening to route changes
    # and load the initial views based on the URL.
    AtcController.start()
