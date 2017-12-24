fs = require 'fs'

Sass = require 'node-sass'


class Stylesheets
    constructor: (@file, @output) ->

    compile: ->
        Sass.render {@file}, (error, result) =>
            fs.writeFile @output, result.css, (innerError) -> true

module.exports = Stylesheets
