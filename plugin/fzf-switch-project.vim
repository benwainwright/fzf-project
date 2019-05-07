if !exists('g:fzfSwitchProjectsProjects')
  let g:fzfSwitchProjectsProjects = [  ]
end

if !exists('g:fzfSwitchProjectsWorkspaces')
  let g:fzfSwitchProjectWorkspaces = [  ]
end

function! s:switchToProjectDir(dir)
  execute 'cd ' . a:dir
  GitFiles
endfunction

function! s:getProjectDirs(projects, projectDirs)
  let l:output = [ ]
  for dir in a:projectDirs
    let l:output = systemlist('find ' . dir . ' -type d -maxdepth 1')
  endfor
  return a:projects + l:output
endfunction

function! FzfSwitchProject()

  let l:projects = s:getProjectDirs(
        \ g:fzfSwitchProjectsProjects,
        \ g:fzfSwitchProjectWorkspaces
        \ )

  call fzf#run({
        \ 'sink': function('s:switchToProjectDir'),
        \ 'source': l:projects,
        \ 'down': '40%',
        \ })
endfunction
