fs = require 'fs'

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

    order: ->
        @query.order = 'key'
        return @

    fetch: ->
        ###
        Fetches front matter data from files
        ###
        files = Files.find @path, '.md'
        items = @data
        read = (file) ->
            fs.readFile file, 'utf-8', (error, data) ->
                items.push(Matter(data))
        read file for file in files

    get: ->
        items = @fetch()
        if @query.one
            return items[0]
        return items



module.exports = Content
