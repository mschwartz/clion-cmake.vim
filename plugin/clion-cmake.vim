function! s:CMAKE_projectname()
  return system("grep -ri 'project(' CMakeLists.txt| head -1 | sed -e 's/[Pp][Rr][Oo][Jj][Ee][Cc][Tt].//' | sed -e 's/)//' | sed -e 's/CMakeLists.txt://' | tr -d '\\n'")
endfunction

function! s:CMAKE_clean()
  let git_dir = system("git rev-parse --show-toplevel")
  lcd `=git_dir`
  cd cmake-build-debug
  !cmake -DCMAKE_BUILD_TYPE=Debug ..
  lcd `=git_dir`
  cd cmake-build-release
  !cmake -DCMAKE_BUILD_TYPE=Release ..
endfunction

function! s:CMAKE_build(configuration)
  echom a:configuration
  let git_dir = system("git rev-parse --show-toplevel")
  lcd `=git_dir`
  if a:configuration == "debug"
    cd cmake-build-debug
    !rm -f Resources.h Resources.bin
"    !rm -rf *
    !cmake -DCMAKE_BUILD_TYPE=Debug ..
  else
    cd cmake-build-release
    !rm -f Resources.h Resources.bin
"    !rm -rf *
    !cmake -DCMAKE_BUILD_TYPE=Release ..
  endif
  make VERBOSE=1 -j 20
endfunction

function! s:CMAKE_debug()
  call s:CMAKE_build("debug")
  !./Modite
endfunction

function! s:CMAKE_run()
  call s:CMAKE_build("release")
  pwd
  !./Modite
endfunction

command! CMakeClean call s:CMAKE_clean()
command! CMakeBuild call s:CMAKE_build("debug")
command! CMakeDebug call s:CMAKE_debug()
command! CMakeRun call s:CMAKE_run()

"map <leader>x  <esc>:call s:CMAKE_clean()<cr>
"map <leader>b  <esc>:call s:CMAKE_build("debug")<cr>
"map <leader>d  <esc>:call s:CMAKE_debug()<cr>
"map <leader>r  <esc>:call s:CMAKE_run()<cr>

"let name = s:CMAKE_projectname() 
"echom name
