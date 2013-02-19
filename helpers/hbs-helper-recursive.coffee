# A handlebars helper that provides the index `i` and 1-based index `iPlus1`
# when iterating over an array.
define 'template/helpers/recursive', ['underscore', 'handlebars'], (_, Handlebars) ->
  fn = null
  recursive = (children, options) ->

    fn = options.fn if options.fn
    ret = ''

    _.each children, (child) ->
      ret += fn(child)
    return ret


  Handlebars.registerHelper 'recursive', recursive
  return recursive
