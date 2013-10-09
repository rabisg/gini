Gini.Defaults.blocks =
  header: "default-header"
  footer: "default-footer"

Handlebars.registerHelper 'blockDefault', (blockName, block) ->
  block = if not block? and Gini.Defaults.blocks[blockName]? then Template[Gini.Defaults.blocks[blockName]]() else block