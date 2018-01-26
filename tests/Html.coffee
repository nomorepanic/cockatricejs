Chai = require 'chai'
Pug = require 'pug'
Td = require 'testdouble'

Html = require '../lib/Html'


describe 'the Html module', ->

    it 'should have a constructor', ->
        html = new Html('engine')
        Chai.expect(html.engine).to.be.eql('engine')

    it 'should have a compile method', ->
        Td.replace(Pug, 'compileFile')
        compile = Td.function()
        Td
            .when(Pug.compileFile('template.pug'))
            .thenReturn({compile: compile})
        Td
            .when(compile('data'))
            .thenReturn('compiled-html')
        html = new Html('pug')
        result = html.compile('template.pug', 'data')
        Chai.expect(result).to.be.eql('compiled-html')
