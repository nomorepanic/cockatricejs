const fs = require('fs');


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
}

module.exports = App;
