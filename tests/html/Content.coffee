fs = require 'fs'

Chai = require 'chai'
Td = require 'testdouble'
Matter = require 'gray-matter'


Content = require '../../lib/html/Content'
Files = require '../../lib/Files'


describe 'the Content module', ->
    beforeEach ->
        @content = new Content 'path'

    it 'should have a path property', ->
        Chai.expect(@content.path).to.be.eql('path')
        Chai.expect(@content.query).to.be.eql({})
        Chai.expect(@content.data).to.be.eql([])

    it 'should have a one method', ->
        result = @content.one()
        Chai.expect(@content.query.one).to.be.eql(true)
        Chai.expect(result).to.be.eql(@content)

    it 'should have an all method', ->
        result = @content.all()
        Chai.expect(@content.query.one).to.be.eql(false)
        Chai.expect(result).to.be.eql(@content)

    it 'should have an order method', ->
        result = @content.order('key')
        Chai.expect(@content.query.order).to.be.eql('key')
        Chai.expect(result).to.be.eql(@content)

    it 'should have a limit method', ->
        result = @content.limit(3)
        Chai.expect(@content.query.limit).to.be.eql(3)
        Chai.expect(result).to.be.eql(@content)

    it 'should have a fetch method', ->
        Td.replace(fs, 'readFile')
        Td.replace(Files, 'find')
        Td
            .when(fs.readFile('one.md', 'utf-8'))
            .thenCallback(null, '')
        Td
            .when(Files.find(@content.path, '.md'))
            .thenReturn(['one.md'])
        @content.fetch()
        Chai.expect(@content.data).to.be.an('array').to.have.lengthOf(1)

    describe 'the get method', ->
        beforeEach ->
            @items = [{data: {title: 'one'}}]
            Td.replace(@content, 'fetch')
            Td
                .when(@content.fetch())
                .thenReturn(@items)

        it 'should be able to return items', ->
            result = @content.get()
            Chai.expect(result).to.be.eql(@items)

        it 'should be able to return one item', ->
            @content.query.one = true
            result = @content.get()
            Chai.expect(result).to.be.eql(@items[0])


    afterEach ->
      Td.reset()
