Commander = require 'commander'

FrontMatter = require './FrontMatter'


class Cli
    @compile: ->
        Commander
            .command('compile <template> <content> <output>')
            .action (template, content, output) ->
                app = new FrontMatter template, content, output
                app.makePages()

    @main: ->
        Cli.compile()
        Commander.parse(process.argv)

module.exports = Cli
