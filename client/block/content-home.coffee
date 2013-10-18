Template['content-home'].events {
  'click .nextsection': (event) ->
    $this = $(event.currentTarget)
    $gparent = $this.parent().parent()
    $next = $gparent.next()
    targetOffset = $next.offset().top
    $('html,body').animate {scrollTop: targetOffset}, 300, 'linear'
}