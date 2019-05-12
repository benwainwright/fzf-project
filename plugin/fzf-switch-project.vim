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
  let l:projects = s:getAllDirsFromWorkspaces(
        \ g:fzfSwitchProjectWorkspaces
        \ )

  let l:projects = l:projects + g:fzfSwitchProjectProjects

  call fzf#run({
        \ 'sink': function('s:switchToProjectDir'),
        \ 'source': s:formatProjectList(l:projects),
        \ 'down': '40%',
        \ })
endfunction

command! FzfSwitchProject call FzfSwitchProject()
