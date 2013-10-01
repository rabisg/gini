Meteor.publish "roles", ->
  if Gini.Permissions.allow "manage_perm", this.userId
    Gini.Collections.Roles.find()

Meteor.publish "userRoles", (id) ->
  if Gini.Permissions.allow "manage_perm", @userId and id?
    UserRoles.find {id: id}

Meteor.publish "permissions", ->  Permissions.find()
Meteor.methods "myRoles", -> UserRoles.find {id: this.userId}, {fields: "roles"}

# Server Method: Can only be called by direct invocation i.e. by modules
Gini.Permissions.addPermission = (name, module, roles=[]) ->
  if Gini.Collections.Permissions.find({name: name}).count() is 0
    roles = [roles] if roles isnt _.isArray roles
    Gini.Collections.Permissions.insert {
      name: name
      module: module
      roles: roles
    }

init = ->
  if Gini.Collections.Roles.find().count() is 0
    Roles.insert [{
      name: "admin"
      description: "Perform administrative task."
    },
    {
      name: "author"
      description: "Content Writer/Reviewer"
    }]
  if Gini.Collections.Permissions.find({name: "manage_perm"}).count() is 0
    Gini.Permissions.addPermission "manage_perm", "core", ["admin"]

Gini.startup init