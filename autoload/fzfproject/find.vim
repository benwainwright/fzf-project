let s:projects = get(g:, 'fzfSwitchProjectProjects', [])
let s:listFilesCommand = get(g:, 'fzfSwitchProjectFindFilesCommand', 'git ls-files --others --exclude-standard --cached')
let s:debug = get(g:, 'fzfSwitchProjectDebug', 0)

function! s:switchToFile(dir, lines)

  if(len(a:lines) > 0)
    try
      let autochdir = &autochdir
      set noautochdir
      let l:query = a:lines[1]

      let l:commandMap = {
                        \ 'ctrl-x': 'split',
                        \ 'ctrl-v': 'vertical split',
                        \ 'ctrl-t': 'tabe'
                        \ }

      let l:editCommand = get(l:commandMap, a:lines[1], 'edit')
      if(len(a:lines) > 1)
        let l:file = a:lines[2]
        call fzfproject#execute(l:editCommand, fnameescape(a:dir .. "/" .. l:file), "switchToFile")
      else
        let s:yesNo = input("Create '" . l:query . "'? (y/n) ")
        if s:yesNo ==? 'y' || s:yesNo ==? 'yes'
          execute l:editCommand . ' ' . l:query
          write
        endif
      endif
    finally
      let &autochdir = autochdir
    endtry
  endif
endfunction

function! fzfproject#find#file(root_first, dir, command) 
  
  if(a:root_first)
    call fzfproject#autoroot#doroot()
  endif

  let l:dir = a:dir == -1 ? getcwd() : a:dir

  echom l:dir

  let l:command = ''

  for project in s:projects
    if (type(project) == type({}) && expand(project['path']) == expand(l:dir))
      let l:command = project['command']
    endif
  endfor

  if (l:command == '')
      let l:command = a:command ==# ''  ? s:listFilesCommand : a:command
  end

  if s:debug ==# 1
    echom("FZFProject list command: '" . l:command . "'")
  endif

  let l:is_win = has('win32') || has('win64')
  let l:opts = {
        \ 'dir': l:is_win ? $TEMP : '/tmp',
        \ 'sink*' : function('s:switchToFile', [l:dir]),
        \ 'down': '40%',
        \ 'options': [
        \ '--print-query',
        \ '--expect=ctrl-t,ctrl-v,ctrl-x',
        \ '--header', 'Choose existing file, or enter the name of a new file',
        \ '--prompt', 'Filename> ' 
        \ ]
        \ }

  let l:opts['source'] = 'cd ' . (l:is_win ? '/d' : '') .. l:dir .. ' && ' .. l:command . (l:is_win ? '' : ' | uniq')

  return fzf#run(fzf#wrap(l:opts))
endfunction

