fs = require 'fs'

Chai = require 'chai'
Td = require 'testdouble'
Toml = require 'toml'

Config = require '../lib/Config'


describe 'the Config module', ->
    it 'should parse a toml configuration file', ->
        Td.replace fs, 'readFileSync'
        Td.replace Toml, 'parse'
        Td
            .when(fs.readFileSync('cockatrice.toml', 'utf-8'))
            .thenReturn('title = "Cockatrice"')
        Td
            .when(Toml.parse('title = "Cockatrice"'))
            .thenReturn({title: 'Cockatrice'})
        result = Config.parse 'cockatrice.toml'
        Chai.expect(result).to.be.eql({title: 'Cockatrice'})
