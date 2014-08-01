{Robot, TextMessage} = require 'hubot'
assert = require 'power-assert'
path = require 'path'
sinon = require 'sinon'

describe 'hello', ->
  beforeEach (done) ->
    @sinon = sinon.sandbox.create()
    @robot = new Robot(path.resolve(__dirname, '..'), 'shell', false, 'hubot')
    @robot.adapter.on 'connected', =>
      @robot.load path.resolve(__dirname, '../../src/scripts')
      done()
    @robot.run()

  afterEach (done) ->
    @robot.brain.on 'close', =>
      @sinon.restore()
      done()
    @robot.shutdown()

  describe 'listeners[0].regex', ->
    beforeEach ->
      @callback = @sinon.spy()
      @robot.listeners[0].callback = @callback

    describe 'receive "@hubot backlog-star-ranking"', ->
      beforeEach ->
        sender = { id: 'bouzuya', room: 'hitoridokusho' }
        message = '@hubot backlog-star-ranking'
        @robot.adapter.receive new TextMessage(sender, message)

      it 'calls *hello* with "@hubot backlog-star-ranking"', ->
        assert @callback.callCount is 1
        assert @callback.firstCall.args[0].match.length is 1
        assert @callback.firstCall.args[0].match[0] is '@hubot backlog-star-ranking'
