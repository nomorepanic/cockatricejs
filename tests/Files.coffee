fs = require 'fs'

Chai = require 'chai'
Td = require 'testdouble'

Files = require '../lib/Files'


describe 'the Files module', ->
    it 'should have an isDirectory function', ->
        isDirectory = Td.function()
        Td.replace(fs, 'lstatSync')
        Td
            .when(fs.lstatSync('path'))
            .thenReturn({isDirectory: isDirectory})
        Td
            .when(isDirectory())
            .thenReturn('answer')
        result = Files.isDirectory('path')
        Chai.expect(result).to.be.eql('answer')

    describe 'the filter method', ->

        it 'should return files with the correct extension', ->
            Chai.expect(Files.filter('test.md', '.md')).to.be.eql('test.md')

        it 'should ignore files with wrong extension', ->
            Chai.expect(Files.filter('test.rst', '.md')).to.be.eql(undefined)

    describe 'the find function', ->

        beforeEach ->
            Td.replace(Files, 'isDirectory')

        it 'should return files from a directory', ->
            Td.replace(Files, 'findMany')
            Td.replace(fs, 'readdirSync')
            Td
                .when(Files.isDirectory('folder'))
                .thenReturn(true)
            Td
                .when(Files.findMany('folder', ['files'], '.md'))
                .thenReturn(['results'])

            Td
                .when(fs.readdirSync('folder'))
                .thenReturn(['files'])
            results = Files.find('folder', '.md')
            Chai.expect(results).to.be.eql(['results'])

        it 'should return a single file', ->
            Td.replace(Files, 'filter')
            Td.when(Files.isDirectory('one.md')).thenReturn(false)
            Td.when(Files.filter('one.md', '.md')).thenReturn('filtered')
            result = Files.find('one.md', '.md')
            Chai.expect(result).to.be.eql('filtered')

    it 'should have a findMany function', ->
        Td.replace(Files, 'filter')
        Td
            .when(Files.filter('one.md', '.md'))
            .thenReturn('one.md')
        results = Files.findMany('content', ['one.md', 'two.rst'], '.md')
        Chai.expect(results).to.be.eql(['content/one.md'])

    afterEach ->
        Td.reset()
