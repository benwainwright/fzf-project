let s:workspaces = get(g:, 'fzfSwitchProjectWorkspaces', [])

function! fzfproject#autoroot#switchroot()
  if getbufinfo('%')[0]['listed'] && filereadable(@%)
    call fzfproject#autoroot#doroot()
  endif
endfunction

let s:dirs = fzfproject#finalProjectList()

function! fzfproject#autoroot#doroot(...)

  if a:0 > 0
    let l:rootToTry = a:1
  else
    let l:rootToTry = FugitiveGitDir()
  endif

  if index(s:dirs, l:rootToTry) == -1

    let l:newRoot = fnamemodify(l:rootToTry, ":h")

    if l:newRoot !=# l:rootToTry
      call fzfproject#autoroot#doroot(fnamemodify(l:rootToTry, ":h"))
    endif

  else
    call fzfproject#changeDir(l:rootToTry, "doRoot")
  endif
endfunction
