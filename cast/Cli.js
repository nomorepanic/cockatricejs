const Commander = require('commander');

const App = require('./App');


class Cli {
    static main() {
        Cli.compile();
        Commander.parse(process.argv);
    }
}

module.exports = Cli;
