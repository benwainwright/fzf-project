
augroup projectSwitcher
  autocmd!
  autocmd BufEnter * call fzfproject#autoroot#switchroot()
augroup END

command! FzfSwitchProject call fzfproject#switch()
command! FzfChooseProjectFile call fzfproject#find#file()
