'''
options =
  layout: "layout"
  blocks: header: "header"
          footer: "footer"
          content:
            template: "showPost"
            data:     header_data | header_data()

Gini.Page "/posts/:_id", options
'''
Router.configure {
  notFoundTemplate: '404'
  loadingTemplate: 'loading'
  layout: '1-col-HF'
}

Gini.Page = (path, options) ->
  Router.map () ->
    @route options.template, {
      layout: options.layout
      path: path
      data: options.data
      waitOn: ->
        waitFor = [Meteor.subscribe("permissions"), Meteor.subscribe("userRoles")]
        if options.waitOn?
          _.union waitFor, options.waitOn(@params)
        else waitFor

      renderTemplates: getSubTemplates options.blocks
    }

getSubTemplates = (blocks) ->
  # Add the defaults first
  retval = Gini.Defaults.blocks

  for region, block of blocks
    if _.isString block
      retval[block] = to: region
    else
      if _.isObject block
        block.data ?= {}
        _data = if _.isFunction block.data then block.data() else block.data
        if block.template?
          retval[block.template] = to: region, data: _data, waitOn: block.waitOn
        else
          console.error "Gini.Page: Template not defined for block: " + region
          console.error options.blocks
      else
        console.error "Gini.Page: blocks[" + region + "] is not a string or obj"
        console.error options.blocks
  retval