FrontMatter = require './FrontMatter'
Stylesheets = require './Stylesheets'


class Handler
    # Handles cli operations

    @frontMatter: (target, input, output) ->
        return new FrontMatter target, input, output

    @stylesheets: (target, output) ->
        return new Stylesheets target, output

    @compile: (what, target, output, options) ->
        if what == 'pug'
            frontmatter = Handler.frontMatter target, options.input, output
            frontmatter.makePages()
        else if what == 'scss'
            stylesheets = Handler.stylesheets target, output
            stylesheets.compile()

module.exports = Handler
