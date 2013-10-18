'''
Content =
  slug  : name
  title: title
  image: image-url
  content: content
  added: timestamp
  addedBy: userId
  modified: timestamp
  modifiedBy: userId
'''

Gini.Collections.Content = new Meteor.Collection "Content"

Meteor.methods {
  "addContent": (content) ->
    content.added = content.modified = new Date()
    content.addedBy = content.modifiedBy = @userId
    if Gini.Permissions.allow "add_content", @userId
      try
        Gini.Collections.Content.insert content
      catch error
        throw new Meteor.Error 409, "Conflict", "Slug already exists" #TODO: Does not Work. Y?
    else throw new Meteor.Error 401, "Unauthorized"
    return

  "editContent": (content) ->
    modifiedBy = @userId
    if Gini.Permissions.allow "edit_content", @userId
      Gini.Collections.Content.update { slug: content.slug }, {$set: {title: content.title, image: content.image, content: content.content, modified: new Date(), modifiedBy: modifiedBy}}
    else throw new Meteor.Error 401, "Unauthorized"
    return

  "deleteContent": (content) ->
    modifiedBy = @userId
    if Gini.Permissions.allow "edit_content", @userId
      Gini.Collections.Content.remove content._id
    else throw new Meteor.Error 401, "Unauthorized"
    return
  }

Gini.startup = ->
  if Meteor.isServer
    Gini.Collections.Content._ensureIndex 'slug', unique: 1
    Gini.Permissions.addPermission "view_content", "core", ["anon"]
    Gini.Permissions.addPermission  "add_content", "core", ["admin", "author"]
    Gini.Permissions.addPermission "edit_content", "core", ["admin", "author"]
    Meteor.publish "content", (slug) -> Gini.Collections.Content.find {slug: slug}
    Meteor.publish "latestContent", -> Gini.Collections.Content.find {}, { sort: [["added", "desc"]], limit: 5 }