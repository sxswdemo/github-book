  # Helper that makes a valid id-attribute
define 'template/helpers/identstring', ['handlebars'], (Handlebars) ->
  fn = (str) ->
    # Replace a slash with a dash
    str = str.replace /\//g, '-'
    str = str.replace /\./g, '-'
    return 'id-' + str

  Handlebars.registerHelper 'identstring', fn
  return fn
