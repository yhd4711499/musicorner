Template.appLayout.onRendered ->
  elem = $('.view-animate-container')
  nav = $('#site-header, .nav-menu')

  doOffset = ->
    width = elem.width()
    if width >= 1360
      offset = $(window).width() - width
      nav.css('left', offset / 2 - 40)
    else
      nav.css('left', 0)

  $(window).on("resize", doOffset)
  doOffset()
  Meteor.setTimeout ->
    $('#site-loader').addClass('loaded')
  , 1000