fs = require 'fs'
path = require 'path'

Matter = require 'gray-matter'
Pug = require 'pug'


class FrontMatter
    constructor: (@template, @content, @output) ->

    @findFiles: (contentPath) ->
        markdowns = []
        files = fs.readdirSync(contentPath)
        push = (file) ->
            if path.extname(file) == '.md'
                markdowns.push(path.join(contentPath, file))
        push file for file in files
        return markdowns

    compile: (file) ->
        compiler = Pug.compileFile(@template);
        fs.readFile file, 'utf-8', (error, data) =>
            front = Matter(data)
            front.data.content = front.content
            html = compiler(front.data)
            page = path.parse(file).name
            outputPath = path.join(@output, "#{ page }.html")
            fs.writeFile outputPath, html, (innerError) => true


    makePages: ->
        files = FrontMatter.findFiles(@content);
        @compile file for file in files

module.exports = FrontMatter
