fs = require 'fs'
path = require 'path'


class Files

    @isDirectory: (path) ->
        return fs.lstatSync(path).isDirectory()

    @filter: (file, extension) ->
        if path.extname(file) == extension
            return file

    @findMany: (basePath, files, extension) ->
        results = []
        push = (file) ->
            if file
                results.push(path.join(basePath, file))
        push Files.filter file, extension for file in files
        return results

    @find: (basePath, extension) ->
        ###
        Finds files in given path that match the extension
        ###
        if Files.isDirectory(basePath)
            files = fs.readdirSync(basePath)
            return Files.findMany(basePath, files, extension)
        return [Files.filter(basePath, extension)]

module.exports = Files
