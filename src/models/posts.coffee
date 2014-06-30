# Summary
# -----

# This is the model definition of `Post`.

# Code
# ----

# 'use strict' always first :)

'use strict'

#### Dependencies

mongoose = require 'mongoose'

#### Schema Definition

postSchema = new mongoose.Schema
  summary: String
  content: String
  author: String

postSchema.set 'toJSON',
  getters: true
  virtuals: true
  transform: (doc, ret) ->
    ret.id = ret._id
    delete ret._id
    delete ret.__v
    ret


#### Model
mongoose.model 'Post', postSchema

#### Exports

# There's no need to export anything.
# `mongoose` will handle all the required models.
