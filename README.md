# Cast

Cast is a static website manager that makes it really easy to create a website and manage it because it integrates the most modern tools in a seamless workflow.

Cast revolves around some principles:
- Even if you use a theme, you're likely to change some bits here and there, add some js and so on.
- You should not spend time figuring out how customize or extend a theme, the system should do it for you
- Ease of configuration for simple uses, retaining the ability of advanced setups for those who need it
- Use modern tools to save time (sass, pug, coffeescript)

## A quick example

Let's say that you have installed Cast and started a new website. You will have this structure:

- assets
   - js
   - sass
   - images
- themes
   - default
   - custom
- content
  - home.md
  - about.md
- cast.toml
  
  Cast will:
  - Read configuration from cast.toml
  - transpile, merge and minify your custom js in to main.min.js
  - build sass into css and minify it
  - Your custom sass (now css) and js will automatically work with the theme
  - optimize images losslessy
  - build content to html and minify it
  
In cast.toml you can configure Cast, changing the default paths or change the tooling, for example you might want to use TypeScript instead of coffee or less instead of sass.

You can also override parts of the theme you are using, 

## Themes as first-class citizens
Themes are great and Cast knows it. But we don't want people to make yet another porting of every theme! That's why Cast supports jekyll, hugo and hexo themes.

- Cast themes use pug, sass and coffeescript by default
- In cast.toml, you can specify other means of building your theme

Theme structure:

- assets
  - js
  - sass
  - images
- layouts
- partials
- cast.toml



