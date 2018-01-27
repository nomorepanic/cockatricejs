fs = require 'fs'

Chai = require 'chai'
Sass = require 'node-sass'
Td = require 'testdouble'

Stylesheets = require '../../lib/styles/Stylesheets'


describe 'the Stylesheets module', ->
    beforeEach ->
        @expect = Chai.expect
        @anything = Td.matchers.anything()
        @file = 'sass/test.scss'
        @output = 'dist/output.css'
        @stylesheets = new Stylesheets @file, @output

    it 'should have a constructor method', ->
        @expect(@stylesheets.file).to.eq(@file)
        @expect(@stylesheets.output).to.eq(@output)

    it 'should have a compile method', ->
        Td.replace(fs, 'writeFile')
        Td.replace(Sass, 'render')
        Td
            .when(Sass.render(@anything))
            .thenCallback(null, {'css': 'compiledcss'})
        @stylesheets.compile()
        Td.verify(Sass.render({@file}, @anything))
        Td.verify(fs.writeFile(@output, 'compiledcss', @anything))
