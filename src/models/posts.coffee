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

#### Model
mongoose.model 'Post', postSchema

#### Exports

# There's no need to export anything.
# `mongoose` will handle all the required models.
