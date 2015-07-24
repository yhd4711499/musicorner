Meteor.startup ->
	if Meteor.users.find().count() == 0
		Accounts.createUser
			username: "yhd"
			email: "yhd4711499@live.com"
			password: "19891215"