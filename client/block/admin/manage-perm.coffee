Template['manage-perm'].events {
  'click input[type=checkbox]': (event) ->
    e = $(event.currentTarget)
    Meteor.call 'editPermission', e.attr('data-perm'), e.attr('data-role'), e.is(':checked')
}