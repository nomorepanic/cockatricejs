Pug = require 'pug'


class Html
    ###
    Handles html generation from various templating engines.
    ###
    constructor: (@engine) ->

    compile: (template, data) ->
        if @engine == 'pug'
            Pug.compileFile(template).compile(data)

module.exports = Html
