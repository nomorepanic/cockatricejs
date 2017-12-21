const App = require('../cast/App.js');
const Chai = require('chai');
const Pug = require('pug');
const td = require('testdouble');

const anything = td.matchers.anything;
const expect = Chai.expect;
const fs = require('fs');


describe('the Cast application', () => {
    beforeEach(() => {
        this.app = new App();
    });

    it('should parse a directory', () => {
        const files = ['one.md', 'two.md', 'three.yml'];
        td.replace(fs, 'readdir');
        td.when(fs.readdir(anything())).thenCallback(null, files);
        this.app.findFiles('path');
        expect(this.app.files).to.eql(['one.md', 'two.md']);
    });

    it('should compile a template', () => {
        const compiler = td.function();
        td.replace(Pug, 'compileFile');
        td.replace(fs, 'writeFile');
        td.replace(fs, 'readFile');
        td.when(compiler(anything())).thenReturn('html');
        td.when(Pug.compileFile('test.pug')).thenReturn(compiler);
        td.when(fs.readFile(anything(), anything())).thenCallback(null, '');
        App.compile('test.pug', 'front.md');
        td.verify(fs.writeFile('front.html', 'html', anything()));
    });

    it('should generate a page', () => {
        td.replace(App, 'compile');
        this.app.files = ['front.md'];
        this.app.makePage('test.pug');
        td.verify(App.compile('test.pug', 'front.md'));
    });
});
