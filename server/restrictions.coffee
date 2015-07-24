@Tracks.allow
  insert: (userId, doc) ->
  	userId?
  remove: (userId, doc) ->
    userId?
  read: (userId, doc) ->
    true
  write: (userId, doc, fields) ->
    userId?

@Post._collection.allow
	insert: (userId, doc) ->
		userId || Meteor.user()?.admin
	update: (userId, doc, fields, modifier) ->
		result = false
		result = (userId && doc.userId == userId)
		result = result || Meteor.user()?.admin
		return result
	remove: (userId, doc) ->
		result = false
		result = (userId && doc.userId == userId)
		result = result || Meteor.user()?.admin
		return result
	fetch: ['_id']
	