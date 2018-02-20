# Cockatrice

[![Travis](https://img.shields.io/travis/Vesuvium/cockatrice.svg?style=for-the-badge)](https://travis-ci.org/Vesuvium/cockatrice)
[![npm](https://img.shields.io/npm/v/cockatrice.svg?style=for-the-badge)](https://www.npmjs.com/package/cockatrice)
[![npm](https://img.shields.io/badge/status-alpha-red.svg?style=for-the-badge)]()

Cockatrice is a static website manager that makes it really easy to create a
website and manage it because it integrates the most modern tools in a seamless
workflow.

Currently, the project is at an early alpha stage.

Cockatrice revolves around some principles:
- Even if you use a theme, you're likely to change some bits here and there,
  add some js and so on.
- You should not spend time figuring out how customize or extend a theme,
  the system should do it for you
- Ease of configuration for simple uses, retaining the ability of advanced
  setups for those who need it
- Allow to use whateve the user wants (coffescript, pug, webpack)


## Usage

Install with npm

```
npm install -g cockatrice
```

Compile pug with content from frontmatter:

```
cockatrice compile pug template.pug output/folder -i path/to/frontmatter/folder
```

Compile scss:
```
cockatrice compile scss main.scss output.css
```

## Features
Cockatrice supports pug, scss and markdown with frontmatter.

You can query for markdown content from pug.


## To do

- [ ] Use a configuration file
    - [ ] Load defaults from config
- [ ] Add image compressor
- [ ] Add minifiers
- [ ] Add linters
- [ ] Add support for running bundlers
- [ ] Add js support
- [ ] Add theming support
- [ ] Improve output for actions and errors

## Contributing

Contributors are welcome :)

Open an issue if you encounter any problem
