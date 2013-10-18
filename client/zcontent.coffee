Gini.Page "/", {
  layout: "1-col-HF"
  template: "content-home"
  data: ->
    if not Gini.Permissions.allow "view_content", Meteor.userId()
      return null
    contents: Gini.Collections.Content.find {}, { sort: [["added", "desc"]], limit: 5 }
  waitOn: -> Meteor.subscribe 'latestContent'
}
Gini.Page "/content", {
  layout: "1-col-HF"
  template: "add-content"
  data: ->
    if not Gini.Permissions.allow "add_content", Meteor.userId()
      return null
    return {}
}
Gini.Page "/content/:slug", {
  layout: "1-col-HF"
  template: "view-content"
  data: ->
    if not Gini.Permissions.allow "view_content", Meteor.userId()
      return null
    Gini.Collections.Content.findOne {slug: @params.slug}
  waitOn: (params) -> Meteor.subscribe 'content', params.slug
}