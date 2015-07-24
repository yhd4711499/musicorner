

Template.player.onCreated ->
  Meteor.subscribe 'tracks'

  # init audio context
  window.AudioContext = window.AudioContext || window.webkitAudioContext
  @aCtx = new window.AudioContext
  @aCtx.createGain = @aCtx.createGain || @aCtx.createGainNode
  @master = {}
  @master.gainNode = @aCtx.createGain();
  @master.gainNode.connect @aCtx.destination
  Session.set 'status',0
  self = this

  # Meteor.autorun ->
  #   self.tracks = _.shuffle(Tracks.find({'metadata._Resumable': { $exists: false }}, {fields: {md5: 1}}).fetch())
  #   self.currentTrackIndex = 0

  @play = (next) ->
    template = self

    if template.tracks is undefined or template.tracks.length == 0
      template.tracks = _.shuffle(Tracks.find({'metadata._Resumable': { $exists: false }}, {fields: {md5: 1}}).fetch())
      template.currentTrackIndex = 0

    if template.audioTrack
      template.audioTrack.destroy()
      delete template.audioTrack

    template.audioTrack = new AudioTrack {
      ctx: template.aCtx
      url: "#{Tracks.baseURL}/#{template.tracks[template.currentTrackIndex].md5}?cache=172800"
      outNode: template.master.gainNode
      fftSize: template.fftSize
      canvas: $('canvas')[0]
    }
    

    template.audioTrack.loadAndDecode (status)-> 
      template.audioTrack.play()

      template.audioTrack.getAudio().addEventListener 'ended', ->
        template.play(true)

      Session.set 'status',2
    
    if next
      template.currentTrackIndex++
      if template.currentTrackIndex >= template.tracks.length
        template.currentTrackIndex=0
        template.tracks = _(template.tracks).shuffle()
    else
      template.currentTrackIndex--
      if template.currentTrackIndex < 0
        template.currentTrackIndex = template.tracks.length-1
  
Template.player.helpers
  tracks: ->  Tracks.find({'metadata._Resumable': { $exists: false }})
  playing: -> Session.get('status') == 2

Template.player.events
  'click #playToggle': (e, template) ->
    switch Session.get 'status'
      when 2
        template.audioTrack.stop()
        Session.set 'status', 4
      when 4
        template.audioTrack.play()
        Session.set 'status', 2
      when 0
        template.play(true)
  'click #forward': (e, template) ->
      template.play(true)
  'click #rewind': (e, template) ->
    template.play(false)

