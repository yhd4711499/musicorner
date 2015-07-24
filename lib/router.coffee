Router.configure
  layoutTemplate: 'appLayout'
  notFoundTemplate: 'notFound'
  # waitOn: ->
  #     [Meteor.subscribe 'userData']

Router.map ->
  @route('home', {path: '/'});

  @route 'blogs'
    # waitOn: ->
   #    Meteor.subscribeWithPagination('post', 10);

  @route 'blog', 
    path: '/blogs/:_id'
    waitOn: ->
      Meteor.subscribe('post', @params._id)
    
  @route('about');
  @route('works');
  @route('admin');
  @route('admin.tracks', {path: '/admin/tracks'});
  @route('post.new', {path: '/new'});