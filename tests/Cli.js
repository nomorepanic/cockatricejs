const Commander = require('commander');
const Td = require('testdouble');

const Cli = require('../cast/Cli');


describe('the Cli module', () => {
    it('should have a main method', () => {
        Td.replace(Commander, 'parse');
        Td.replace(Cli, 'compile');
        Cli.main();
        Td.verify(Cli.compile());
        Td.verify(Commander.parse(process.argv));
    });
});
