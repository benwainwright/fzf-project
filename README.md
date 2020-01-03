fzf-switch-project
==================

This plugin provides an easy way of switching between project directories
indexed from a specified workspace folder or folders. I originally stole 
from [kieran-bamforth](https://github.com/kieran-bamforth) 's dotfiles.

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

automatically list projects in the above folders

```vim
let g:fzfSwitchProjectProjects = [ '~/folder1', '~/folder2' ]
```

add individual folders to the project list (I use it for my
dotfiles folder)

```vim
let g:fzfSwitchProjectsGitInitBehaviour = 'ask' " default
```

`fzf-switch-project` can automatically initialise a git repository for you if
you switch to a project folder without one. The possible values are:

- `ask` (default) prompt the user to confirm if a new git repository should be
    initialised
- `auto` always initialise a new git repository if one isn't found
- `none` do nothing

Usage
-----

Running `FzfSwitchProjects` in command mode will produce a list of folders from
within your workspace folders that contain a `.git` folder at their root (I
may make this filtering optional in the future). When you select a project, the
working directory is changed and the `GitFiles` command from [fzf.vim](https://github.com/junegunn/fzf.vim)
is initiated to allow you to switch to a file within the project.

Dependencies
------------

- [fzf.vim](https://github.com/junegunn/fzf.vim)
- [fugitive](https://github.com/tpope/vim-fugitive)


