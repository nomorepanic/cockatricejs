fs = require 'fs'

Chai = require 'chai'
Pug = require 'pug'
Td = require 'testdouble'

FrontMatter = require '../lib/FrontMatter.coffee'


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

    it 'should parse a directory', ->
        files = ['one.md', 'two.md', 'three.yml']
        Td.replace(fs, 'readdirSync')
        Td
            .when(fs.readdirSync(@anything))
            .thenReturn(files)
        result = FrontMatter.findFiles('path')
        @expect(result).to.eql(['path/one.md', 'path/two.md'])

    it 'should compile a template', ->
        compiler = Td.function()
        Td.replace(Pug, 'compileFile')
        Td.replace(fs, 'writeFile')
        Td.replace(fs, 'readFile')
        Td.when(compiler(@anything)).thenReturn('html')
        Td.when(Pug.compileFile(@template)).thenReturn(compiler)
        Td.when(fs.readFile(@anything, @anything)).thenCallback(null, '')
        @front.compile('front.md')
        Td.verify(fs.writeFile('output/front.html', 'html', @anything))

    it 'should generate a page', ->
        Td.replace(@front, 'compile')
        Td.replace(FrontMatter, 'findFiles')
        Td
            .when(FrontMatter.findFiles(@content))
            .thenReturn(['test.md'])
        @front.makePages()
        Td.verify(@front.compile('test.md'))

    afterEach ->
        Td.reset()
