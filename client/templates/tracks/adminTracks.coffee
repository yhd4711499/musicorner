Template.adminTracks.helpers
  albums: () ->
    Tracks.aggregate
      $group:
        _id: 'album'
        tracks:
          $push: 'title'
        md5s:
          $push: 'md5'
  tracks: -> 
    Tracks.find({'metadata._Resumable': { $exists: false }})
  uploadStatus: () ->
    percent = Session.get "#{this._id}"
    unless percent?
      "Processing..."
    else
      "Uploading..."
    uploadProgress: () ->
      percent = Session.get "#{this._id}"
    playing: -> Session.get('status') == 2

Template.adminTracks.onRendered ->

  Tracks.resumable.assignDrop($(".fileDrop"));

  Tracks.resumable.on 'fileAdded', (file) ->
   Session.set file.uniqueIdentifier, 0
   Tracks.insert({
       _id: file.uniqueIdentifier
       filename: file.fileName
       contentType: file.file.type
    },
    (err, _id) ->
       if err
        console.warn "File creation failed!", err
        return
       Tracks.resumable.upload()
   )

  Tracks.resumable.on 'fileProgress', (file) ->
   Session.set file.uniqueIdentifier, Math.floor(100*file.progress())

  Tracks.resumable.on 'fileSuccess', (file) ->
   Session.set file.uniqueIdentifier, undefined

  Tracks.resumable.on 'fileError', (file) ->
   console.warn "Error uploading", file.uniqueIdentifier
   Session.set file.uniqueIdentifier, undefined

Template.adminTracks.events
  'click [data-action=login]': () ->
    password = $('input#password').val()
    Meteor.loginWithPassword("yhd4711499@live.com", password, (err) ->
      if err
        alert(err)
      )