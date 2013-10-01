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

Gini.Page = (path, options) ->
  Router.map () ->
    @route options.layout, {

      path: path
      loadingTemplate: 'loading'

      data: () ->
        blocks = {}
        options.blocks ?= {}
        for region, block of options.blocks
          if _.isString block
            blocks[region] = Template[block]()
          else
            if _.isObject block
              block.data ?= {}
              _data = if _.isFunction block.data then block.data(@params) else block.data
              if block.template?
                blocks[region] = Template[block.template](_data)
              else
                console.error "Gini.Page: Template not defined for block: " + region
                console.error options.blocks
            else
              console.error "Gini.Page: blocks[" + region + "] is not a string or obj"
              console.error options.blocks
        return blocks
    }