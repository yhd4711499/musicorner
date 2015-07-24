Meteor.publish 'posts', (limit)->
  Post.find({}, {limit: limit})

Meteor.publish 'all_posts', (limit)->
  Post.find({}, {limit: limit})

Meteor.publish 'post', (id)->
  Post.find _id: id

Meteor.publish 'tracks', -> Tracks.find()

Meteor.publish 'tracks_limit', (limit) -> Tracks.find({'metadata._Resumable': { $exists: false }}, {limit: limit})

Meteor.publish 'userData', ->
  if @userId
    Meteor.users.find
      _id: @userId
      fields:
        'admin': 1
  else
    @ready()
  return