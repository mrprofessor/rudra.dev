+++
title = "A floating terminal for (Neo)vim"
author = ["mrprofessor"]
date = 2019-10-12
tags = ["unix", "vim", "neovim", "editor", "productivity"]
draft = false
aliases = "/post/a-floating-terminal-for-vim"
+++

I love working in terminal and editing with
[(Neo)vim](https://neovim.io/). Though I have been using vim since my
college days, for past two years I am using it as my full-time editor.

I remember vividly when I first switched to vim at work. It was a
horrible experience for the first week which made me flood my vimrc file
with plugins to make it work. I have definitely moved past that phase
and learned to [grok](https://stackoverflow.com/questions/1218390/what-is-your-most-productive-shortcut-with-vim/1220118#1220118) vi since then.

Even now sometimes I tend to miss many nicer features of a full blown
[IDE](https://en.wikipedia.org/wiki/Integrated%5Fdevelopment%5Fenvironment),
like better language support, familiar clipboard management and inbuilt
terminal support. Thanks to the developers of Neovim, vim users can use
the full potential of terminal without quitting or stopping the editor

Last week I came across a plugin named
[vim-termfloat](https://github.com/voldikss/vim-floaterm) which uses
Neovim's floating window and I realized that I have been(subconsciously)
wanting this feature for a really long time. This plugin lets me open my
terminal, restart my server, close the terminal and get back to my
editor with a few keystrokes.

```vim
  " Float baby float
  Plugin 'voldikss/vim-floaterm'
```

I have also remapped my `<leader>t` to toggle the floating terminal.

```vim
  noremap  <leader>t  :FloatermToggle<CR>i
  noremap! <leader>t  <Esc>:FloatermToggle<CR>i
  tnoremap <leader>t  <C-\><C-n>:FloatermToggle<CR>
```

I have resized the terminal window and set the transparency to zero.

```vim
  let g:floaterm_width = 100
  let g:floaterm_winblend = 0
```

Time for some action then! Let's quickly run a python script without
bothering to leave the window.

<div class="post-image">
  <img src="/images/py-demo.gif" />
</div>

The following example shows how I ran gatsby while writing this blog
post.

<div class="post-image">
  <img src="/images/gatsby-dev.gif" />
</div>

Yeah of course I can still use the in built terminal of neovim in a
different pane or window, but this plugin really makes it easy.

Anyways I did a lot of research on effectively creating these gif files.
Well that's for another post.

Adios!
