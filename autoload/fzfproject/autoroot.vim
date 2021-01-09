function! fzfproject#autoroot#switchroot()
  if getbufinfo('%')[0]['listed'] && filereadable(@%)
    call fzfproject#autoroot#doroot()
  endif
endfunction

function! fzfproject#autoroot#doroot()
  let l:root = fnamemodify(FugitiveGitDir(), ":h")
  if isdirectory(l:root)
    execute 'lcd ' . l:root
  endif
endfunction
