const fs = require('fs');
const path = require('path');

const Matter = require('gray-matter');
const Pug = require('pug');


class FrontMatter {
    constructor(template, content, output) {
        this.template = template;
        this.content = content;
        this.output = output;
    }

    static findFiles(contentPath) {
        const markdowns = [];
        const files = fs.readdirSync(contentPath);
        files.forEach((file) => {
            if (path.extname(file) === '.md') {
                markdowns.push(path.join(contentPath, file));
            }
        });
        return markdowns;
    }

    compile(file) {
        /* Compiles a template using data from a markdown file */
        const compiler = Pug.compileFile(this.template);
        fs.readFile(file, 'utf8', (error, data) => {
            const front = Matter(data);
            front.data.content = front.content;
            const html = compiler(front.data);
            const page = path.parse(file).name;
            const outputPath = path.join(this.output, `${page}.html`);
            fs.writeFile(outputPath, html, (innerError) => {});
        });
    }

    makePages() {
        const files = FrontMatter.findFiles(this.content);
        files.forEach((file) => {
            this.compile(file);
        });
    }
}

module.exports = FrontMatter;
