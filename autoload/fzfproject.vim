let s:workspaces = get(g:, 'fzfSwitchProjectWorkspaces', [])
let s:projects = get(g:, 'fzfSwitchProjectProjects', [])
let s:chooseFile = get(g:, 'fzfSwitchProjectAlwaysChooseFile', 1)
let s:projectDepth = get(g:, 'fzfSwitchProjectProjectDepth', 1)
let s:closeOpenedBuffers = get(g:, 'fzfSwitchProjectCloseOpenedBuffers', 0)
let s:debug = get(g:, 'fzfSwitchProjectDebug', 0)

let s:commands = {}

function! s:getAllDirsFromWorkspaces(workspaces, depth)
  if len(a:workspaces) == 0
    return []
  endif

  let l:dirs = globpath(join(a:workspaces, ','), '*/', 1)

  let l:projectFolders = []
  let l:nonProjectFolders = []

  for dir in split(l:dirs, "\n")
    if has('win32') || has('win64')
       let dir = substitute(dir, "\\", "\/", "g")
    endif
    if FugitiveIsGitDir(dir . '/.git') || a:depth == s:projectDepth
      call add(l:projectFolders, fnamemodify(dir, ':h'))
    else
      call add(l:nonProjectFolders, fnamemodify(dir, ':h'))
    endif
  endfor

  return l:projectFolders + s:getAllDirsFromWorkspaces(l:nonProjectFolders, a:depth + 1)
endfunction

let s:projectsFromWorkspaces = s:getAllDirsFromWorkspaces(s:workspaces, 1)
let s:projectList = s:projectsFromWorkspaces + s:projects 

function! fzfproject#execute(command, dir, context)
  let l:command = a:command . ' ' . a:dir
  if s:debug ==# 1
    echom("FZFProject (" . a:context . ") executing command: '" . l:command . "'")
  endif
  execute l:command
endfunction

function! fzfproject#changeDir(dir, context)
  call fzfproject#execute('cd', fnameescape(a:dir), a:context)
endfunction

function! s:setFileToSwitchTo(lines)
  if(len(a:lines) > 0)
    let l:query = a:lines[1]

    let l:commandMap = {
                      \ 'ctrl-x': 'split',
                      \ 'ctrl-v': 'vertical split',
                      \ 'ctrl-t': 'tabe'
                      \ }

    let s:editCommand = get(l:commandMap, l:query, 'edit')
    let s:setFileToSwitchTo = a:lines[2]
  endif
endfunction

function! fzfproject#switch()
  let l:is_win = has('win32') || has('win64')
  let l:opts = {
    \ 'dir': l:is_win ? $TEMP : '/tmp',
    \ 'sink': function('s:switchToProjectDir'),
    \ 'source': s:formatProjectList(s:projectList),
    \ 'down': '40%'
    \ }
  let l:wrapped = fzf#wrap(l:opts)
  call fzf#run(l:opts)
endfunction

function! s:switchToProjectDir(projectLine)
  try
    let autochdir = &autochdir
    set noautochdir
    let l:parts = matchlist(a:projectLine, '\(\S\+\)\s\+\(\S\+\)')
    let l:path = s:commands[a:projectLine]['path']
    let w:fzfProjectPath = l:path

    if s:closeOpenedBuffers
      execute 'bufdo bwipeout'
    endif

    call fzfproject#changeDir(l:path, "projectSwitcher")

    if s:chooseFile
      call fzfproject#find#file(0, l:path, s:commands[a:projectLine]['command']) 
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


function! fzfproject#finalProjectList()
  return s:projectList
endfunction

function! s:formatProjectList(dirs)
  let l:dirParts = [  ]
  let l:longest = 0
  for dir in a:dirs
    if type(dir) == type({})
      let l:name = has_key(dir, "name") ? dir['name'] : fnamemodify(dir['path'], ':t')
      let l:command = dir['command']
      let l:dirPath = dir['path']
    else
      let l:name = fnamemodify(dir, ':t')
      let l:command = ''
      let l:dirPath = dir
    endif

    let l:length = len(l:name)
    if l:length > l:longest
      let l:longest = l:length
    endif
    let dir = { 'name' : l:name, 'dir' : fnamemodify(l:dirPath, ':h'), 'command': l:command, 'fullPath': l:dirPath }
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

    let s:commands[l:line] = { 'command': dir['command'], 'path': dir['fullPath'] }

    call add(l:outputLines, l:line)
  endfor
  return l:outputLines
endfunction
