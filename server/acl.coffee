Meteor.publish "roles", ->
  if Gini.Permissions.allow "manage_perm", this.userId
    Gini.Collections.Roles.find()

Meteor.publish "userRoles", ->
  if Gini.Permissions.allow "manage_perm", @userId
    Gini.Collections.UserRoles.find()
  else
    Gini.Collections.UserRoles.find {id: @userId}

Meteor.publish "permissions", ->  Gini.Collections.Permissions.find()

Meteor.methods {
  'editPermission': (perm, role, isAllowed) ->
    if Gini.Permissions.allow 'manage_perm', Meteor.userId()
      if isAllowed
        Gini.Collections.Permissions.update { name: perm }, { $addToSet: roles: role }
      else
        Gini.Collections.Permissions.update { name: perm }, { $pull: roles: role }
    else
      new Meteor.Error 403, 'Forbidden'

  'addRole': (role) ->
    if Gini.Permissions.allow 'manage_perm', Meteor.userId()
      Gini.Collections.Roles.insert
        name: role.name
        description: role.description
    else
      new Meteor.Error 403, 'Forbidden'

  'addUserRole': (userId, role) ->
    if Gini.Collections.Roles.find({name: role}).count() is 0
      details = 'Role ' + role + ' does not exist. Create a new Role first'
      return new Meteor.Error 400, 'Invalid Role', details
    if Gini.Permissions.allow 'manage_perm', Meteor.userId()
      Gini.Collections.UserRoles.update {id: userId}, { $addToSet: roles: role }
    else
      new Meteor.Error 403, 'Forbidden'

  'deleteUserRole': (userId, role) ->
    if Gini.Permissions.allow 'manage_perm', Meteor.userId()
      Gini.Collections.UserRoles.update {id: userId}, { $pull: roles: role }
    else
      new Meteor.Error 403, 'Forbidden'
}
# Server Method: Can only be called by direct invocation i.e. by modules
Gini.Permissions.addPermission = (name, module, roles=[]) ->
  if Gini.Collections.Permissions.find({name: name}).count() is 0
    roles = [roles] if not _.isArray roles
    Gini.Collections.Permissions.insert {
      name: name
      module: module
      roles: roles
    }

Gini.Permissions.addRoles = (userId, role) ->
  if Gini.Collections.UserRoles.find({id: userId}).count() is 0
    roles = if role then [role] else []
    console.log "ROLES"
    console.log roles
    Gini.Collections.UserRoles.insert { id: userId, roles: roles }
  else if role?
    Gini.Collections.UserRoles.update { id: userId }, {$addToSet: roles: role}

init = ->
  Gini.Collections.Permissions._ensureIndex 'name', unique: 1
  Gini.Collections.Roles._ensureIndex 'name', unique: 1
  Gini.Collections.UserRoles._ensureIndex 'id', unique: 1

  defaultRoles = [{
      name: "Admin"
      description: "Perform administrative task."
    },
    {
      name: "Author"
      description: "Content Writer/Reviewer"
    },
    {
      name: "Anonymous"
      description: "Anonymous or Not logged-in"
    }]
  if Gini.Collections.Roles.find().count() is 0
    for role in defaultRoles
      Gini.Collections.Roles.insert role
  if Gini.Collections.Permissions.find({name: "manage_perm"}).count() is 0
    Gini.Permissions.addPermission "manage_perm", "core", ["Admin"]

Meteor.startup init

Meteor.users.find().observe {
  added: (user) ->
    if Meteor.users.find().count() is 1
      Gini.Permissions.addRoles user._id, "Admin"
    else
      Gini.Permissions.addRoles user._id
  }