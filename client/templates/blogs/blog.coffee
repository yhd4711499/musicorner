getPost = (id) ->
  (Post.first( { _id : id } ) ) or {}

Template.blog.onRendered ->
  Session.set 'postId', Router.current().params._id

Template.blog.helpers
  post: -> getPost Session.get 'postId'

Template.blog.events
  'click [data-action=delete]': () ->
    _id = @_id
    rd = ReactiveModal.initDialog
      template: Template.trackOperationModal
      title: 'Delete article ?'
      removeOnHide: true
      buttons:
        'cancel':
          class: 'btn-danger'
          label: 'Cancel'
        'ok':
          closeModalOnClick: true
          class: 'btn-info'
          label: 'Ok'
      doc:
        filename: this.filename
        msg: "Are you sure to delete this article ?"

    rd.show();

    rd.buttons.ok.on 'click', ->
      Post._collection.remove _id: _id, (err, doc)->
        if err
          alert(err)
        else
          Router.go 'home'