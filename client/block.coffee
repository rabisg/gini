Gini.Defaults.blocks =
  'default-header': to: 'header'
  'default-footer': to: 'footer'

Handlebars.registerHelper 'blockDefault', (blockName, block) ->
  block = if not block? and Gini.Defaults.blocks[blockName]? then Template[Gini.Defaults.blocks[blockName]]() else block