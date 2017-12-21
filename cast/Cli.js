const Commander = require('commander');

const App = require('./App');


class Cli {
    static compile() {
        Commander
            .command('compile <filesDirectory> <templatePath>')
            .action((filesDirectory, templatePath) => {
                const app = new App();
                app.findFiles(filesDirectory);
                app.makePages(templatePath);
            });
    }

    static main() {
        Cli.compile();
        Commander.parse(process.argv);
    }
}

module.exports = Cli;
