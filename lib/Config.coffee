fs = require 'fs'

Toml = require 'toml'

Files = require './Files'


class Config

    @parse: (configFile) ->
        data = fs.readFileSync configFile, 'utf-8'
        return Toml.parse(data)


module.exports = Config
