'use strict'

index = ->
  console.log 'GO!'

module.exports = index

if require.main is module
  index(process.argv)
