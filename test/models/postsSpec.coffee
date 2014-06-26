'use strict'

should = require('chai').should()
path = require 'path'
mongoose = require 'mongoose'
blanket = require('blanket')()
require path.join(process.cwd(), 'src/models/posts')

describe 'Models ::', ->
  describe 'Post', ->
    it 'should be initialized successfully', ->
      mongoose.model('Post').should.be.exist
