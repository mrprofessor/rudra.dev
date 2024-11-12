+++
title = "Setting up (Neo)vim for React development"
author = ["rudra kar"]
date = 2019-05-03
tags = ["vim", "react", "editor", "javascript", "web", "archive"]
draft = false
aliases = "/post/setting-up-vim-for-react"
+++

<div class="ox-hugo-toc toc">

<div class="heading">Table of Contents</div>

- [Syntax Highlighting](#syntax-highlighting)
- [Linters and Formatters](#linters-and-formatters)
- [Autocompletion](#autocompletion)
- [Commenting](#commenting)
- [Conclusion](#conclusion)

</div>
<!--endtoc-->

It's been 8 months since I have been using (neo)vim as my primary text
editor. Initially it was incredibly tough to adopt and use it in work.
Well that would be another story to tell.

Back then I was working mostly in backend using
[CoffeeScript](https://coffeescript.org/) (I know 🙈). VS Code had a
little support for CoffeeScript so I didn't had any problems using vim
full time.

But things changed drastically when I moved into UI development this
year. I had to spend hours reading blogs, threads on reddit to create at
least a workable setup for a hassle-less React enviornment. Here I am
sharing my vim setup for JS/React development.

> Note: I am using [Vundle](https://github.com/VundleVim/Vundle.vim)
> for plugin management.


## Syntax Highlighting {#syntax-highlighting}

Out of the box vim/nvim supports syntax highlighting for major
programming languages.

```bash
ls /usr/share/vim/vim80/syntax/
```

[vim-jsx](https://github.com/mxw/vim-jsx) is by far the best jsx
plugin for vim.
[vim-javascript](https://github.com/pangloss/vim-javascript) provides
better syntax highlighting and code folding support compared to the
default one.

```vim
Plugin 'mxw/vim-jsx'
Plugin 'pangloss/vim-javascript'
```

But It is yet to add `jsx` to its inventory. Also there are some
javascript specific plugins that makes syntax highlighting much better.


## Linters and Formatters {#linters-and-formatters}

Well everyone has a love hate relationship with linters. Nobody likes
those annoying red lines on the editor the moment they add a newline.

But with vim You are in luck. [ALE](https://github.com/w0rp/ale) is a
nice plugin that asynchronously checks for syntatical errors in the
code. It supports mnay language specific linters and formatters. ALE
also lets people configure the signs for errors and warnings.

```vim
Plugin 'w0rp/ale'
```

For JS/React development to add `eslint` as a linter and `prettier` I
added this to my vimrc

```vim
let g:ale_linters = {
  \ 'javascript': ['eslint'],
  \}

let g:ale_fixers = {
  \ 'javascript': ['prettier', 'eslint']
  \ }
```

I also mapped `leader+d` as my ale fixer and configured to format each
time I save the file.

```vim
let g:ale_fix_on_save = 1
nmap <leader>d <Plug>(ale_fix)
```


## Autocompletion {#autocompletion}

Auto completion in vim is not as good as any modern IDE but
[Deoplete](https://github.com/Shougo/deoplete.nvim) is worth taking a look.

Check the [repo](https://github.com/Shougo/deoplete.nvim#install) for installation guides.


## Commenting {#commenting}

Though this is not specific to any particular language I would like to
discuss an excellent plugin which is pretty good at commenting and
uncommenting code.
[NerdCommenter](https://github.com/scrooloose/nerdcommenter)
definitely going to save you a few additional key-presses a day and
being a vimmer is all about that.

```vim
Plugin 'scrooloose/nerdcommenter'
```


## Conclusion {#conclusion}

With vim it's hard to find an universal config that suits everyone. It's
always solving one problem at a time that led me here. This is
definitely not a full fledge solution to this but it seems to work
pretty well for me. So if you have any suggestion feel free to ping me
on [Twitter](https://twitter.com/ThisIsRudra).

My full vim setup can be found
[here](https://github.com/mrprofessor/dotfiles/blob/master/.vimrc).
