function! fzfproject#autoroot#switchroot()
  if getbufinfo('%')[0]['listed'] && filereadable(@%)
    call fzfproject#autoroot#doroot()
  endif
endfunction

function! fzfproject#autoroot#doroot()
  let l:root = FugitiveGitDir(getcwd())
  if stridx(l:root, ".git") != -1
    let l:root = fnamemodify(l:root, ":h")
  endif
  if isdirectory(l:root)
    call fzfproject#changeDir(l:root, "doRoot")
  endif
endfunction
