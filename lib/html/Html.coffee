fs = require 'fs'
path = require 'path'

Files = require '../Files'
Content = require './Content'
Engines = require './Engines'


class Html
    constructor: (@template, @content, @output) ->

    engine: (engine) ->
        ###
        Create the html engine
        ###
        return new Engines(engine)

    getContent: (file) ->
        return new Content(file)

    compile: (file) ->
        ###
        Compiles the given template to html with markdown data
        ###
        html_engine = @engine('pug')
        data = @getContent(file).one().get()
        content = @getContent('content')
        html = html_engine.compile(@template, {page: data, content: content})
        page = path.parse(file).name
        outputPath = path.join(@output, "#{ page }.html")
        fs.writeFile outputPath, html, (innerError) -> true

    makePages: ->
        ###
        Builds html pages against the given path
        ###
        files = Files.find(@content, '.md')
        @compile file for file in files

module.exports = Html
