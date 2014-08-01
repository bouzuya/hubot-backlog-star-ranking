
{Promise} = require 'q'
request = require 'request'

class Backlog

  constructor: (options={}) ->
    @spaceId = options.spaceId
    @apiKey = options.apiKey

  getUsers: ->
    @_get '/api/v2/users'

  getUserStarCount: (options) ->
    @_get '/api/v2/users/:userId/stars/count', options

  _get: (path, options={}) ->
    method = 'GET'
    url = @_buildUrl(path, options.params ? {})
    qs = @_ensureApiKey(options.query ? {})
    @_request { method, url, qs }

  _request: (options) ->
    new Promise (resolve, reject) ->
      request options, (err, _, body)->
        return reject(err) if err?
        try
          json = JSON.parse(body)
          setTimeout (-> resolve(json)), 100
        catch e
          reject(e)

  _buildUrl: (path, params={}) ->
    "https://#{@spaceId}.backlog.jp" + path.replace /:(\w+)/, (_, p1) ->
      params[p1]

  _ensureApiKey: (query) ->
    @_extend { apiKey: @apiKey }, query

  _extend: (o1, o2) ->
    for key of o2
      o1[key] = o2[key]
    o1

module.exports = {Backlog}
