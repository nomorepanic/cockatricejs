fs = require 'fs'

Sass = require 'sass'


class Stylesheets
    constructor: (@file, @output) ->

    compile: ->
        Sass.render {@file, indentedSyntax: true}, (error, result) =>
            fs.writeFile @output, result.css, (innerError) -> true

module.exports = Stylesheets
