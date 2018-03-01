fs = require 'fs'

_ = require 'lodash'
MarkdownIt = require 'markdown-it'
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

    orderItems: (items, order) ->
        ###
        Orders items using the given ordering
        ###
        if _.startsWith(order, '-')
            cleanOrder = order.slice 1, order.length
            return _.reverse(_.orderBy(items, [cleanOrder]))
        return _.orderBy(items, [order])

    filter: (filters) ->
        @query.filters = filters
        return @

    limit: (n) ->
        @query.limit = n
        return @

    summary: (string, length) ->
        ###
        Creates a summary of a string of the given length
        ###
        summary = _.words(string, /[^,\n ]+/g).splice(0, length)
        if _.last(summary) == '##'
            summary = _.take(summary, summary.length - 1)
        return summary.join(' ')

    markDownEngine: ->
        return new MarkdownIt()

    markDown: (string, replace) ->
        if replace
            string = string.replace /---/, ""
        markdown = @markDownEngine()
        return markdown.render string

    frontMatter: (string) ->
        ###
        Transforms a string into a front matter object
        ###
        frontMatter = Matter(string, {excerpt: true})
        html = @markDown frontMatter.content
        summary = @markDown @summary(frontMatter.content, 40), true
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

        if @query.filters
            items = _.filter(items, @query.filters)

        if @query.order
            items = @orderItems(items, @query.order)

        if @query.one
            return items[0]

        if @query.limit
            return _.slice(items, 0, @query.limit)
        return items

module.exports = Content
