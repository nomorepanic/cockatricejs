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
