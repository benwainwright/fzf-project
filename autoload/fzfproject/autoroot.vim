function! fzfproject#autoroot#switchroot()
  if getbufinfo('%')[0]['listed'] && filereadable(@%)
    let l:root = fnamemodify(FugitiveGitDir(), ":h")
    if isdirectory(l:root)
      execute 'cd ' . l:root
    endif
  endif
endfunction

