+++
title = "Rendering markdown from Flask"
author = ["mrprofessor"]
date = 2020-02-04
tags = ["python", "flask", "markdown"]
draft = false
aliases = "/post/rendering-markdown-from-flask"
+++

<div class="ox-hugo-toc toc">
<div></div>

<div class="heading">Table of Contents</div>

- [Let's go hacking](#lets-go-hacking)
- [Not quite there yet!](#not-quite-there-yet)
- [Gimme the code!](#gimme-the-code)

</div>
<!--endtoc-->

In this post I am going to plug about a cool trick(probably useless)
that I discovered geeking around the internet.

I was building a tiny
[microservice](https://github.com/solitudenote/gitkeeper) which would
let the client side application securely authenticate with GitHub. After
writing the only required API, I wanted to render the _README.md_ file
on the index page.

So I planned to convert markdown to html and serve the resultant string
everytime we hit the index.


## Let's go hacking {#lets-go-hacking}

_Required packages_

```sh
  pip3 install Flask markdown
```

_app.py_

```python
  import markdown
  from flask import Flask
  import markdown.extensions.fenced_code

  app = Flask(__name__)


  @app.route("/")
  def index():
      readme_file = open("README.md", "r")
      md_template_string = markdown.markdown(
          readme_file.read(), extensions=["fenced_code"]
      )

      return md_template_string


  if __name__ == "__main__":
      app.run()
```

In the above snippet we are using [Flask](https://flask.palletsprojects.com)(my current favorite) as the web framework, [Python-Markdown](https://github.com/Python-Markdown/markdown) to convert markdown files to HTML, and [fenced\_code](https://python-markdown.github.io/extensions/fenced%5Fcode%5Fblocks/) extension to support code blocks.

And it looked something like this

<div class="post-image">
  <img src="/images/markdown-render-plain.png" />
</div>


## Not quite there yet! {#not-quite-there-yet}

Well even though [Richard Stallman](https://en.wikipedia.org/wiki/Richard%5FStallman) remains my hero, fortunately I do not share his [taste](https://stallman.org/) on web design. So without
over-engineering our little snippet I thought of adding syntax highlighting with [pygments](https://pygments.org/) and [CodeHilite](https://python-markdown.github.io/extensions/code%5Fhilite/) extension.

Let's generate css for syntax highlighting using pygments

```python
  from pygments.formatters import HtmlFormatter

  formatter = HtmlFormatter(style="emacs",full=True,cssclass="codehilite")
  css_string = formatter.get_style_defs()
```

Now we need to append the css\_string to the markdown converted HTML string.

```python
  md_css_string = "<style>" + css_string + "</style>"
  md_template = md_css_string + md_template_string
  return md_template
```

> Alternatively we can use
> [pygments-css](https://github.com/richleland/pygments-css)
> repository to get pre-generated CSS files.

Let's see how the final version looks!

<div class="post-image">
  <img src="/images/markdown-render-hl.png" />
</div>

_Much better if you ask me!_


## Gimme the code! {#gimme-the-code}

Here is the full source code running on Glitch.

<div class="glitch-embed-wrap" style="height: 420px; width: 100%;">
  <iframe
    src="https://glitch.com/embed/#!/embed/silken-football?path=app.py&previewSize=0&sidebarCollapsed=true"
    title="silken-football on Glitch"
    style="height: 100%; width: 100%; border: 0;">
  </iframe>
</div>

Feel free to remix and play around. Adios!
