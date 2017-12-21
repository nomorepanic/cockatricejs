const App = require('../cast/App.js');
const Chai = require('chai');
const td = require('testdouble');

const expect = Chai.expect;
const fs = require('fs');


describe('the Cast application', () => {
    beforeEach(() => {
        this.app = new App();
    });

    it('should parse a directory', () => {
        const files = ['one.md', 'two.md', 'three.yml'];
        td.replace(fs, 'readdir');
        td.when(fs.readdir(td.matchers.anything())).thenCallback(null, files);
        this.app.findFiles('path');
        expect(this.app.files).to.eql(['one.md', 'two.md']);
    });

    it('should generate a page', () => {
        td.replace(App, 'compile');
        this.app.files = ['front.md'];
        this.app.makePage('test.pug');
        td.verify(App.compile('test.pug', 'front.md'));
    });
});
