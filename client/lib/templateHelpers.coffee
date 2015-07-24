Template.registerHelper(
	'multiLines'
	(data)-> data.replace(/[(\n)|(\r\n)]/g, '<br />' )
	)

Template.registerHelper(
	'session'
	(data)->Session.get data
	)

UI.registerHelper "blogFormatDate", (date) ->
  moment(new Date(date)).format "MMM Do, YYYY"