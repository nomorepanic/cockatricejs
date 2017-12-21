const fs = require('fs');

const Chai = require('chai');
const Pug = require('pug');
const Td = require('testdouble');

const App = require('../lib/App');

const Anything = Td.matchers.anything;
const Expect = Chai.expect;


describe('the Application module', () => {
    beforeEach(() => {
        this.template = 'templates/test.pug';
        this.content = 'content';
        this.output = 'output';
        this.app = new App(this.template, this.content, this.output);
    });

    it('should have a constructor method', () => {
        Expect(this.app.template).to.eql(this.template);
        Expect(this.app.content).to.eql(this.content);
        Expect(this.app.output).to.eql(this.output);
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
