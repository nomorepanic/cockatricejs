Commander = require 'commander'
Td = require 'testdouble'

Cli = require '../lib/Cli'


describe 'the Cli module', ->
    it 'should have a compile method', ->
        command = Td.object()
        Td.replace(Commander, 'command')
        Td
            .when(Commander.command('compile <what> <target> <output>'))
            .thenReturn(command)
        Td
            .when(command.option('-i, --input [input]'))
            .thenReturn(command)
        Cli.compile()
        Td.verify(command.action(Td.matchers.anything()))

    it 'should have a lint command', ->
        command = Td.object()
        Td.replace(Commander, 'command')
        Td
            .when(Commander.command('lint [what]'))
            .thenReturn(command)
        Cli.lint()
        Td.verify(command.action(Td.matchers.anything()))

    it 'should have a build command', ->
        command = Td.object()
        Td.replace(Commander, 'command')
        Td
            .when(Commander.command('build [what]'))
            .thenReturn(command)
        Cli.build()
        Td.verify(command.action(Td.matchers.anything()))

    it 'should have a test command', ->
        command = Td.object()
        Td.replace(Commander, 'command')
        Td
            .when(Commander.command('test [what]'))
            .thenReturn(command)
        Cli.test()
        Td.verify(command.action(Td.matchers.anything()))

    it 'should have a dist command', ->
        command = Td.object()
        Td.replace(Commander, 'command')
        Td
            .when(Commander.command('dist [what]'))
            .thenReturn(command)
        Cli.dist()
        Td.verify(command.action(Td.matchers.anything()))

    it 'should have a version command', ->
        command = Td.object()
        Td.replace(Commander, 'command')
        Td
            .when(Commander.command('version'))
            .thenReturn(command)
        Cli.version()
        Td.verify(command.action(Td.matchers.anything()))

    it 'should have a main method', ->
        Td.replace(Commander, 'parse')
        Td.replace(Cli, 'compile')
        Td.replace(Cli, 'lint')
        Td.replace(Cli, 'build')
        Td.replace(Cli, 'test')
        Td.replace(Cli, 'dist')
        Td.replace(Cli, 'version')
        Cli.main()
        Td.verify(Cli.compile())
        Td.verify(Cli.build())
        Td.verify(Cli.dist())
        Td.verify(Cli.version())
        Td.verify(Commander.parse(process.argv))

    afterEach ->
        Td.reset()
