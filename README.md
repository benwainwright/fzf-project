# fzf-project

This plugin provides an easy way of switching between project directories
indexed from a specified workspace folder or folders. It's based on an idea I
originally stole from [kieran-ohara](https://github.com/kieran-ohara)'s
dotfiles.

![Screen Capture](./doc/images/fzf-project.gif)

## Install

#### Install via Plug

```vim
Plug 'junegunn/fzf.vim' "requirement from benwainwright/fzf-project
Plug 'tpope/vim-fugitive' "requirement from benwainwright/fzf-project
Plug 'benwainwright/fzf-project'
```

#### Install via Vundle

```vim
Plugin 'junegunn/fzf.vim' "requirement from benwainwright/fzf-project
Plugin 'tpope/vim-fugitive' "requirement from benwainwright/fzf-project
Plugin 'benwainwright/fzf-project'
```

## Usage

Running `FzfSwitchProject` in command mode will produce a list of folders from
within your workspace folders. When you select a project, the working directory
is changed and you are presented with a fzf list of files to switch to.

## AutoRooting

Installing `FzfSwitchProject` will automatically `cd` to the root directory of
any given project when you open a file. It does this by recursively locating the
nearest `.git` folder in the directory hierarchy. For this reason, is
recommended to use `git` with this plugin

## Configure

```vim
let g:fzfSwitchProjectWorkspaces = [ '~/workspace1', '~/workspace2' ]
```

Automatically list projects in the above folders

```vim
let g:fzfSwitchProjectProjects = [ '~/folder1', '~/folder2' ]
```

Add individual folders to the project list (I use it for my
dotfiles folder)


```vim
let g:fzfSwitchProjectProjectDepth = 1 " default
```

Set the project folder depth. When this is set to 1 (the default), only the _immediate children_ of workspace folders are considered project folders. If it is set to a number greater than 1, then the project finder will recurse that many times to find project folders. E.g. if it is set to 2, the grand children of workspace folders are considered project folders, and if set to 3, the great-grandchildren.

Note, that if during recursion any folder is found to contain a ".git" folder (and is therefore a git project), that folder is automatically considered a project folder and recursion will not continue.

If this setting is set to the string 'infinite' (or indeed any value other than a number greater than 0), recursion continues infinitely until exhaustion or a `.git` project is found.

```vim
let g:fzfSwitchProjectFindFilesCommand = 'git ls-files --others --exclude-standard --cached' " default
```

Command that is executed to get a list of all the files in a given project

```vim
let g:fzfSwitchProjectAlwaysChooseFile = 0
```

Don't automatically open a file picker once project is selected

```vim
let g:fzfSwitchProjectCloseOpenedBuffers = 0
```

Set this to 1 if you want to close and delete all opened buffers after switching to a different project, it will only close and delete opened buffers if all updated buffers are saved.

## Commands

- `FzfSwitchProject` - open project switcher
- `FzfChooseProjectFile` - switch file within project

## Dependencies

- [fzf.vim](https://github.com/junegunn/fzf.vim)
- [fugitive](https://github.com/tpope/vim-fugitive)
