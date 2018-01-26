FrontMatter = require '../lib/FrontMatter.coffee'


class Handler

    @frontMatter: (target, input, output) ->
        return new FrontMatter target, input, output

module.exports = Handler
