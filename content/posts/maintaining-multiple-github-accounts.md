+++
title = "Maintaining multiple GitHub accounts"
author = ["rudra kar"]
date = 2018-02-24
tags = ["git", "github"]
draft = false
aliases = "/post/maintaining-multiple-github-accounts"
+++

I recently left a huge IT corporation for a promising startup.I was
asked to change my GitHub handler name as it was too cool(I think) for
them.Well instead of changing I created another account using my company
email.

Now I got a problem.Every day when I come home and start hacking around
my own projects I had to manually set my username and email id in git
config in order to reflect my contributions in the graph and most of the
time I forget to do so.

So I created some aliases to toggle between my two handles.

```sh
# Set user 1 as current user
gitfirst() {
    git config --global user.email 'xxx.yyyy@gmail.com' && git config --global user.name 'mrprofessor'
    gituser
}

# Set user 2 as current user
gitsecond() {
    git config --global user.email 'zzzzz@corporation.com' && git config --global user.name 'rudrabot'
    gituser
}

# Print current user
gituser() {
    git config --global user.name && git config --global user.email
}
```

And that five minute I save every day from this hack..spends for...I
don't know.

Adios.
