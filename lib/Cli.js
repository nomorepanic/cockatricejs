const Commander = require('commander');

const App = require('./App');


class Cli {
    static compile() {
        Commander
            .command('compile <template> <content> <output>')
            .action((template, content, output) => {
                const app = new App(template, content, output);
                app.makePages();
            });
    }

    static main() {
        Cli.compile();
        Commander.parse(process.argv);
    }
}

module.exports = Cli;
