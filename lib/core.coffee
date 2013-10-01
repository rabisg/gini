@Gini = {}
_.extend Gini, Meteor

Gini.hooks = {} if not Gini.hooks

Gini.hook = (hook, f) ->
  Gini.hooks[hook] = [] if not Gini.hooks[hook]
  Gini.hooks[hook].push f
  return

Gini.callHook = (hook, args...) ->
  for f in Gini.hooks[hook]
    f args...
  args

Gini.Module = {}

types = ["field-view", "field-edit-view", "block-view", "layout"]
Gini.Module.registered = {}
Gini.Module.registered[type] = {} for type in types

Gini.Module.register = (obj) ->
  for type, val of obj
    Gini.Module.registered[type][val.id] = callback

Gini.Module.register = (type, name, callback) ->
  Gini.Module.register  type:
                          "id": name
                          "callback": callback