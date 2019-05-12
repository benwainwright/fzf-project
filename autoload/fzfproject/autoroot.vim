function! fzfproject#autoroot#switchroot()
  if getbufinfo('%')[0]['listed']
    let l:root = fnamemodify(FugitiveGitDir(), ":h")
    if isdirectory(l:root)
      execute 'cd ' . l:root
      echom("Switched working directory to " . l:root)
    endif
  endif
endfunction

