fs = require 'fs'

Chai = require 'chai'
Td = require 'testdouble'

Content = require '../../lib/html/Content'


describe 'the Content module', ->
    beforeEach ->
        @content = new Content 'path'

    it 'should have a path property', ->
        Chai.expect(@content.path).to.be.eql('path')
        Chai.expect(@content.query).to.be.eql({})

    it 'should have a one method', ->
        result = @content.one()
        Chai.expect(@content.query.one).to.be.eql(true)
        Chai.expect(result).to.be.eql(@content)

    it 'should have an all method', ->
        result = @content.all()
        Chai.expect(@content.query.one).to.be.eql(false)
        Chai.expect(result).to.be.eql(@content)

    afterEach ->
      Td.reset()
