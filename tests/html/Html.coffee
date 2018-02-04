fs = require 'fs'

Chai = require 'chai'
Td = require 'testdouble'

Files = require '../../lib/Files'
Content = require '../../lib/html/Content'
Engines = require '../../lib/html/Engines'
Html = require '../../lib/html/Html'


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

    it 'should have a getContent method', ->
        @expect(@html.getContent('file.md')).to.be.an.instanceof(Content)

    it 'should compile a template', ->
        compile = Td.function()
        one = Td.function()
        get = Td.function()
        Td.replace(@html, 'engine')
        Td.replace(@html, 'getContent')
        Td.replace(fs, 'writeFile')
        Td.when(@html.getContent('front.md')).thenReturn({one: one})
        Td.when(one()).thenReturn({get: get})
        Td.when(get()).thenReturn({})
        Td.when(@html.engine('pug')).thenReturn({compile: compile})
        Td.when(compile(@template, {})).thenReturn('html')
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
