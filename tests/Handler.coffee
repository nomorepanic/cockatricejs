Td = require 'testdouble'

Chai = require 'chai'

FrontMatter = require '../lib/FrontMatter'
Handler = require '../lib/Handler'
Stylesheets = require '../lib/Stylesheets'


describe 'the Handler module', ->

    it 'should have a frontMatter method', ->
        result = Handler.frontMatter 'target', 'input', 'output'
        Chai.expect(result).to.be.an.instanceof(FrontMatter)
        Chai.expect(result.template).to.eql('target')
        Chai.expect(result.content).to.eql('input')
        Chai.expect(result.output).to.eql('output')

    it 'should have a stylesheets method', ->
        result = Handler.stylesheets 'file', 'output'
        Chai.expect(result).to.be.an.instanceof(Stylesheets)
        Chai.expect(result.file).to.eql('file')
        Chai.expect(result.output).to.eql('output')

    it 'should have a compile method', ->
        Td.replace Handler, 'frontMatter'
        makePages = Td.function()
        Td
            .when(Handler.frontMatter('target', 'input', 'output'))
            .thenReturn({makePages: makePages})
        Handler.compile 'pug', 'target', 'output', {input: 'input'}
        Td.verify(makePages())
