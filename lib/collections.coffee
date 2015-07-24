@Tracks = new FileCollection('tracks',
  resumable: true
  http: [ {
    method: 'get'
    path: '/:md5'
    lookup: (params, query) ->
      # uses express style url params
      { md5: params.md5 }
      # a query mapping url to myFiles

  } ])