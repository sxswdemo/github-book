# Directory Layout

* `app/`
* `app/models.coffee`
* `app/views.coffee`
* `app/templates.coffee` HTML Templates
* `app/nls/*.coffee`     i18n strings (and HTML) http://requirejs.org/docs/api.html#i18n
* `lib/`                 3rd party libraries

* `app.coffee`   The starting point for all javascript
* `app.less`     Includes all other css files (including external libs) so we can minify
* `require.config.coffee` Includes paths to 3rd party libs so we can minify them

# Adding a 3rd party library

1. Unzip it into `./lib/`.
2. If it is just a single file include it with its license file (prefix the license file with the name of the library)
3. Feel free to exclude directories or files that aren't needed (tests, docs, examples)
4. Add the lib to `require.config.coffee` (both in `path` and `shim`)
    * The name should be all lowercase
    * Use a `-` if the library name is more than one word
    * Don't use `/` or `.`

5. Use it in your module by adding it to the dependencies in `define`
