Meteor.startup ->
  Meteor.subscribe "roles"
  Meteor.subscribe "userRoles"
  Meteor.subscribe "permissions"

Handlebars.registerHelper 'perm', (permission) -> Gini.Permissions.allow permission, Meteor.userId()