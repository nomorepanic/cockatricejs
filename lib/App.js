const fs = require('fs');
const Matter = require('gray-matter');
const Pug = require('pug');


class App {
    constructor(template, content, output) {
        this.template = template;
        this.content = content;
        this.output = output;
    }

    findFiles(path) {
        this.files = [];
        fs.readdir(path, (error, files) => {
            files.forEach((file) => {
                if (file.slice(-3) === '.md') {
                    this.files.push(file);
                }
            });
        });
    }

    compile(file) {
        /* Compiles a template using data from a markdown file */
        const compiler = Pug.compileFile(this.template);
        fs.readFile(file, 'utf8', (error, data) => {
            const front = Matter(data);
            front.data.content = front.content;
            const html = compiler(front.data);
            const page = file.slice(0, file.indexOf('.md'));
            fs.writeFile(`${page}.html`, html, (innerError) => {});
        });
    }

    makePages() {
        this.files.forEach((file) => {
            this.compile(file);
        });
    }
}

module.exports = App;
