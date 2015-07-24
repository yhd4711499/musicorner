editor = {}
body = ""
class @BlogEditor extends MediumEditor
  @make: (query)->
    new MediumEditor query, 
      placeholder: ''
      firstHeader: 'h1'
      secondHeader: 'h2'
      buttonLabels: 'fontawesome'
      buttons:
        ['bold', 'italic', 'underline', 'anchor', 'pre', 'header1', 'header2', 'orderedlist', 'unorderedlist', 'quote', 'image']
      extensions: 
        markdown: new MeMarkdown (md) ->
          body = md

  # Return medium editor's contents
  contents: ->
    @serialize()['element-0'].value

getPost = (id) ->
  (Post.first( { _id : id } ) ) or {}
  
save = (tpl, cb) ->
  $form = tpl.$('form')
  # body = editor.serialize()['element-0'].value
  attrs =
      title: $('[name=title]', $form).val()
      tags: $('[name=tags]', $form).val()
      # slug: slug
      # description: description
      body: body
      updatedAt: new Date()

    if getPost( Session.get('postId') ).id
      post = getPost( Session.get('postId') ).update attrs
      Session.set('postId', null)
      if post.errors
        return cb new Error _(post.errors[0]).values()[0]
      cb null, post

    else
      attrs.userId = Meteor.userId()
      post = Post.create attrs
      Session.set('postId', null)
      if post.errors
        return cb(null, new Error _(post.errors[0]).values()[0])
      cb null, post

Template.postNew.onCreated ->
  Session.set 'postId', Router.current().params._id

Template.postNew.onRendered ->
  editor = BlogEditor.make '.editable'

Template.postNew.helpers
  post: () ->
    {
      title: ""
      category: "CULTURE"
      today: new Date()
      content: ""
    }

Template.postNew.events
  'click [data-action=save]': (e, tpl) ->
    save(tpl, (err, doc)->
        return alert(err) if err
        Router.go "/blogs/#{doc._id}"
      )
    