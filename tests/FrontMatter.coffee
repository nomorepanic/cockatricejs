fs = require 'fs'

Chai = require 'chai'
Td = require 'testdouble'

Files = require '../lib/Files'
FrontMatter = require '../lib/FrontMatter.coffee'
Html = require '../lib/Html'


describe 'the FrontMatter module', ->
    beforeEach ->
        @expect = Chai.expect
        @anything = Td.matchers.anything()
        @template = 'templates/test.pug'
        @content = 'content'
        @output = 'output'
        @front = new FrontMatter @template, @content, @output

    it 'should have a constructor method', ->
        @expect(@front.template).to.eql(@template)
        @expect(@front.content).to.eql(@content)
        @expect(@front.output).to.eql(@output)

    it 'should have an html method', ->
        html = @front.html('engine')
        @expect(html).to.be.an.instanceof(Html)
        @expect(html.engine).to.eql('engine')

    it 'should compile a template', ->
        compile = Td.function()
        Td.replace(@front, 'html')
        Td.replace(fs, 'writeFile')
        Td.replace(fs, 'readFile')
        Td.when(@front.html('pug')).thenReturn({compile: compile})
        Td.when(fs.readFile(@anything, @anything)).thenCallback(null, '')
        Td.when(compile(@template, {content: ''})).thenReturn('html')
        @front.compile('front.md')
        Td.verify(fs.writeFile('output/front.html', 'html', @anything))

    it 'should generate a page', ->
        Td.replace(@front, 'compile')
        Td.replace(Files, 'find')
        Td
            .when(Files.find(@content, '.md'))
            .thenReturn(['test.md'])
        @front.makePages()
        Td.verify(@front.compile('test.md'))

    afterEach ->
        Td.reset()
