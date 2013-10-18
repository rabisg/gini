Meteor.publish "roles", ->
  if Gini.Permissions.allow "manage_perm", this.userId
    Gini.Collections.Roles.find()

Meteor.publish "userRoles", () ->
  if Gini.Permissions.allow "manage_perm", @userId
    Gini.Collections.UserRoles.find()
  else
    Gini.Collections.UserRoles.find {id: @userId}

Meteor.publish "permissions", ->  Gini.Collections.Permissions.find()

# Server Method: Can only be called by direct invocation i.e. by modules
Gini.Permissions.addPermission = (name, module, roles=[]) ->
  if Gini.Collections.Permissions.find({name: name}).count() is 0
    roles = [roles] if not _.isArray roles
    Gini.Collections.Permissions.insert {
      name: name
      module: module
      roles: roles
    }

Gini.Permissions.addRole = (userId, role) ->
  if Gini.Collections.UserRoles.find({id: userId}).count() is 0
    Gini.Collections.UserRoles.insert { id: userId, roles: [role] }
  else
    Gini.Collections.UserRoles.update { id: userId }, {$push: roles: role}

init = ->
  Gini.Collections.Permissions._ensureIndex 'name', unique: 1
  Gini.Collections.Roles._ensureIndex 'name', unique: 1
  Gini.Collections.UserRoles._ensureIndex 'userId', unique: 1

  if Gini.Collections.Roles.find().count() is 0
    Gini.Collections.Roles.insert [{
      name: "admin"
      description: "Perform administrative task."
    },
    {
      name: "author"
      description: "Content Writer/Reviewer"
    },
    {
      name: "anon"
      description: "Anonymous or Not logged-in"
    }]
  if Gini.Collections.Permissions.find({name: "manage_perm"}).count() is 0
    Gini.Permissions.addPermission "manage_perm", "core", ["admin"]

Gini.startup init

Meteor.users.find().observe {
  added: (user) ->
    if Meteor.users.find().count() is 1
      Gini.Permissions.addRole user._id, "admin"
  }