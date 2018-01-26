fs = require 'fs'
path = require 'path'

Matter = require 'gray-matter'
Pug = require 'pug'

Html = require './Html'

class FrontMatter
    constructor: (@template, @content, @output) ->

    @findFiles: (contentPath) ->
        ###
        Finds markdown files
        ###
        markdowns = []
        files = fs.readdirSync(contentPath)
        push = (file) ->
            if path.extname(file) == '.md'
                markdowns.push(path.join(contentPath, file))
        push file for file in files
        return markdowns

    html: (engine) ->
        ###
        Create the html engine
        ###
        return new Html(engine)

    compile: (file) ->
        ###
        Compiles the given template to html with markdown data
        ###
        compiler = Pug.compileFile(@template)
        fs.readFile file, 'utf-8', (error, data) =>
            front = Matter(data)
            front.data.content = front.content
            html = compiler(front.data)
            page = path.parse(file).name
            outputPath = path.join(@output, "#{ page }.html")
            fs.writeFile outputPath, html, (innerError) -> true


    makePages: ->
        ###
        Builds html pages agains the given path
        ###
        files = FrontMatter.findFiles(@content)
        @compile file for file in files

module.exports = FrontMatter
