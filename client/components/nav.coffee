toggle = ->
	$('body').toggleClass('locked')
	$('div.nav-menu.max-width').toggleClass('isActive')
	$('.hamburger').toggleClass('hamActive')

Template.nav.helpers
	isActive: () ->
		Session.get 'isActive'
	menus: ->
		[
			{
				url: '/about'
				title: 'About'
				subTitle: 'Get to know me'
			}
			{
				url: '/works'
				title: 'Works'
				subTitle: 'See the goods'
			}
			{
				url: '/blogs'
				title: 'Blog'
				subTitle: 'Read my mind'
			}
			{
				url: '/admin'
				title: 'Admin'
				subTitle: 'Staff only'
			}
		]

Template.nav.events
	'click [data-action="toggleNavMenu"]': (e) ->
		toggle()
	'click nav.the-links': ->
		toggle()