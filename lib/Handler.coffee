FrontMatter = require './FrontMatter'


class Handler
    # Handles cli operations

    @frontMatter: (target, input, output) ->
        return new FrontMatter target, input, output

    @compile: (what, target, output, options) ->
        frontmatter = Handler.frontMatter target, options.input, output
        frontmatter.makePages()

module.exports = Handler
