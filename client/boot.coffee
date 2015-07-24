Blog =
  settings:
    title: ''
    blogIndexTemplate: null
    blogShowTemplate: null
    blogNotFoundTemplate: null
    blogAdminTemplate: null
    blogAdminEditTemplate: null
    pageSize: 20
    publicDrafts: true
    excerptFunction: null
    syntaxHighlighting: false
    syntaxHighlightingTheme: 'github'
    comments:
      allowAnonymous: false
      useSideComments: false
      defaultImg: '/packages/blog/public/default-user.png'
      userImg: 'avatar'
      disqusShortname: null

  config: (appConfig) ->
    # No deep extend in underscore :-(
    if appConfig.comments
      @settings.comments = _.extend(@settings.comments, appConfig.comments)
      delete appConfig.comments
    @settings = _.extend(@settings, appConfig)

    if @settings.syntaxHighlightingTheme
      $('<link>',
        href: '//cdnjs.cloudflare.com/ajax/libs/highlight.js/8.1/styles/' + @settings.syntaxHighlightingTheme + '.min.css'
        rel: 'stylesheet'
      ).appendTo 'head'


@Blog = Blog