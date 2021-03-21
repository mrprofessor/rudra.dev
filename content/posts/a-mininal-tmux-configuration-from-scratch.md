+++
title = "A mininal tmux configuration from scratch"
author = ["mrprofessor"]
date = 2021-03-14
tags = ["tmux", "productivity", "unix", "mac"]
draft = false
+++

<div class="ox-hugo-toc toc">
<div></div>

<div class="heading">Table of Contents</div>

- [General configuration](#general-configuration)
- [Keybindings](#keybindings)
- [Customize Status Bar](#customize-status-bar)
- [Customize Active Pane](#customize-active-pane)
- [Miscellaneous](#miscellaneous)
- [Who wants a minimal config anyway!](#who-wants-a-minimal-config-anyway)

</div>
<!--endtoc-->


## General configuration {#general-configuration}

We need to create a `~/.tmux.conf` file in our home directory. This will be the configuration file for our setup.

If the underlying terminal emulator has `XTERM-256` support then we can add 256 colors support to tmux.

```sh
set -g default-terminal "tmux-256color"
```

By default tmux windows start with number `0`. We could start numbering with `1`.

```sh
set -g base-index 1
```

Set the escape time to 0 for faster key repetition. Tmux generally waits for a certain time after an escape is input to determine if it is a part of a function or meta key sequences. The default is 500 milliseconds.

```sh
set -s escape-time 0
```

By default the mouse support for tmux is set to `off`.

```sh
set -g mouse on
```


## Keybindings {#keybindings}

By default tmux uses `ctrl-b` (`C-b`) as the prefix key. Personally I found this to be a bit less ergonomic for my taste. Let's change that to `C-a`.

```sh
set-option -g prefix C-a
unbind-key C-b
bind-key C-a send-prefix
```

Being a VIM(EVIL) user I have trained myself to use `h`, `j`, `k`, `l` for left, down, up and right movements respectively.

```sh
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R
```

Hot-reloading tmux without restarting it can be really handy for people who tweaks their dotfiles as much as I do.

```sh
bind r source-file ~/.tmux.conf
```

After saving the `~/.tmux.conf` file, we can now use `C-a r` to reload tmux.

Use Vi/Emacs keybinding to move around the buffer.

```sh
# Enable vi keys.
setw -g mode-keys vi

# Escape turns on copy mode
bind Escape copy-mode

# v in copy mode starts making selection
bind-key -T copy-mode v send -X begin-selection
bind-key -T copy-mode y send -X copy-selection

# make Prefix p paste the buffer.
unbind p
bind p paste-buffer
```


## Customize Status Bar {#customize-status-bar}

> Some of the commands(to check OS version, battery info and CPU usage info) I will be using are exclusive to Mac Os. Do drop a comment if you want me to test and figure out the linux equivalents.

The default tmux status line looks something like this. Let's make it a bit more appealing.

<div class="post-image">
  <img src="/images/tmux_status_line_diagram_github.png" />
</div>

```sh
# Set status bar on
set -g status on

# Update the status line every second
set -g status-interval 1

# Set the position of window lists.
set -g status-justify centre # [left | centre | right]

# Set Vi style keybinding in the status line
set -g status-keys vi

# Set the status bar position
set -g status-position top # [top, bottom]

# Set status bar background and foreground color.
set -g status-style fg=colour136,bg="#002b36"
```

We have centered the window lists and got enough real-estate on both sides.

<div class="post-image">
  <img src="/images/tmux-shot2.png" />
</div>

Now let's add some useful stuff up there.

```sh
# Set left side status bar length and style
set -g status-left-length 60
set -g status-left-style default

# Display the session name
set -g status-left "#[fg=green] ❐ #S #[default]"

# Display the os version (Mac Os)
set -ag status-left " #[fg=black] #[fg=green,bright]  #(sw_vers -productVersion) #[default]"

# Display the battery percentage (Mac OS)
set -ag status-left "#[fg=green,bg=default,bright] 🔋 #(pmset -g batt | tail -1 | awk '{print $3}' | tr -d ';') #[default]"

# Set right side status bar length and style
set -g status-right-length 140
set -g status-right-style default

# Display the cpu load (Mac OS)
set -g status-right "#[fg=green,bg=default,bright]  #(top -l 1 | grep -E "^CPU" | sed 's/.*://') #[default]"

# Display the date
set -ag status-right "#[fg=white,bg=default]  %a %d #[default]"

# Display the time
set -ag status-right "#[fg=colour172,bright,bg=default] ⌚︎%l:%M %p #[default]"

# Display the hostname
set -ag status-right "#[fg=cyan,bg=default] ☠ #H #[default]"

# Set the inactive window color and style
set -g window-status-style fg=colour244,bg=default
set -g window-status-format ' #I #W '

# Set the active window color and style
set -g window-status-current-style fg=black,bg=colour136
set -g window-status-current-format ' #I #W '
```

<div class="post-image">
  <img src="/images/tmux-shot3.png" />
</div>

Well who needs an activity monitor now!


## Customize Active Pane {#customize-active-pane}

We need some subtle style changes in order to easily distinguish the active pane form the inactive ones.

```sh
# Colors for pane borders(default)
setw -g pane-border-style fg=green,bg=black
setw -g pane-active-border-style fg=white,bg=black

# Active pane normal, other shaded out
setw -g window-style fg=colour240,bg=colour235
setw -g window-active-style fg=white,bg=black
```

The inactive panes has the green border while as the active one has the white border. Also the inactive panes are a bit greyed out while the active one looks sharper/more
vibrant.

> The above color combination works with dark terminal themes. Do change the colors accordingly as per the terminal theme for better asthetics.

<div class="post-image">
  <img src="/images/tmux-shot4.gif" />
</div>


## Miscellaneous {#miscellaneous}

Here are some useful tweaks for a quiter tmux with a more native Mac like experience.

```sh
# Mac Os Command+K (Clear scrollback buffer)
bind -n C-k clear-history

# Set a larger scroll back
set-option -g history-limit 100000

# A quiter setup
set -g visual-activity off
set -g visual-bell off
set -g visual-silence off
setw -g monitor-activity off
set -g bell-action none
```


## Who wants a minimal config anyway! {#who-wants-a-minimal-config-anyway}

There is much more to tmux than what I have done here with ~50 lines of config. I would highly recommend the [official documentation](https://github.com/tmux/tmux/wiki) for understanding various features of tmux.

Also check out [Awesome tmux](https://github.com/rothgar/awesome-tmux) for almost all the best resources out there for tmux and don't forget to share your screenshots in the comments.

Here is my [tmux.conf](https://github.com/mrprofessor/dotfiles/blob/master/tmux.conf).
