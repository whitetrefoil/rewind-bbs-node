'use strict'

module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt)
  require('time-grunt')(grunt)

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    clean:
      compile: ['lib']
      doc: ['doc']

    coffee:
      compile:
        files: [
          expand: true
          cwd: './src'
          src: ['./**/*.+(coffee|litcoffee)']
          dest: './lib'
          ext: '.js'
          extDot: 'last'
        ]

    watch:
      src:
        files: ['src/**/*.+(coffee|litcoffee)']
        tasks: ['concurrent:all']
        options:
          atBegin: true

    docco:
      compile:
        src: ['./src/**/*.+(coffee|litcoffee)']
      options:
        output: 'doc'
        layout: 'linear'

    concurrent:
      build: ['compile', 'doc']

  grunt.registerTask 'compile', ['clean:compile', 'coffee']
  grunt.registerTask 'doc', ['clean:doc', 'docco']
  grunt.registerTask 'build', ['concurrent:build']
