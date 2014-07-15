'use strict'

should = require('chai').should()
path = require 'path'
mongoose = require 'mongoose'
blanket = require('blanket')()
require path.join(process.cwd(), 'src/models/posts')

describe 'Models', ->
  describe ':: Post', ->
    beforeEach ->
      @Post = mongoose.model 'Post'
    it 'should be initialized successfully', ->
      @Post.should.be.exist

    describe '#toJSON()', ->
      beforeEach ->
        @post = new @Post()
      it 'should return `id` instead of `_id`', ->
        json = @post.toJSON()
        should.not.exist(json._id)
        json.id.should.be.exist
      it 'should not return `__v`', ->
        json = @post.toJSON()
        should.not.exist(json.__v)
