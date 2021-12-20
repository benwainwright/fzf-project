let s:workspaces = get(g:, 'fzfSwitchProjectWorkspaces', [])

function! fzfproject#autoroot#switchroot()
  if getbufinfo('%')[0]['listed'] && filereadable(@%)
    call fzfproject#autoroot#doroot()
  endif
endfunction

let s:dirs = fzfproject#getAllDirsFromWorkspaces(s:workspaces, 1)

function! fzfproject#autoroot#doroot(...)

  if a:0 > 0
    if a:1 == "/"
      return
    endif

    let l:rootToTry = a:1
  else
    let l:root = FugitiveGitDir()
  endif

  if index(s:dirs, l:rootToTry) == -1
    call fzfproject#autoroot#doroot(fnamemodify(l:rootToTry, ":h"))
  else
    call fzfproject#changeDir(l:rootToTry, "doRoot")
  endif
endfunction
