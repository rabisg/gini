Gini.Page "/admin", {
  layout: "2-col-HF"
  template: "admin-home"
  data: ->
    if not Meteor.userId()
      return null
    {}
  blocks: sidebar: "admin-sidebar"
}
Gini.Page "/admin/manage/permissions", {
  layout: "2-col-HF"
  template: "manage-perm"
  data: ->
    if not Gini.Permissions.allow "manage_perm", Meteor.userId()
      return null
    {
      roles: Gini.Collections.Roles.find {}, {}
      permissions: Gini.Collections.Permissions.find {}, {}
    }
  waitOn: -> [
    Meteor.subscribe 'roles'
    Meteor.subscribe 'permissions'
  ]
  blocks: sidebar: "admin-sidebar"
}

Gini.Page "/admin/manage/roles", {
  layout: "2-col-HF"
  template: "manage-role"
  data: ->
    if not Gini.Permissions.allow "manage_perm", Meteor.userId()
      return null
    {
      roles: Gini.Collections.Roles.find {}, {}
      userRoles: Gini.Collections.UserRoles.find {}, {}
    }
  waitOn: -> [
    Meteor.subscribe 'roles'
    Meteor.subscribe 'userRoles'
  ]
  blocks: sidebar: "admin-sidebar"
}
