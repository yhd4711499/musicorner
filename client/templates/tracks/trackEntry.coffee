Template.trackEntry.events
  'click [data-action=delete]': () ->
    _id = @_id
    
    rd = ReactiveModal.initDialog
      template: Template.trackOperationModal
      title: 'Delete track ?'
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
        msg: "<p>Are you sure to delete <span class='accent'>#{this.filename}</span> ?</p>"

    rd.show();

    rd.buttons.ok.on 'click', ->
      Tracks.remove({_id: _id})