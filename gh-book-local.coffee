# This file acts as a mock store so a connection to github is not necessary
# Useful for local development
require ['gh-book/app', 'gh-book/store'], (Store) ->

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

  window.FILES = {}
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
          <li><a href="#{CH1_PATH}">Background Information</a></li>
          <li><a href="#{CH2_PATH}">Introduction to gh-book</a></li>
          <li>
            <span>Chapter 1</span>
            <ol>
              <li><a href="section.html">Section 1</a></li>
            </ol>
          </li>
        </ol>
      </nav>
      """
  FILES[CH1_PATH] = '<h1>Background</h1>'
  FILES[CH2_PATH] = '<h1>Introduction</h1>'
  FILES['background.json'] = JSON.stringify {title: 'Background Module Title'}

  _pushFile = (path, text, commitText, cb) ->
    console.log "Saving #{path}"
    FILES[path] = text
    cb(null)

  _pullFile = (path, cb) ->
    if path of FILES
      console.log "Loading #{path}"
      cb null, FILES[path]
    else
      console.log "LOAD PROBLEM: COULD NOT FIND #{path}"
      cb 'COULD_NOT_FIND_FILE'

  _pullDir = (path, cb) ->
    # TODO: filter using path
    dirFiles = ({name: name} for name in Object.keys(FILES))
    cb null, dirFiles

  # Wrap each of the operations with a delay function to simulate network latency
  wrap = (fn) ->
    return () ->
      args = arguments # squirrel away the args to be ued 2 lines later
      fn.apply Store, args if 0 == CALLBACK_DELAY
      setTimeout (-> fn.apply Store, args), CALLBACK_DELAY if CALLBACK_DELAY

  Store._pushFile = wrap _pushFile
  Store._pullFile = wrap _pullFile
  Store._pullDir  = wrap _pullDir
