Pug = require 'pug'


class Engines
    ###
    Handles html templating engines and compilation to html
    ###
    constructor: (@engine) ->

    compile: (template, data) ->
        if @engine == 'pug'
            Pug.compileFile(template).compile(data)

module.exports = Engines
