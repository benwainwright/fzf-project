function! fzfproject#autoroot#switchroot()
  if getbufinfo('%')[0]['listed'] && filereadable(@%)
    let l:root = fnamemodify(FugitiveGitDir(), ":h")
    if isdirectory(l:root)
      execute 'lcd ' . l:root
    endif
  endif
endfunction

