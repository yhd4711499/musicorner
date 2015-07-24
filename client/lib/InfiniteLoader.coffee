
class @InfiniteLoader
  constructor: (@subscribe, @count, @listQuery, opt) ->
    @chunk = opt?.chunk || 5
    @limit = @chunk
    # tpl.onDestroyed ->
    #   removeInfiniteScroll()
    # tpl.onRendered ->
    #   init()

  init: (tpl) -> 
    @createInfiniteScroll(@listQuery)
    self = this
    Meteor.autorun ->
      _loadedListeners.depend()
      setLoadingPosts true
      tpl.subscribe self.subscribe, self.limit, 
        onReady: ->
          setLoadingPosts false
          _loadingListeners.changed()
          if self.limit > self.count()
              removeInfiniteScroll()

  destroy: -> removeInfiniteScroll()

  loadingListeners : -> _loadingListeners

  # private members
  _loadingPosts = false;
  _loadingListeners = new Deps.Dependency()
  _loadedListeners = new Deps.Dependency()
  _finished = false;

  createInfiniteScroll : (listQuery) ->
    self = this
    $(window).on scroll: (e) ->
      return if _finished
      pageHeight = $(document).height()
      scrollPos = e.currentTarget.scrollY + $(window).height()
      predictiveOffset = 300
      threshold = pageHeight - predictiveOffset
      if scrollPos >= threshold and $(listQuery).length > 0
        # manage triggering other evt as it makes API call, reset this in the api callback
        if getLoadingPosts() == false
          setLoadingPosts true
          self.limit += self.chunk
          console.log "loading #{self.limit}"
          _loadedListeners.changed()

  removeInfiniteScroll = ->
    _finished = true
    $(window).off 'scroll PRPL_INFINITE_SCROLL'

  getLoadingPosts = ->
    _loadingPosts

  setLoadingPosts = (bool) ->
    _loadingPosts = bool
    if bool == true
      $('.infinite-loader').addClass('infinite-loading')
    else if bool == false
      $('.infinite-loader').removeClass('infinite-loading')
    return
  
