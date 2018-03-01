fs = require 'fs'

Chai = require 'chai'
Td = require 'testdouble'
MarkdownIt = require 'markdown-it'
Matter = require 'gray-matter'


Content = require '../../lib/html/Content'
Files = require '../../lib/Files'


describe 'the Content module', ->
    beforeEach ->
        @content = new Content 'path'
        @items = [{title: 'zero'}, {title: 'one'}, {title: 'two'}]

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


    it 'should have a filter method', ->
        result = @content.filter({'key': 'value'})
        Chai.expect(@content.query.filters).to.be.eql({'key': 'value'})
        Chai.expect(result).to.be.eql(@content)

    describe 'the orderItems method', ->
        it 'should be able to order items ascending', ->
            result = @content.orderItems(@items, 'title')
            Chai.expect(result).to.be.eql([@items[1], @items[2], @items[0]])

        it 'should be able to order items descending', ->
            result = @content.orderItems(@items, '-title')
            Chai.expect(result).to.be.eql([@items[0], @items[2], @items[1]])

    it 'should have a limit method', ->
        result = @content.limit(3)
        Chai.expect(@content.query.limit).to.be.eql(3)
        Chai.expect(result).to.be.eql(@content)

    describe 'the summary method', ->
        it 'should split a string at a given length', ->
            summary = @content.summary('## break me not\n\nparagraph', 4)
            Chai.expect(summary).to.be.eql('## break me not')

        it 'should remove trailing headings', ->
            summary = @content.summary('## break me ## not\n\nparagraph', 4)
            Chai.expect(summary).to.be.eql('## break me')

    it 'should have markdownEngine method', ->
        engine = @content.markDownEngine()
        Chai.expect(engine).to.be.an.instanceof(MarkdownIt)

    describe 'the markDown method', ->
        beforeEach ->
            Td.replace @content, 'markDownEngine'
            render = Td.function()
            Td
                .when(@content.markDownEngine())
                .thenReturn({render: render})
            Td
                .when(render('string'))
                .thenReturn('html')

        it 'should parse markdown', ->
            result = @content.markDown('string')
            Chai.expect(result).to.be.eql('html')

        it 'should replace characters when requested', ->
            result = @content.markDown('string---', true)
            Chai.expect(result).to.be.eql('html')

    it 'should have a frontMatter method', ->
        Td.replace @content, 'markDown'
        Td
            .when(@content.markDown('summary\n---\ncontent'))
            .thenReturn('html')
        Td
            .when(@content.markDown('summary\n', true))
            .thenReturn('summary')
        string = '---\ntitle: test\n---\nsummary\n---\ncontent'
        result = @content.frontMatter(string)
        expected = {title: 'test', content: 'html', summary: 'summary'}
        Chai.expect(result).to.be.eql(expected)

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
            Td.replace(@content, 'fetch')
            Td
                .when(@content.fetch())
                .thenReturn(@items)

        it 'should be able to return all items', ->
            result = @content.get()
            Chai.expect(result).to.be.eql(@items)

        it 'should  order items when necessary', ->
            @content.query.order = 'title'
            Td.replace(@content, 'orderItems')
            Td
                .when(@content.orderItems(@items, @content.query.order))
                .thenReturn(['ordered'])
            result = @content.get()
            Chai.expect(result).to.be.eql(['ordered'])

        it 'should be able to return n items', ->
            @content.query.limit = 2
            result = @content.get()
            Chai.expect(result).to.be.eql([@items[0], @items[1]])

        it 'should filter items', ->
            @content.query.filters = {'title': 'one'}
            result = @content.get()
            Chai.expect(result).to.be.eql([@items[1]])

        it 'should be able to return one item', ->
            @content.query.one = true
            result = @content.get()
            Chai.expect(result).to.be.eql(@items[0])

    afterEach ->
        Td.reset()
