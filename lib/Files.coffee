fs = require 'fs'


class Files

    @isDirectory: (path) ->
        return fs.lstatSync(path).isDirectory()

module.exports = Files
