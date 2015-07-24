Accounts.onCreateUser (options, user) ->
	if options.profile
		user.profile = options.profile
	# If this is the first user going into the database, make them an admin
	if Meteor.users.find().count() == 0
		user.admin = true
	user
# Tracks = @Tracks
# mm = Meteor.npmRequire('musicmetadata')
# @Tracks.find({'metadata._Resumable': { $exists: false }}).observe 
# 	added: (document) ->
# 		stream = Tracks.findOneStream({filename: document.filename})
# 		stream.on('readable', ->
# 			console.log(stream.read())
# 			)
# 		# stream.on('data', (chunk)->
# 		# 	console.log(chunk)
# 		# 	)
# 		# stream.on('readable', ->
# 		# 	parser = mm(stream);

# 		# 	parser.on('metadata', (result) ->
# 		# 		if result
# 		# 			console.log(result)
# 		# 		else
# 		# 			console.log("failed to parse music metadata of file: #{document.filename}")
# 		# 		)
# 		# 	)
		

