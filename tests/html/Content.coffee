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

    it 'should have a content method', ->
        result = @content.content('newpath')
        Chai.expect(@content.path).to.be.eql('newpath')
        Chai.expect(result).to.be.eql(@content)

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

    it 'should have a frontMatter method', ->
        string = '---\ntitle: test\n---\ncontent.'
        result = @content.frontMatter(string)
        Chai.expect(result).to.be.eql({title: 'test', content: 'content.'})

    it 'should have a fetch method', ->
        Td.replace(Files, 'find')
        Td.replace(fs, 'readFileSync')
        Td.replace(@content, 'frontMatter')
        Td
            .when(Files.find(@content.path, '.md'))
            .thenReturn(['one.md'])
        Td
            .when(fs.readFileSync('one.md', 'utf-8'))
            .thenReturn('')
        Td
            .when(@content.frontMatter(''))
            .thenReturn({content: ''})
        result = @content.fetch()
        Chai.expect(result).to.be.eql([{content: ''}])

    describe 'the get method', ->
        beforeEach ->
            @items = [{title: 'one'}, {title: 'two'}, {title: 'three'}]
            Td.replace(@content, 'fetch')
            Td
                .when(@content.fetch())
                .thenReturn(@items)

        it 'should be able to return all items', ->
            result = @content.get()
            Chai.expect(result).to.be.eql(@items)

        it 'should be able to return ordered items', ->
            @content.query.order = 'title'
            result = @content.get()
            Chai.expect(result).to.be.eql([@items[0], @items[2], @items[1]])

        it 'should be able to return n items', ->
            @content.query.limit = 2
            result = @content.get()
            Chai.expect(result).to.be.eql([@items[0], @items[1]])

        it 'should be able to return one item', ->
            @content.query.one = true
            result = @content.get()
            Chai.expect(result).to.be.eql(@items[0])

    afterEach ->
        Td.reset()
