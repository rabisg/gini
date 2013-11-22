Template['content-home'].events {
  'click .nextsection': (event) ->
    $this = $(event.currentTarget)
    $gparent = $this.parent().parent()
    $next = $gparent.next()
    targetOffset = $next.offset().top
    $('html,body').animate {scrollTop: targetOffset}, 300, 'linear'
}

Template['content-home'].helpers
 author: (userId)->
    author = Meteor.users.findOne {_id: userId}
    if author.profile?
      author.profile.firstName + " " + author.profile.lastName
    else
      author.emails[0].address