'''
Permissions =
  name  : name
  module: module
  roles : [role]

Roles =
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
  allowedRoles = Gini.Collections.Permissions.findOne({name: permission}, {fields: {roles: 1}})
  roles = Gini.Collections.UserRoles.findOne({id: userId}, {fields: {roles: 1}})
  if not allowedRoles
    return false
  if "anon" in allowedRoles.roles or (roles? and _.intersection roles.roles, allowedRoles.roles isnt [])
    return true
  return false
