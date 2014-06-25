require('chai').should()
path = require 'path'
fs = require 'fs-extra'
blanket = require('blanket')()
getConfig = require path.join process.cwd(), 'src/config'

describe 'config.coffee', ->
  describe 'development', ->
    it 'is nothing', ->
      getConfig().should.deep.equal(fs.readJsonSync(path.join(process.cwd(), 'config/config.default.json')))
