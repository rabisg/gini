@Roles = new Meteor.Collection("Roles")
Meteor.publish("roles", ->
  if Gini.allow this.userId, "manage_role"
    Roles.find()
)

@UserRoles = new Meteor.Collection("UserRoles")
Meteor.publish("myRoles", -> UserRoles.find({id: this.userId}))

@Permissions = new Meteor.Collection("Permissions")
Meteor.publish("permissions", -> Permissions.find())

Gini.Module.register_perm = (name, module, roles=[]) ->
  if Permissions.find({name: name}).count() is 0
    roles = [roles] if roles isnt _.isArray roles
    Permissions.insert {
      name: name
      module: module
      roles: roles
    }

Gini.allow = (userId, permission) ->
  allowedRoles = Permissions.findOne({name: permission}, {fields: "roles"})
  roles = UserRoles.findOne({id: userId}, {fields: "roles"})
  if _.intersection roles.roles, allowedRoles.roles isnt []
    return true
  return false

init = ->
  if Roles.find().count() is 0
    Roles.insert [{
      name: "admin"
      description: "Perform administrative task."
    },
    {
      name: "author"
      description: "Content Writer/Reviewer"
    }]
  if Permissions.find({name: "manage_roles"}).count() is 0
    Gini.Module.register_perm "manage_role", "core", ["admin"]

Gini.startup init