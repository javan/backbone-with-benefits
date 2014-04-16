module.exports = (grunt) ->
  grunt.loadNpmTasks("grunt-contrib-nodeunit")
  grunt.loadNpmTasks("grunt-contrib-uglify")
  grunt.loadNpmTasks("grunt-contrib-coffee")
  grunt.loadNpmTasks("grunt-banner")

  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")

    banner:"""
      // Backbone with Benefits <%= pkg.version %> (<%= pkg.homepage %>)
      // Copyright (c) 2014 <%= pkg.author %>
      // MIT license (http://opensource.org/licenses/MIT)
    """

    nodeunit:
      all: ["test/test*.coffee"]

    uglify:
      build:
        src: "./<%= pkg.name %>.js",
        dest: "./<%= pkg.name %>.min.js"

    coffee:
      glob_to_multiple:
        expand: true
        flatten: true
        cwd: "src/"
        src: ["*.coffee"]
        dest: "./"
        ext: ".js"

    usebanner:
      dist:
        options:
          banner: "<%= banner %>"
        files:
          src: "backbone-with-benefits*.js"

  grunt.registerTask "default", ["nodeunit:all"]
  grunt.registerTask "dist", ["coffee", "uglify", "usebanner"]
