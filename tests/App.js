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
        Td.replace(fs, 'readdirSync');
        Td
            .when(fs.readdirSync(Anything()))
            .thenReturn(files);
        Expect(App.findFiles('path')).to.eql(['path/one.md', 'path/two.md']);
    });

    it('should compile a template', () => {
        const compiler = Td.function();
        Td.replace(Pug, 'compileFile');
        Td.replace(fs, 'writeFile');
        Td.replace(fs, 'readFile');
        Td.when(compiler(Anything())).thenReturn('html');
        Td.when(Pug.compileFile(this.template)).thenReturn(compiler);
        Td.when(fs.readFile(Anything(), Anything())).thenCallback(null, '');
        this.app.compile('front.md');
        Td.verify(fs.writeFile('output/front.html', 'html', Anything()));
    });

    it('should generate a page', () => {
        Td.replace(this.app, 'compile');
        Td.replace(App, 'findFiles');
        Td
          .when(App.findFiles(this.content))
          .thenReturn(['test.md']);
        this.app.makePages();
        Td.verify(this.app.compile('test.md'));
    });

    afterEach(() => {
        Td.reset();
    });
});
