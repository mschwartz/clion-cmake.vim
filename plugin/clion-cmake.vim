function! s:CMAKE_projectname()
  return system("grep -ri 'project(' CMakeLists.txt| head -1 | sed -e 's/[Pp][Rr][Oo][Jj][Ee][Cc][Tt].//' | sed -e 's/)//' | sed -e 's/CMakeLists.txt://' | tr -d '\\n'")
endfunction

function! s:CMAKE_clean()
  echom "here"
  let cur_dir = getcwd()
  let git_dir = system("git rev-parse --show-toplevel")
  lcd `=git_dir`
  !mkdir -p cmake-build-debug cmake-build-release
  cd cmake-build-debug
  !cmake -DCMAKE_BUILD_TYPE=Debug ..
  lcd `=git_dir`
  cd cmake-build-release
  !cmake -DCMAKE_BUILD_TYPE=Release ..
  lcd `=cur_dir`
endfunction

function! s:CMAKE_build(configuration)
  echom a:configuration
  let cur_dir = getcwd()
  let git_dir = system("git rev-parse --show-toplevel")
  lcd `=git_dir`
  if a:configuration == "debug"
    cd cmake-build-debug
    if filereadable("CmakeCache.txt")
      !rm -f Resources.h Resources.bin
"      !rm -rf *
    endif
    !cmake -DCMAKE_BUILD_TYPE=Debug ..
  else
    cd cmake-build-release
    if filereadable("CmakeCache.txt")
      !rm -f Resources.h Resources.bin
"      !rm -rf *
    endif
    !cmake -DCMAKE_BUILD_TYPE=Release ..
  endif
  make -j 20
endfunction

function! s:CMAKE_debug()
  let cur_dir = getcwd()
  call s:CMAKE_build("debug")
  let name = s:CMAKE_projectname() 
  if filereadable(name . '.app')
    system(name . ".app/Contents/MacOS/" + name)
  else
    system(name)
  endif
  lcd `=cur_dir`
endfunction

function! s:CMAKE_run()
  let name = s:CMAKE_projectname() 
  echom name
  let cur_dir = getcwd()
  call s:CMAKE_build("release")
  pwd
  let path = name
  let mac = name . '.app'
  let git_dir = system("git rev-parse --show-toplevel")
  lcd `=git_dir`
  cd cmake-build-release
  if isdirectory(mac) != 0
    let path = name . ".app/Contents/MacOS/" . name
    echom mac . " IS DIRECTORY " . path
  else
    let cur_dir = getcwd()
    echom cur_dir . ' ' . mac . " IS NOT DIRECTORY"
  endif
  echom path
  call system(path)
"  lcd `=cur_dir`
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
