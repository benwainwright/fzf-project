function! Open_files_in_dir(dir)
  execute 'cd ' . a:dir
  GitFiles
endfunction

function! Get_project_dirs(projects, projectDirs)
  for dir in a:projectDirs
    let l:output = systemlist('find ' . dir . ' -type d -maxdepth 1')
  endfor
  projects = projects + l:output
  return projects
endfunction


