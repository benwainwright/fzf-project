let s:workspaces = get(g:, 'fzfSwitchProjectWorkspaces', [])
let s:projects = get(g:, 'fzfSwitchProjectProjects', [])
let s:gitInit = get(g:, 'fzfSwitchProjectsGitInitBehaviour', 'ask')
let s:chooseFile = get(g:, 'fzfSwitchProjectsAlwaysChooseFile', 1)

function! s:switchToProjectDir(projectLine)
  try
    let autochdir = &autochdir
    set noautochdir
    let l:parts = matchlist(a:projectLine, '\(\S\+\)\s\+\(\S\+\)')
    let l:path = l:parts[2] . '/' . l:parts[1]
    execute 'cd ' . l:path

    if s:gitInit !=# 'none'
      call s:initGitRepoIfRequired(s:gitInit)
    endif

    if s:chooseFile
      let l:file = s:browseProject()
    endif
  finally
    let &autochdir = autochdir
  endtry
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

function! s:getGitRoot()
  let root = split(system('git rev-parse --show-toplevel'), '\n')[0]
  return v:shell_error ? '' : root
endfunction

function! s:browseProject()
  let l:opts = { 
        \ 'sink*' : function('s:switchToFile'),
        \ 'down': '40%',
        \ 'options': [
            \ '--print-query',
            \ '--header', 'Choose existing file, or enter the name of a new file',
            \ '--prompt', 'Filename> ' 
            \ ]
        \ }
  if FugitiveIsGitDir(getcwd() . '/.git') 
    let l:is_win = has('win32') || has('win64')
    let l:opts['source'] = 'git ls-files --others --exclude-standard --cached' . (l:is_win ? '' : ' | uniq')
  endif
  return fzf#run(l:opts)
endfunction

function! s:switchToFile(lines)
  let l:query = a:lines[0]
  if(len(a:lines) > 1)
    let l:file = a:lines[1]
    execute 'edit ' . l:file
  else
    let s:yesNo = input("Create '" . l:query . "'? (y/n) ")
    if s:yesNo ==? 'y' || s:yesNo ==? 'yes'
      execute 'edit ' . l:query
      write
    endif
  endif
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

function! s:getAllDirsFromWorkspaces(workspaces)
  let l:dirs = globpath(join(a:workspaces, ','), '*/', 1)
  let l:output = []
  for dir in split(l:dirs, "\n")
    call add(l:output, fnamemodify(dir, ':h'))
  endfor
  return l:output
endfunction

function! FzfSwitchProject()
  let l:projects = s:getAllDirsFromWorkspaces(s:workspaces)

  let l:projects = l:projects + s:projects 
  call fzf#run({
        \ 'sink': function('s:switchToProjectDir'),
        \ 'source': s:formatProjectList(l:projects),
        \ 'down': '40%',
        \ })
endfunction

command! FzfSwitchProject call FzfSwitchProject()
