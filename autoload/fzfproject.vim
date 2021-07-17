let s:workspaces = get(g:, 'fzfSwitchProjectWorkspaces', [])
let s:projects = get(g:, 'fzfSwitchProjectProjects', [])
let s:gitInit = get(g:, 'fzfSwitchProjectGitInitBehavior', 'ask')
let s:chooseFile = get(g:, 'fzfSwitchProjectAlwaysChooseFile', 1)
let s:projectDepth = get(g:, 'fzfSwitchProjectProjectDepth', 1)
let s:debug = get(g:, 'fzfSwitchProjectDebug', 1)

function! fzfproject#execute(command, dir, context)
  let l:command = a:command . ' ' . a:dir
  if s:debug ==# 1
    echom("FZFProject (" . a:context . ") executing command: '" . l:command . "'")
  endif
  execute 'noautocmd ' . l:command
endfunction

function! fzfproject#changeDir(dir, context)
  call fzfproject#execute('cd', fnameescape(a:dir), a:context)
endfunction

function! fzfproject#switch()
  let l:projects = s:getAllDirsFromWorkspaces(s:workspaces, 1)
  let l:projects = l:projects + s:projects 
  let l:opts = {
    \ 'sink': function('s:switchToProjectDir'),
    \ 'source': s:formatProjectList(l:projects),
    \ 'down': '40%'
    \ }
  call fzf#run(fzf#wrap(l:opts))
endfunction

function! s:switchToProjectDir(projectLine)
  try
    let autochdir = &autochdir
    set noautochdir
    let l:parts = matchlist(a:projectLine, '\(\S\+\)\s\+\(\S\+\)')
    let l:path = l:parts[2] . '/' . l:parts[1]
    let w:fzfProjectPath = l:path
    call fzfproject#changeDir(l:path, "projectSwitcher")
    if s:gitInit !=# 'none'
      call s:initGitRepoIfRequired(s:gitInit)
    endif

    if s:chooseFile
      call fzfproject#find#file() 
      " Fixes issue with NeoVim
      " See https://github.com/junegunn/fzf/issues/426#issuecomment-158115912
      if has("nvim") && !has("nvim-0.5.0")
        call feedkeys('i')
      endif
    endif

  finally
    let &autochdir = autochdir
  endtry
endfunction

function! s:getAllDirsFromWorkspaces(workspaces, depth)

  if len(a:workspaces) == 0
    return []
  endif

  let l:dirs = globpath(join(a:workspaces, ','), '*/', 1)

  let l:projectFolders = []
  let l:nonProjectFolders = []

  for dir in split(l:dirs, "\n")
    if FugitiveIsGitDir(dir . '/.git') || a:depth == s:projectDepth
      call add(l:projectFolders, fnamemodify(dir, ':h'))
    else
      call add(l:nonProjectFolders, fnamemodify(dir, ':h'))
    endif
  endfor

  return l:projectFolders + s:getAllDirsFromWorkspaces(l:nonProjectFolders, a:depth + 1)
endfunction

function! s:formatProjectList(dirs)
  let l:dirParts = [  ]
  let l:longest = 0
  for dir in a:dirs
    let l:name = fnamemodify(dir, ':t')
    let l:length = len(l:name)
    if l:length > l:longest
      let l:longest = l:length
    endif
    let dir = { 'name' : l:name, 'dir' : fnamemodify(dir, ':h') }
    call add(l:dirParts, dir)
  endfor
  return s:generateProjectListLines(l:dirParts, l:longest) 
endfunction

function! s:generateProjectListLines(dirParts, longest)
  let l:outputLines = [  ]
  for dir in a:dirParts
    let l:padding = a:longest - len(dir['name'])
    let l:line = dir['name'] 
          \ . repeat(' ', l:padding) 
          \ . ' ' . dir['dir']
    call add(l:outputLines, l:line)
  endfor
  return l:outputLines
endfunction

function! s:initGitRepoIfRequired(behaviour)
  if !FugitiveIsGitDir(getcwd() . '/.git')
    if a:behaviour ==# 'ask'
      let s:yesNo = input('Initialise git repository? (y/n) ')
    elseif a:behaviour ==# 'auto'
      let s:yesNo = 'yes'
    endif
    if s:yesNo ==? 'y' || s:yesNo ==? 'yes'
      !git init
    endif
  endif
endfunction
