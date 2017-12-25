App = require '../lib/App'


describe 'the App module', ->
    it 'should have a run method', ->
        App.run('action', [])
