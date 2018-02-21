Chai = require 'chai'
Td = require 'testdouble'

R = require 'replace'

Replace = require '../lib/Replace'


describe 'the Replace module', ->
    it 'should have a getReplacer method', ->
        Chai.expect(Replace.getReplacer()).to.be.eql(R)

    describe 'the replace method', ->
        it 'should use the replace library', ->
            replacer = Td.function()
            Td.replace(Replace, 'getReplacer')
            Td
                .when(Replace.getReplacer())
                .thenReturn(replacer)
            Replace.replace('path', 'regex', 'replacement')
            options = {
                regex: 'regex',
                replacement: 'replacement',
                paths: ['path'],
                recursive: true,
                silent: true
            }
            Td.verify(replacer(options))

        it 'should ensure a replacement is provided', ->
            Replace.replace('path', undefined, 'replacement')

    afterEach ->
        Td.reset()
