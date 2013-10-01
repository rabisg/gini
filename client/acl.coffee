Meteor.startup ->
  Meteor.subscribe "roles"
  Meteor.subscribe "userRoles"
  Meteor.subscribe "permissions"

Handlebars.registerHelper 'perm', (permission, userid) -> Gini.Permissions.allow permission, Meteor.userId()
