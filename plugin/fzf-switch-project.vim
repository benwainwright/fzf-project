augroup projectSwitcher
  autocmd!
  autocmd BufEnter * call fzfproject#autoroot#switchroot()
  autocmd VimEnter * call fzfproject#autoroot#doroot()
augroup END

command! FzfSwitchProject call fzfproject#switch()
command! FzfChooseProjectFile call fzfproject#find#file(1)
