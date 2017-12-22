const fs = require('fs');
const path = require('path');

const Matter = require('gray-matter');
const Pug = require('pug');


class App {
    constructor(template, content, output) {
        this.template = template;
        this.content = content;
        this.output = output;
    }

    static findFiles(path) {
        let foundFiles = [];
        fs.readdirSync(path, (error, files) => {
            files.forEach((file) => {
                if (file.slice(-3) === '.md') {
                    foundFiles.push(file);
                }
            });
        });
        return foundFiles;
    }

    compile(file) {
        /* Compiles a template using data from a markdown file */
        const compiler = Pug.compileFile(this.template);
        fs.readFile(file, 'utf8', (error, data) => {
            const front = Matter(data);
            front.data.content = front.content;
            const html = compiler(front.data);
            const page = file.slice(0, file.indexOf('.md'));
            const outputPath = path.join(this.output, `${page}.html`);
            fs.writeFile(outputPath, html, (innerError) => {});
        });
    }

    makePages() {
        let files = App.findFiles(this.content);
        files.forEach((file) => {
            this.compile(file);
        });
    }
}

module.exports = App;
