const fs = require('fs');
const Matter = require('gray-matter');
const Pug = require('pug');


class App {
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

    makePage(templatePath) {
        this.files.forEach((file) => {
            App.compile(templatePath, file);
        });
    }
}

module.exports = App;
