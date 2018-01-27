Chai = require 'chai'
Pug = require 'pug'
Td = require 'testdouble'

Engines = require '../../lib/html/Engines'


describe 'the Engines module', ->

    it 'should have a constructor', ->
        engine = new Engines('engine')
        Chai.expect(engine.engine).to.be.eql('engine')

    it 'should have a compile method', ->
        Td.replace(Pug, 'compileFile')
        compile = Td.function()
        Td
            .when(Pug.compileFile('template.pug'))
            .thenReturn({compile: compile})
        Td
            .when(compile('data'))
            .thenReturn('compiled-html')
        engines = new Engines('pug')
        result = engines.compile('template.pug', 'data')
        Chai.expect(result).to.be.eql('compiled-html')
