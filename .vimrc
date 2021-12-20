call plug#begin('~/.vim/plugged')

Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf'
Plug 'tpope/vim-fugitive'
Plug 'benwainwright/fzf-project'
Plug 'junegunn/vader.vim'

call plug#end()

let g:fzfSwitchProjectWorkspaces = [ '~/repos' ]

let g:fzfSwitchProjectProjects = [ '~/single-folder' ]

