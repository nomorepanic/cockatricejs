fs = require 'fs'

_ = require 'lodash'
Matter = require 'gray-matter'

Files = require '../Files'


class Content

    constructor: (@path) ->
        @query = {}
        @data = []

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
        frontMatter = Matter(string)
        frontMatter.data.content = frontMatter.content
        return frontMatter.data

    fetch: ->
        ###
        Fetches front matter data from files
        ###
        files = Files.find @path, '.md'
        content = @
        read = (file) ->
            fs.readFile file, 'utf-8', (error, data) ->
                content.data.push(content.frontMatter(data))
        read file for file in files

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
