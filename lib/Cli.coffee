Commander = require 'commander'

FrontMatter = require './FrontMatter'
Stylesheets = require './Stylesheets'


class Cli
    @compile: ->
        Commander
            .command('compile <what> <target> <output>')
            .option('-i, --input [input]')
            .action (what, target, output, options) ->
                app = new FrontMatter target, options.input, output
                app.makePages()

    @lint: ->
        Commander
            .command('lint [what]')
            .action (what) ->

    @build: ->
        Commander
            .command('build [what]')
            .action (what) ->

    @test: ->
        Commander
            .command('test [what]')
            .action (what) ->

    @dist: ->
        Commander
            .command('dist [what]')
            .action (what) ->

    @main: ->
        Cli.compile()
        Cli.lint()
        Cli.build()
        Cli.test()
        Cli.dist()
        Commander.parse(process.argv)

module.exports = Cli