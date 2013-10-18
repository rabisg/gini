Template['view-content'].events {
  'click #edit-content': (event) ->
    if Session.get('editing') is false
      Template['view-content'].editMode()
    else
      Template['view-content'].saveContent this
      Template['view-content'].normalMode()

  'click .blog-image-edit': (event) ->
    $this = $(event.currentTarget)
    $this.toggleClass "cover", 5000
    $("#URLcontainer").toggleClass("hidden",500)

  'click #delete-content': (event) ->
    Meteor.call 'deleteContent', this, (error, result) ->
      unless error
        Router.go '/'

  'click #edit-image': (event) ->
    new_src = $('#edit-image-url').val()
    $('#blog-image').attr 'src', new_src
}

Template['view-content'].saveContent = (template) ->
  content =
    slug: template.slug
    title: $('#blog-title').text()
    content: $('#blog-content').html()
    image: $('#blog-image').attr('src')
  Meteor.call 'editContent', content

Template['view-content'].editMode = ->
  $('#edit-status').text 'Done Editing'
  $('#blog-image').addClass 'blog-image-edit'
  $("#blog-title").attr 'contenteditable', 'true'
  window.editor = new Pen('#blog-content')
  Session.set 'editing', true

Template['view-content'].normalMode = ->
  $('#edit-status').text 'Edit'
  $('#blog-image').removeClass 'blog-image-edit'
  $('#blog-image').removeClass 'cover'
  $("#URLcontainer").addClass "hidden"
  $("#blog-title").attr 'contenteditable', 'false'
  window.editor.destroy()
  $("#blog-content").removeClass 'pen'
  Session.set 'editing', false

Template['view-content'].rendered = -> Session.set 'editing', false