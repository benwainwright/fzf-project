if !exists('g:fzfSwitchProjectProjects')
  let g:fzfSwitchProjectProjects = [  ]
end

if !exists('g:fzfSwitchProjectWorkspaces')
 let g:fzfSwitchProjectWorkspaces = [  ]
end

function! s:switchToProjectDir(projectLine)
  let l:parts = matchlist(a:projectLine, '\(\S\+\)\s\+\(\S\+\)')
  let l:path = l:parts[2] . '/' . l:parts[1]
  execute 'cd ' . l:path
  GitFiles
endfunction

function! s:getProjectDirsCommand(dirs)
  let l:dirsString = join(a:dirs, ' ')
    return 'find '
          \ . l:dirsString 
          \ . ' -name .git'
          \ . ' -type d'
          \ . ' -mindepth 2'
          \ . ' -maxdepth 2'
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

function! s:getProjectDirs(projects, projectDirs)
  let l:dirs = [  ]
  let l:command = s:getProjectDirsCommand(a:projectDirs)
  let l:gitDirs = systemlist(l:command)
  for gitDir in l:gitDirs
    call add(l:dirs, fnamemodify(gitDir, ':h'))
  endfor
  return s:formatProjectList(a:projects + l:dirs)
endfunction

function! FzfSwitchProject()

  let l:projects = s:getProjectDirs(
        \ g:fzfSwitchProjectProjects,
        \ g:fzfSwitchProjectWorkspaces
        \ )

  call fzf#run({
        \ 'sink': function('s:switchToProjectDir'),
        \ 'source': l:projects,
        \ 'down': '40%',
        \ })
endfunction

command FzfSwitchProject call FzfSwitchProject()
