Pug = require 'pug'


class Engines
    ###
    Handles html templating engines and compilation to html
    ###
    constructor: (@engine) ->

    compile: (template, data) ->
        if @engine == 'pug'
            pug = Pug.compileFile(template)
            return pug(data)

module.exports = Engines
