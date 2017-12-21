const fs = require('fs');

const Chai = require('chai');
const Pug = require('pug');
const Td = require('testdouble');

const App = require('../lib/App');

const Anything = Td.matchers.anything;
const Expect = Chai.expect;


describe('the Application module', () => {
    beforeEach(() => {
        this.app = new App();
    });

    it('should parse a directory', () => {
        const files = ['one.md', 'two.md', 'three.yml'];
        Td.replace(fs, 'readdir');
        Td.when(fs.readdir(Anything())).thenCallback(null, files);
        this.app.findFiles('path');
        Expect(this.app.files).to.eql(['one.md', 'two.md']);
    });

    it('should compile a template', () => {
        const compiler = Td.function();
        Td.replace(Pug, 'compileFile');
        Td.replace(fs, 'writeFile');
        Td.replace(fs, 'readFile');
        Td.when(compiler(Anything())).thenReturn('html');
        Td.when(Pug.compileFile('test.pug')).thenReturn(compiler);
        Td.when(fs.readFile(Anything(), Anything())).thenCallback(null, '');
        App.compile('test.pug', 'front.md');
        Td.verify(fs.writeFile('front.html', 'html', Anything()));
    });

    it('should generate a page', () => {
        Td.replace(App, 'compile');
        this.app.files = ['front.md'];
        this.app.makePages('test.pug');
        Td.verify(App.compile('test.pug', 'front.md'));
    });
});
