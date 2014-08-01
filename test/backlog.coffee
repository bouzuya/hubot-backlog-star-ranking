assert = require 'power-assert'
sinon = require 'sinon'
{Backlog} = require '../src/backlog'

describe 'Backlog', ->
  beforeEach ->
    @sinon = sinon.sandbox.create()
    @backlog = new Backlog
      spaceId: 'space'
      apiKey: 'apiKey'

  afterEach ->
    @sinon.restore()

  describe 'constructor', ->
    describe '{ spaceId: "space", apiKey: "apiKey" }', ->
      describe '@spaceId', ->
        it 'returns "space"', ->
          assert @backlog.spaceId is 'space'

      describe '@apiKey', ->
        it 'returns "apiKey"', ->
          assert @backlog.apiKey is 'apiKey'

  describe '_get', ->
    beforeEach ->
      @_request = @sinon.stub @backlog, '_request'

    describe '"/api/v2/issues", { "projectId[]": 1 }', ->
      beforeEach ->
        @backlog._get '/api/v2/issues', { query: { 'projectId[]': 1 } }

      it 'calls _request ' +
      '{ method: "GET", url: <...get-issues...>, qs: <apiKey & query> }', ->
        assert @_request.callCount is 1
        assert @_request.firstCall.args[0].method is 'GET'
        assert @_request.firstCall.args[0].url is
          'https://space.backlog.jp/api/v2/issues'
        assert @_request.firstCall.args[0].qs.apiKey is 'apiKey'
        assert @_request.firstCall.args[0].qs['projectId[]'] is 1

  describe '_request', ->
    describe '{ method: "GET", url: <...>, query: <...> }', ->
      it 'works', ->
        # TODO:
        assert.ok true

  describe '_buildUrl', ->
    describe '"/api/v2/users"', ->
      it 'returns "https://space.backlog.jp/api/v2/users"', ->
        assert @backlog._buildUrl('/api/v2/users') is
          'https://space.backlog.jp/api/v2/users'

    describe '"/api/v2/users/:userId", { userId: 1 }', ->
      it 'returns "/api/v2/users/1"', ->
        assert @backlog._buildUrl('/api/v2/users/:userId', { userId: '1'}) is
          'https://space.backlog.jp/api/v2/users/1'

  describe '_ensureApiKey', ->
    describe '{}', ->
      beforeEach -> @query = {}
      it 'returns { apiKey: "apiKey" }', ->
        actual = @backlog._ensureApiKey(@query)
        assert.deepEqual actual, { apiKey: 'apiKey' }
        assert.deepEqual @query, {}

    describe '{ abc: "abc" }', ->
      beforeEach -> @query = { abc: 'abc' }
      it 'returns { abc: "abc", apiKey: "apiKey" }', ->
        actual = @backlog._ensureApiKey(@query)
        assert.deepEqual actual, { abc: 'abc', apiKey: 'apiKey' }
        assert.deepEqual @query, { abc: 'abc' }

    describe '{ abc: "abc", apiKey: "xyz" }', ->
      beforeEach -> @query = { abc: 'abc', apiKey: 'xyz' }
      it 'returns { abc: "abc", apiKey: "xyz" }', ->
        actual = @backlog._ensureApiKey(@query)
        assert.deepEqual actual, { abc: 'abc', apiKey: 'xyz' }
        assert.deepEqual @query, { abc: 'abc', apiKey: 'xyz' }
