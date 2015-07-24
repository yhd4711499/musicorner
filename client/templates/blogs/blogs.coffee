loader = {}
_loadingListeners = {}

Template.blogs.onCreated ->
  loader = new InfiniteLoader 'posts', ( -> Post.count() ), '#pageNotes', {chunk: 5}
  _loadingListeners = loader.loadingListeners()

Template.blogs.onRendered ->
  loader.init this

Template.blogs.helpers
  posts: () ->
    _loadingListeners.depend()
    Post.find({}, {sort: {createdAt: -1}})