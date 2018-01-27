fs = require 'fs'
path = require 'path'


class Files

    @isDirectory: (path) ->
        return fs.lstatSync(path).isDirectory()

    @filter: (file, extension) ->
        if path.extname(file) == extension
            return file

module.exports = Files
