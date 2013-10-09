'''
Permissions =
  name  : name
  module: module
  roles : roles

Roles.insert =
  name: name
  description: A long description

UserRoles =
  userId: userId
  roles : [role]
'''
Gini.Collections.Roles        = new Meteor.Collection "Roles"
Gini.Collections.UserRoles    = new Meteor.Collection "UserRoles"
Gini.Collections.Permissions  = new Meteor.Collection "Permissions"

Gini.Permissions = {}
Gini.Permissions.allow = (permission, userId) ->
  allowedRoles = Gini.Collections.Permissions.findOne({name: permission}, {fields: "roles"})
  roles = Gini.Collections.UserRoles.findOne({id: userId}, {fields: "roles"})
  if _.intersection roles.roles, allowedRoles.roles isnt []
    return true
  return false
