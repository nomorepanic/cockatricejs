fs = require 'fs'
path = require 'path'

Matter = require 'gray-matter'

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
        fs.readFile file, 'utf-8', (error, data) =>
            front = Matter(data)
            front.data.content = front.content
            html = html_engine.compile(@template, front.data)
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
