#  A ISO639-1 language code library used in forms to select a language and
#  a possible variant language.
#
#  Copyright (c) 2012, Rice University. Original copyright not found.
#
#  This piece of code is derived from the Products.PloneLanguageTool
#  Python package. This software is subject to the provisions of
#  the GNU Lesser General Public License (GPL).
#  The original authors of this software are:
#  Jodok Batlogg, Simon Eisenmann, Geir Baekholt,
#  Alexander Limi, Helge Tesdal, Dorneles Tremea, Hanno Schlichting
define [
  'json!./languages/countries.json'
  'json!./languages/languages.json'
  'json!./languages/variants.json'
], (COUNTRIES, LANGUAGES, VARIANTS) ->

  return {
    # Get all countries
    getCountries: -> COUNTRIES
    # Get all languages
    getLanguages: -> LANGUAGES
    # Get all combined languages
    getCombined: -> VARIANTS

    # Get all native language names
    getNativeLanguageNames: ->
      native_languages = {}
      for lang_code, info of LANGUAGES
        native_languages[lang_code] = info['native']
      return native_languages

    # Get all combined language names
    getCombinedLanguageNames: ->
      combined_languages = {}
      for lang_code, info of COMBINED
        combined_languages[lang_code] = info['english']
      return combined_languages
  }
