# A handlebars helper that provides a way to
# recursively apply a template.
#
# Used for generating nested HTML lists.
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
