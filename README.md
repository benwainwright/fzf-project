fzf-switch-project
==================

This plugin provides an easy way of switching between project directories
indexed from a specified workspace folder or folders. I originally stole 
from @kieran-bamforth's dotfiles.

Install
-------

#### Install via Plug:

```vim
Plug 'benwainwright/fzf-switch-project'
```

Configure
---------

```vim
let g:fzfSwitchProjectWorkspaces = [ '~/workspace1', '~/workspace2' ]
```

or if you want to add individual folders to the project list (I use it for my
dotfiles folder)

```vim
let g:fzfSwitchProjectProjects = [ '~/folder1', '~/folder2' ]
```

Usage
-----

Running `FzfSwitchProjects` in command mode will produce a list of folders from
within your workspace folders that contain a `.git` folder at their root (I
may make this filtering optional in the future). When you select a project, the
working directory is changed and the `GitFiles` command from [fzf.vim](https://github.com/junegunn/fzf.vim) is initiated to allow you to switch to a file within the project.

Dependencies
------------
requires [fzf.vim](https://github.com/junegunn/fzf.vim) and the [fzf command line tool](https://github.com/junegunn/fzf)


