Blog =
  settings:
    adminRole: null
    adminGroup: null
    authorRole: null
    authorGroup: null
    rss:
      title: ''
      description: ''

  config: (appConfig) ->
    @settings = _.extend(@settings, appConfig)

@Blog = Blog

Meteor.startup ->
  if Tag.count() == 0
    Tag.create
      tags: ['meteor']