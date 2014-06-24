'use strict'

module.exports = (grunt) ->
  # Configurations
  # -----
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    clean:
      compile: [ './lib' ]
      doc: [ './doc' ]
    coffee:
      compile:
        files: [
          expand: true
          cwd: './src'
          src: [ './**/*.+(coffee|litcoffee)' ]
          dest: './lib'
          ext: '.js'
          extDot: 'last'
        ]
    watch:
      changed:
        files: [ 'src/**/*.+(coffee|litcoffee)' ]
        tasks: [ 'coffee' ]
        options:
          atBegin: true
          event: [ 'changed', 'added' ]
      deleted:
        files: [ 'src/**/*.+(coffee|litcoffee)' ]
        tasks: [ 'compile' ]
        options:
          atBegin: true
          event: [ 'deleted' ]
    mochaTest:
      test:
        src: [ './test/**/*Spec.+(coffee|litcoffee)' ]
      options:
        require: 'coffee-script/register'
        reporter: 'nyan'
    docco:
      compile:
        src: [ './src/**/*.+(coffee|litcoffee)' ]
      options:
        output: 'doc'
    concurrent:
      build: [ 'compile', 'doc' ]

  # Package Tasks
  # -----
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-mocha-test'
  grunt.loadNpmTasks 'grunt-docco'
  grunt.loadNpmTasks 'grunt-concurrent'

  # Custom Tasks
  # -----
  grunt.registerTask 'compile', [ 'clean:compile', 'coffee' ]
  grunt.registerTask 'doc', [ 'clean:doc', 'docco' ]
  grunt.registerTask 'build', [ 'concurrent:build' ]
  grunt.registerTask 'test', [ 'compile', 'mochaTest' ]
