Commander = require 'commander'

Handler = require './Handler'


class Cli
    @compile: ->
        Commander
            .command('compile <what> <target> <output>')
            .option('-i, --input [input]')
            .action (what, target, output, options) ->
                Handler.compile what, target, output, options

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

    @version: ->
        Commander
            .command('version')
            .action () ->
                console.log 'Cockatrice version 0.0.10'

    @main: ->
        Cli.compile()
        Cli.lint()
        Cli.build()
        Cli.test()
        Cli.dist()
        Cli.version()
        Commander.parse(process.argv)

module.exports = Cli
