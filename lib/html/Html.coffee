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

    getUrl: (page, filename, outputPath) ->
        ###
        Produces the output path for a file (and hence its url).
        ###
        page_url = path.parse(filename).name
        if page._url
            page_url = page._url
        return path.join(outputPath, "#{ page_url }.html")

    compile: (file) ->
        ###
        Compiles the given template to html with markdown data
        ###
        html_engine = @engine('pug')
        page = @getContent(file).one().get()
        content = @getContent('content')
        html = html_engine.compile(@template, {page: page, content: content})
        outputFilename = @getUrl(page, file, @output)
        fs.writeFile outputFilename, html, (innerError) -> true

    makePages: ->
        ###
        Builds html pages against the given path
        ###
        files = Files.find(@content, '.md')
        @compile file for file in files

module.exports = Html
