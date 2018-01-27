fs = require 'fs'

Chai = require 'chai'
Td = require 'testdouble'

Files = require '../../lib/Files'
Html = require '../../lib/html/Html'
Engines = require '../../lib/html/Engines'


describe 'the Html module', ->
    beforeEach ->
        @expect = Chai.expect
        @anything = Td.matchers.anything()
        @template = 'templates/test.pug'
        @content = 'content'
        @output = 'output'
        @html = new Html @template, @content, @output

    it 'should have a constructor method', ->
        @expect(@html.template).to.eql(@template)
        @expect(@html.content).to.eql(@content)
        @expect(@html.output).to.eql(@output)

    it 'should have an engine method', ->
        engine = @html.engine('engine')
        @expect(engine).to.be.an.instanceof(Engines)
        @expect(engine.engine).to.eql('engine')

    it 'should compile a template', ->
        compile = Td.function()
        Td.replace(@html, 'engine')
        Td.replace(fs, 'writeFile')
        Td.replace(fs, 'readFile')
        Td.when(@html.engine('pug')).thenReturn({compile: compile})
        Td.when(fs.readFile(@anything, @anything)).thenCallback(null, '')
        Td.when(compile(@template, {content: ''})).thenReturn('html')
        @html.compile('front.md')
        Td.verify(fs.writeFile('output/front.html', 'html', @anything))

    it 'should generate a page', ->
        Td.replace(@html, 'compile')
        Td.replace(Files, 'find')
        Td
            .when(Files.find(@content, '.md'))
            .thenReturn(['test.md'])
        @html.makePages()
        Td.verify(@html.compile('test.md'))

    afterEach ->
        Td.reset()
