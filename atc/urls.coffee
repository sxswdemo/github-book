# This module contains URLS to communicate with the webserver
define [], ->
  return {
    # Used by the [`auth`](auth.html) module
    ME: '/me'
    # Used by the [`models`](models.html) module
    CONTENT_PREFIX: '/content/'
    WORKSPACE: '/workspace/'
    # Used by the [`views`](views.html) module
    KEYWORDS: '/keywords/'
    USERS: '/users/'
  }
