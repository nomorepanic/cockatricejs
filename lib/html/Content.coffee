fs = require 'fs'

_ = require 'lodash'
Markdown = require 'markdown'
Matter = require 'gray-matter'

Files = require '../Files'


class Content

    constructor: (@path) ->
        @query = {}

    content: (path) ->
        ###
        Provides a way to change the path, useful for templates
        ###
        @path = path
        return  @

    one: ->
        @query.one = true
        return @

    all: ->
        @query.one = false
        return @

    order: (key) ->
        @query.order = key
        return @

    limit: (n) ->
        @query.limit = n
        return @

    frontMatter: (string) ->
        ###
        Transforms a string into a front matter object
        ###
        frontMatter = Matter(string, {excerpt: true})
        html = Markdown.markdown.toHTML frontMatter.content
        summary = Markdown.markdown.toHTML frontMatter.excerpt
        frontMatter.data.content = html
        frontMatter.data.summary = summary
        return frontMatter.data

    fetch: ->
        ###
        Fetches front matter data from files
        ###
        files = Files.find @path, '.md'
        items = []
        cls = @
        read = (file) ->
            data = fs.readFileSync file, 'utf-8'
            items.push(cls.frontMatter(data))
        read file for file in files
        return items

    get: ->
        items = @fetch()

        if @query.order
            items = _.orderBy(items, [@query.order])

        if @query.one
            return items[0]

        if @query.limit
            return _.slice(items, 0, @query.limit)
        return items

module.exports = Content
