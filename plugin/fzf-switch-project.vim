if !exists('g:fzfSwitchProjectProjects')
  let g:fzfSwitchProjectProjects = [  ]
end

if !exists('g:fzfSwitchProjectWorkspaces')
 let g:fzfSwitchProjectWorkspaces = [  ]
end

function! s:switchToProjectDir(dir)
  execute 'cd ' . a:dir
  GitFiles
endfunction

function! s:getProjectDirs(projects, projectDirs)
  let l:output = [ ]
  for dir in a:projectDirs
    let l:command = 'find ' . dir . ' -name .git -type d -mindepth 2 -maxdepth 2 -exec dirname {} \;'
    let l:output = systemlist(l:command)
  endfor
  return a:projects + l:output
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
