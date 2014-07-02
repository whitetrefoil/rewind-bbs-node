'use strict'

chai = require 'chai'
should = chai.should()
sinon = require 'sinon'
sinonChai = require 'sinon-chai'
chai.use sinonChai
supertest = require 'supertest'

path = require 'path'
mongo = require '../../src/mongo'

# Mongoose Classes to Mock
Query = require 'mongoose/lib/query'
Model = require 'mongoose/lib/model'
Document = require 'mongoose/lib/document'

blanket = require('blanket')()
server = require path.join(process.cwd(), 'src/server')
require path.join(process.cwd(), 'src/models/posts')
require path.join(process.cwd(), 'src/routes/posts')

describe 'Routes', ->
  describe ':: Post', ->
    Post = mongo.model 'Post'
    describe ':: API', ->
      describe ':: Index', ->
        afterEach ->
          Query::exec.restore()

        it 'should response a list', (done) ->
          # Mock
          sinon.stub Query::, 'exec', (callback) -> callback null, []
          # Test
          supertest server
          .get '/posts'
          .set 'Accept', 'application/json'
          .expect 'Content-Type', /json/
          .expect 200
          .expect '[]'
          .end (err, res) ->
            if err?
              done err
            else
              res.body.should.be.a('array')
              done()

        it 'should response 500 error if mongoose throw error', (done) ->
          # Mock
          sinon.stub Query::, 'exec', (callback) -> callback new Error(), null
          # Test
          supertest server
          .get '/posts'
          .set 'Accept', 'application/json'
          .expect 'Content-Type', /json/
          .expect 500
          .expect /^\{.*}$/
          .end (err, res) ->
            if err?
              done err
            else
              res.body.should.be.a('object')
              done()

      describe ':: Get', ->
        afterEach ->
          Query::exec.restore()

        it 'should return a JSON object', (done) ->
          # Mock
          sinon.stub Query::, 'exec', (callback) -> callback null, {}
          # Test
          supertest server
          .get '/posts/1'
          .set 'Accept', 'application/json'
          .expect 'Content-Type', /json/
          .expect 200
          .expect /^\{.*}$/
          .end (err, res) ->
            if err?
              done err
            else
              res.body.should.be.a('object')
              done()

        it 'should response 404 error if not found', (done) ->
          # Mock
          sinon.stub Query::, 'exec', (callback) -> callback null, null
          # Test
          supertest server
          .get '/posts/1'
          .set 'Accept', 'application/json'
          .expect 'Content-Type', /json/
          .expect 404
          .expect /^\{.*}$/
          .end (err, res) ->
            if err?
              done err
            else
              res.body.should.be.a('object')
              done()

        it 'should response 500 error if mongoose throw error', (done) ->
          # Mock
          sinon.stub Query::, 'exec', (callback) -> callback new Error(), null
          # Test
          supertest server
          .get '/posts/1'
          .set 'Accept', 'application/json'
          .expect 'Content-Type', /json/
          .expect 500
          .expect /^\{.*}$/
          .end (err, res) ->
            if err?
              done err
            else
              res.body.should.be.a('object')
              done()

      describe ':: Post', ->
        afterEach ->
          Model::save.restore()

        it 'should return a JSON object', (done) ->
          # Mock
          sinon.stub Model::, 'save', (callback) -> callback null
          # Test
          supertest server
          .post '/posts'
          .set 'Accept', 'application/json'
          .send {subject: 1}
          .expect 'Content-Type', /json/
          .expect 201
          .expect /^\{.*}$/
          .end (err, res) ->
            if err?
              done err
            else
              res.body.should.be.a('object')
              done()

        it 'should response 400 error if the request body is not valid JSON', (done) ->
          # Mock
          sinon.stub Model::, 'save', (callback) -> callback null
          # Test - Invalid JSON
          supertest server
          .post '/posts'
          .set 'Accept', 'application/json'
          .send '/////////'
          .expect 'Content-Type', /json/
          .expect 400
          .expect /^\{.*}$/
          .end (err, res) ->
            if err?
              done err
            else
              res.body.should.be.a('object')
              done()

        it 'should response 400 error if the request body is not a valid JSON but not a plain object', (done) ->
          # Mock
          sinon.stub Model::, 'save', (callback) -> callback null
          # Test - Valid but not acceptable JSON
          supertest server
          .post '/posts'
          .set 'Accept', 'application/json'
          .send '1111'
          .expect 'Content-Type', /json/
          .expect 400
          .expect /^\{.*}$/
          .end (err, res) ->
            if err?
              done err
            else
              res.body.should.be.a('object')
              done()


        it 'should response 500 error if mongoose throw error', (done) ->
          # Mock
          sinon.stub Model::, 'save', (callback) -> callback new Error()
          # Test
          supertest server
          .post '/posts'
          .send '{}'
          .set 'Accept', 'application/json'
          .expect 'Content-Type', /json/
          .expect 500
          .expect /^\{.*}$/
          .end (err, res) ->
            if err?
              done err
            else
              res.body.should.be.a('object')
              done()

      describe ':: Put', ->
        afterEach ->
          Query::exec.restore()
          Post.findById.restore?()

        it 'should search the existing post by the ID & return a JSON object', (done) ->
          # Mock
          sinon.stub Query::, 'exec', (callback) ->
            callback null,
              update: ->
                exec: (callback) ->
                  callback null
          sinon.spy Post, 'findById'
          # Test
          supertest server
          .put '/posts/1'
          .set 'Accept', 'application/json'
          .send '{}'
          .expect 'Content-Type', /json/
          .expect 200
          .expect /^\{.*}$/
          .end (err, res) ->
            if err?
              done err
            else
              res.body.should.be.a('object')
              Post.findById.should.have.been.calledWith '1'
              done()

        it 'should response 400 error if the request body is not valid JSON', (done) ->
          # Mock
          sinon.stub Query::, 'exec', (callback) ->
            callback null,
              update: ->
                exec: (callback) ->
                  callback null
          # Test - Invalid JSON
          supertest server
          .put '/posts/1'
          .set 'Accept', 'application/json'
          .send '/////////'
          .expect 'Content-Type', /json/
          .expect 400
          .expect /^\{.*}$/
          .end (err, res) ->
            if err?
              done err
            else
              res.body.should.be.a('object')
              done()

        it 'should response 400 error if the request body is not a valid JSON but not a plain object', (done) ->
          # Mock
          sinon.stub Query::, 'exec', (callback) ->
            callback null,
              update: ->
                exec: (callback) ->
                  callback null
          # Test - Valid but not acceptable JSON
          supertest server
          .put '/posts/1'
          .set 'Accept', 'application/json'
          .send '1111'
          .expect 'Content-Type', /json/
          .expect 400
          .expect /^\{.*}$/
          .end (err, res) ->
            if err?
              done err
            else
              res.body.should.be.a('object')
              done()

        it 'should response 404 error if the post to update is not existing', (done) ->
          # Mock
          sinon.stub Query::, 'exec', (callback) ->
            callback null, null
          # Test - Valid but not acceptable JSON
          supertest server
          .put '/posts/1'
          .set 'Accept', 'application/json'
          .send '{}'
          .expect 'Content-Type', /json/
          .expect 404
          .expect /^\{.*}$/
          .end (err, res) ->
            if err?
              done err
            else
              res.body.should.be.a('object')
              done()

        it 'should response 500 error if mongoose throw error when searching existing post', (done) ->
          # Mock
          sinon.stub Query::, 'exec', (callback) ->
            callback new Error(), null
          # Test
          supertest server
          .put '/posts/1'
          .send '{}'
          .set 'Accept', 'application/json'
          .expect 'Content-Type', /json/
          .expect 500
          .expect /^\{.*}$/
          .end (err, res) ->
            if err?
              done err
            else
              res.body.should.be.a('object')
              done()

        it 'should response 500 error if mongoose throw error when saving changes', (done) ->
          # Mock
          sinon.stub Query::, 'exec', (callback) ->
            callback null,
              update: ->
                exec: (callback) ->
                  callback new Error()
          # Test
          supertest server
          .put '/posts/1'
          .send '{}'
          .set 'Accept', 'application/json'
          .expect 'Content-Type', /json/
          .expect 500
          .expect /^\{.*}$/
          .end (err, res) ->
            if err?
              done err
            else
              res.body.should.be.a('object')
              done()

      describe ':: Delete', ->
        afterEach ->
          Query::exec.restore()
          Post.findById.restore?()

        it 'should search the existing post by the ID & return a JSON object', (done) ->
          # Mock
          sinon.stub Query::, 'exec', (callback) ->
            callback null,
              id: 'mock'
          sinon.spy Post, 'findById'
          sinon.spy Post, 'remove'
          # Test
          supertest server
          .del '/posts/1'
          .set 'Accept', 'application/json'
          .send '{}'
          .expect 'Content-Type', /json/
          .expect 200
          .expect /^\{.*}$/
          .end (err, res) ->
            if err?
              done err
            else
              res.body.should.be.a('object')
              Post.findById.should.have.been.calledWith '1'
              Post.remove.should.have.been.calledWith
                _id: 'mock'
              done()

        it 'should response 404 error if the post to update is not existing', (done) ->
          # Mock
          sinon.stub Query::, 'exec', (callback) ->
            callback null, null
          # Test - Valid but not acceptable JSON
          supertest server
          .del '/posts/1'
          .set 'Accept', 'application/json'
          .send '{}'
          .expect 'Content-Type', /json/
          .expect 404
          .expect /^\{.*}$/
          .end (err, res) ->
            if err?
              done err
            else
              res.body.should.be.a('object')
              done()

        it 'should response 500 error if mongoose throw error when searching existing post', (done) ->
          # Mock
          sinon.stub Query::, 'exec', (callback) ->
            callback new Error(), null
          # Test
          supertest server
          .del '/posts/1'
          .send '{}'
          .set 'Accept', 'application/json'
          .expect 'Content-Type', /json/
          .expect 500
          .expect /^\{.*}$/
          .end (err, res) ->
            if err?
              done err
            else
              res.body.should.be.a('object')
              done()
