Gini.Page "/profile", {
  layout: "2-col-HF"
  template: "profile"
  data: -> Meteor.user()
  blocks: sidebar: "admin-sidebar"
}
