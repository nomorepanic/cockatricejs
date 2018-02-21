R = require 'replace'

class Replace
    @getReplacer: ->
        return R

    @replace: (path, regex, replacement) ->
        if regex
            options = {
                regex: regex,
                replacement: replacement,
                paths: [path],
                recursive: true,
                silent: true
            }
            replacer = Replace.getReplacer()
            replacer options

module.exports = Replace
