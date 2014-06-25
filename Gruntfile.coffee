'use strict'

module.exports = (grunt) ->
  # Configurations
  # -----
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    clean:
      compile: [ 'lib' ]
      doc: [ 'doc' ]
      coverage: [ 'coverage' ]
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
    mkdir:
      test:
        options:
          create: [ 'test' ]
      coverage:
        options:
          create: [ 'coverage' ]
    mochacli:
      spec:
        options:
          reporter: 'spec'
      nyan:
        options:
          reporter: 'nyan'
      coverage:
        options:
          reporter: 'html-cov'
          save: 'coverage/index.html'
      options:
        files: [ 'test/**/*Spec.+(coffee|litcoffee)' ]
        compilers: [ 'coffee:coffee-script/register' ]
        require: [ 'coffee-script/register', 'blanket' ]
    docco:
      compile:
        src: [ './src/**/*.+(coffee|litcoffee)' ]
      options:
        output: 'doc'
        layout: 'linear'
    concurrent:
      build: [ 'compile', 'doc' ]
      test: [ 'mochacli:spec', 'coverage' ]

  # Package Tasks
  # -----
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-mkdir'
  grunt.loadNpmTasks 'grunt-mocha-cli'
  grunt.loadNpmTasks 'grunt-docco'
  grunt.loadNpmTasks 'grunt-concurrent'

  # Custom Tasks
  # -----
  grunt.registerTask 'compile', [ 'clean:compile', 'coffee' ]
  grunt.registerTask 'doc', [ 'clean:doc', 'docco' ]
  grunt.registerTask 'build', [ 'concurrent:build' ]
  grunt.registerTask 'coverage', [ 'clean:coverage', 'mkdir:test', 'mkdir:coverage', 'mochacli:coverage' ]
  grunt.registerTask 'nyan', [ 'mkdir:test', 'mochacli:nyan' ]
  grunt.registerTask 'test', [ 'mkdir:test', 'concurrent:test' ]
