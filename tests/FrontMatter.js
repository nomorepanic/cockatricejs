const fs = require('fs');

const Chai = require('chai');
const Pug = require('pug');
const Td = require('testdouble');

const FrontMatter = require('../lib/FrontMatter');

const Anything = Td.matchers.anything;
const Expect = Chai.expect;


describe('the FrontMatter module', () => {
    beforeEach(() => {
        this.template = 'templates/test.pug';
        this.content = 'content';
        this.output = 'output';
        this.front = new FrontMatter(this.template, this.content, this.output);
    });

    it('should have a constructor method', () => {
        Expect(this.front.template).to.eql(this.template);
        Expect(this.front.content).to.eql(this.content);
        Expect(this.front.output).to.eql(this.output);
    });

    it('should parse a directory', () => {
        const files = ['one.md', 'two.md', 'three.yml'];
        Td.replace(fs, 'readdirSync');
        Td
            .when(fs.readdirSync(Anything()))
            .thenReturn(files);
        const result = FrontMatter.findFiles('path');
        Expect(result).to.eql(['path/one.md', 'path/two.md']);
    });

    it('should compile a template', () => {
        const compiler = Td.function();
        Td.replace(Pug, 'compileFile');
        Td.replace(fs, 'writeFile');
        Td.replace(fs, 'readFile');
        Td.when(compiler(Anything())).thenReturn('html');
        Td.when(Pug.compileFile(this.template)).thenReturn(compiler);
        Td.when(fs.readFile(Anything(), Anything())).thenCallback(null, '');
        this.front.compile('front.md');
        Td.verify(fs.writeFile('output/front.html', 'html', Anything()));
    });

    it('should generate a page', () => {
        Td.replace(this.front, 'compile');
        Td.replace(FrontMatter, 'findFiles');
        Td
            .when(FrontMatter.findFiles(this.content))
            .thenReturn(['test.md']);
        this.front.makePages();
        Td.verify(this.front.compile('test.md'));
    });

    afterEach(() => {
        Td.reset();
    });
});
