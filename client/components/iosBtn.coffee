Template.iosBtn.helpers
	class: -> this.class + '-outline'
	attrs: -> id: this.id

Template.iosBtn.events
	'mouseenter': (e, template) ->
		$(e.target).removeClass(template.data.class + '-outline')
		$(e.target).addClass(template.data.class)

	'mouseleave': (e, template) ->
		$(e.target).removeClass(template.data.class)
		$(e.target).addClass(template.data.class + '-outline')