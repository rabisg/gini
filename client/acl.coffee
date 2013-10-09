Deps.autorun () ->
  roles = Meteor.call "myRoles", Meteor.userId()
  Session.set "roles", roles.roles