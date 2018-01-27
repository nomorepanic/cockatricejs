Matter = require 'gray-matter'

Files = require '../Files'


class Content

    constructor: (@path) ->
        @query = {}

    one: ->
        @query.one = true
        return @

    all: ->
        @query.one = false
        return @

module.exports = Content
