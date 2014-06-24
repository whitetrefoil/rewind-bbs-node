require('chai').should()
path = require 'path'
getConfig = require path.join process.cwd(), 'src/config'

describe 'config.coffee', ->
  describe 'development', ->
    it 'is nothing', (done) ->
      getConfig 'data/config.default.json', (json) ->
        json.a.should.equal(1)
        done()
