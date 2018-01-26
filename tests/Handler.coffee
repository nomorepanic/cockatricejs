Td = require 'testdouble'

Chai = require 'chai'

FrontMatter = require '../lib/FrontMatter'
Handler = require '../lib/Handler'


describe 'the Handler module', ->

    it 'should have a frontMatter method', ->
        result = Handler.frontMatter 'target', 'input', 'output'
        Chai.expect(result).to.be.an.instanceof(FrontMatter)
        Chai.expect(result.template).to.eql('target')
        Chai.expect(result.content).to.eql('input')
        Chai.expect(result.output).to.eql('output')
