const App = require('../cast/App.js');
const Chai = require('chai');
const Sinon = require('sinon');

const expect = Chai.expect;
const fs = require('fs');


describe('the Cast application', () => {
    beforeEach(() => {
        this.app = new App();
    });

    it('should parse a directory', () => {
        const files = ['one.md', 'two.md', 'three.yml'];
        Sinon.stub(fs, 'readdir').yields(null, files);
        this.app.findFiles('path');
        expect(this.app.files).to.eql(['one.md', 'two.md']);
    });
});
