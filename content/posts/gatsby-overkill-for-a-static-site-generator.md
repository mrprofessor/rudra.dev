+++
title = "GatsbyJs: An overkill for a static site generator"
author = ["mrprofessor"]
date = 2020-06-18
tags = ["gatsby", "react", "emacs", "hugo", "orgmode", "rant", "editor"]
draft = false
+++

So I have been using Gatsby for almost two years now. I have built a nice looking and fast blog with 15 odd posts. With Gatsby I got PWA is out of the box, the component's are written in react, I can query my post data from graphQL and so many other goodies.


## So what went wrong? {#so-what-went-wrong}

As my career progressed, I have gradually moved from being a Full-stack(UI Primary) engineer to a back-end/platform engineer. While I still retain my love for React, I believe React shouldn't be the norm of web development. The whole ever-changing ecosystem around React is maddening. It's certainly built for highly interactive and complex web applications, but in my opinion it doesn't hold much value in static blog generation.

Also GraphQL seemed a bit overkill for a blog too.

There are certain pain points that were bugging me for a long time.

1.  It's hard to leverage any library that doesn't have a React component or Gatsby plugin built for it. e.g [Utterances](https://utteranc.es/).
2.  Tagging is not so straight-forward. Hugo and Jekyll has a first-class support for it.
3.  Running an external script always has been tough and need react specific [hacks](https://reactjs.org/docs/dom-elements.html#dangerouslysetinnerhtml).
4.  Lack of dedicated and switchable themes.
5.  The humongous amount of public files.

> Creating a blog shouldn't have to be so complex. A bunch of markdown files and a simple script to convert them into HTML should be enough.

It's definitely not for people who like a comfortable blogging system like [Wordpress](https://wordpress.org/) or [Jeykill](https://jekyllrb.com/), which can be set up in one afternoon. The returns we get for using and understanding such a complex stack is relatively less if you ask me.


## My new workflow {#my-new-workflow}

I have always loved markdown until I discovered [Org-mode](https://orgmode.org/). It simply blew me away. I never thought I could do so much with plain text, and when I learned about [ox-hugo](https://ox-hugo.scripter.co/), the idea of publishing a blog completely from emacs fascinated me.

Also the fact that this is somewhat a programming blog, having the ability to [execute source code](https://orgmode.org/worg/org-contrib/babel/) inside the document is really helpful.

<div class="post-image">
  <img src="/images/org-hugo-setup.png" />
</div>

`Org-mode` coupled with `ox-hugo` gave me a significant advantage by managing all my pages in a single org-file. Ox-hugo converts the contents of my org-files to a directory of markdown files, So for my setup I decided to have one org-file per each sub-route(logs/, posts/, etc).


## Conclusion {#conclusion}

This post is not about bashing Gatsby or showing it's inferiority. It's an humble explanation of it's pitfalls while creating a basic blog. Gatsby has served me good over the past years. Undoubtedly  it is a great software, just not well suited for my needs at the time.

If you are a front-end developer with the knowledge of React and always willing to dive in and tweak whenever you need a change, then by all means go ahead. But if you don't want to go down that rabbit-hole, just know that there are much easier options available.
