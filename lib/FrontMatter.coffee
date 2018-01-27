fs = require 'fs'
path = require 'path'

Matter = require 'gray-matter'

Files = require './Files'
Html = require './Html'


class FrontMatter
    constructor: (@template, @content, @output) ->

    html: (engine) ->
        ###
        Create the html engine
        ###
        return new Html(engine)

    compile: (file) ->
        ###
        Compiles the given template to html with markdown data
        ###
        html_engine = @html('pug')
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

module.exports = FrontMatter
