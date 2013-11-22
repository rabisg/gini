Template['manage-role'].events {
  "click #create-role-btn": (event) ->
    Meteor.call 'addRole',
      name: $("#roleName").val()
      description: $("#roleDescription").val(),
      (err, res) ->
        if err
          console.error err
        else
          $("#roleName").val('')
          $("#roleDescription").val('')

  "keypress .addRole": (event) ->
    $elem = $(event.currentTarget)
    if event.keyCode is 13
      Meteor.call 'addUserRole', $elem.attr('data-user'), $elem.val(),
      (err, res) ->
        if res.error
          console.log res.details
        else
          $elem.val('')

  "click .delRole": (event) ->
    $elem = $(event.currentTarget)
    console.log $elem
    Meteor.call 'deleteUserRole', $elem.attr('data-user'), $elem.attr('data-role')
}

Template['manage-role'].helpers
 email: (userId)->
    user = Meteor.users.findOne {_id: userId}
    user.emails[0].address