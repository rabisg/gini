Meteor.publish "userData", ->
  Meteor.users.find {}, {fields: 'emails': 1, 'profile': 1}