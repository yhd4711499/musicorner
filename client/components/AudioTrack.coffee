window.requestAnimationFrame = window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame

@AudioTrack = (cfg) ->
  @ctx = cfg.ctx
  @useAudioTag = cfg.useAudioTag || true
  @url = cfg.url
  @outNode = cfg.outNode
  @fftSize = cfg.fftSize || 256
  @freqCount = @fftSize / 2
  @freqShowPercent = 1
  @canvas = cfg.canvas
  @cCtx = @canvas.getContext("2d")
  # 0: idle
  # 1: pending
  # 2: playing
  # 3: seeking
  # 4: paused
  @status = 0
  @drawOpts = _.extend(cfg.drawOpts || {}, {
    gap: 4,
    fillStyle: '#FFFFFFFF'
    strokeStyle: '#AAA'
    })
  @resize = _.bind ->
    @canvas.width = $(@canvas).css('width').replace('px', '') 
    @canvas.height = $(@canvas).css('height').replace('px', '') 
  ,
    @
  @resize()  
  $(window).off("resize", @resize).on("resize", @resize)
  return this



@AudioTrack::getAudio = ->
  @audio

@AudioTrack::addGainNode = (node) ->
  gainNode = @ctx.createGain()
  node.connect gainNode
  gainNode.connect @outNode
  gainNode

@AudioTrack::createAnalyser = (node) ->
  analyser = @ctx.createAnalyser()
  analyser.smoothingTimeConstant = 0.6
  analyser.fftSize = @fftSize
  node.connect analyser
  analyser

@AudioTrack::loadAndDecode = (statusCallback) ->
  self = this
  if self.useAudioTag
    audio = new Audio(self.url)
    audio.addEventListener 'canplay', (e) ->
      self.node = self.ctx.createMediaElementSource(audio)
      self.gainNode = self.addGainNode(self.node)
      self.analyser = self.createAnalyser(self.gainNode)
      statusCallback 'ready'
      self.status = 2
    self.audio = audio
  else
    if self.buffer
      # already loaded
      self.pauseTime = null
      statusCallback 'ready'
      return
    statusCallback 'loading'
    # Meteor.call('GET', (@url, responseType: 'arraybuffer').then (response) ->
    #   statusCallback 'decoding'
    #   self.ctx.decodeAudioData response.data, (buffer) ->
    #     self.buffer = buffer
    #     statusCallback 'ready'
    #     return
    #   return
  return

@AudioTrack::play = ->
  status = 1
  @startAnimation()
  @audio.play()

@AudioTrack::stop = ->
  @audio.pause()
  $(window).off("resize", @resize)
  @status = 0
  @draw()

@AudioTrack::setVolume = (value) ->
  if @gainNode
    @gainNode.gain.value = value
  return

@AudioTrack::destroy = ->
  @stop()
  @stopAnimation()

@AudioTrack::playBuffer = ->
  @bsNode = @ctx.createBufferSource()
  @bsNode.buffer = @buffer
  bufferOffset = @pauseTime or 0
  @startTime = @ctx.currentTime
  if @pauseTime
    @startTime -= @pauseTime
  @bsNode.start 0, bufferOffset
  @gainNode = @addGainNode(@bsNode, @outNode)
  @analyser = @createAnalyser(@gainNode, @fftSize)
  return

@AudioTrack::clear = ->
  if @audio
    @audio.src = ''

@AudioTrack::stopAnimation = ->
  if @requestId
    window.cancelAnimationFrame(@requestId)
  @requestId = undefined

@AudioTrack::startAnimation = ->
  self = this
  self.requestId = window.requestAnimationFrame(-> self.startAnimation())
  self.draw()

@AudioTrack::draw = () ->
  if not @canvas or not @analyser
    return

  canvasWidth = @canvas.offsetWidth
  canvasHeight = @canvas.offsetHeight
  freqDrawWidth = canvasWidth / (@freqCount * @freqShowPercent)
  timeDrawWidth = canvasWidth / @freqCount
  fftSize = @fftSize
  byteFreqArr = new Uint8Array(@analyser.frequencyBinCount)
  @analyser.getByteFrequencyData byteFreqArr

  timeDomainArr = new Uint8Array(@analyser.frequencyBinCount)
  @analyser.getByteTimeDomainData timeDomainArr

  @cCtx.clearRect 0, 0, canvasWidth, canvasHeight
  @cCtx.beginPath()

  i = 0
  iLen = byteFreqArr.length
  while i < iLen
    @cCtx.fillRect(
      i*freqDrawWidth
      ((fftSize - byteFreqArr[i]) / fftSize) * canvasHeight
      freqDrawWidth
      canvasHeight
      )
    # percent = timeDomainArr[i] / 256
    # offset = canvasHeight - (percent * canvasHeight) - 1
    # @cCtx.lineTo(i * timeDrawWidth, offset)
    i++
  @cCtx.stroke()