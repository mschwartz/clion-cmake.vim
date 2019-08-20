
function! s:CMAKE_projectname()
  return system("grep -ri 'project(' CMakeLists.txt| head -1 | sed -e 's/[Pp][Rr][Oo][Jj][Ee][Cc][Tt].//' | sed -e 's/)//' | sed -e 's/CMakeLists.txt://' | tr -d '\\n'")
endfunction

function! s:CMAKE_clean()
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
  let cur_dir = getcwd()
  let git_dir = system("git rev-parse --show-toplevel")
  lcd `=git_dir`
  if a:configuration == "debug"
    cd cmake-build-debug
"    if filereadable("CmakeCache.txt")
"      !rm -rf Resources.h Resources.bin CMakeCache.txt CMakeFiles Makefile cmake_install.cmake
"    endif
"    !cmake -DCMAKE_BUILD_TYPE=Debug ..
  else
    cd cmake-build-release
"    if filereadable("CmakeCache.txt")
"      !rm -rf Resources.h Resources.bin CMakeCache.txt CMakeFiles Makefile cmake_install.cmake
"    endif
"    !cmake -DCMAKE_BUILD_TYPE=Release ..
  endif
  make -j 20
endfunction

function! s:CMAKE_debug()
  let l:name = s:CMAKE_projectname() 
  let l:cur_dir = getcwd()
  call s:CMAKE_build("debug")
  let l:path = name
  let l:mac = name . '.app'
  let l:git_dir = system("git rev-parse --show-toplevel")
  lcd `=l:git_dir`
  cd cmake-build-release
  if isdirectory(mac) != 0
"    let l:path = l:name . ".app/Contents/MacOS/" . l:name
    let l:path = l:name . ".app/Contents/MacOS/"
    echom mac . " IS DIRECTORY " . path
  else
    let l:cur_dir = getcwd()
    echom cur_dir . ' ' . mac . " IS NOT DIRECTORY"
  endif
"  echom l:path
"  if has('macunix')
"  lcd `./=path`
"  execute !ls
"  let l:command = '!tmux run-shell -t 1 "lldb ' .  l:name . '"'
"  let l:command = '!iterm2 -e "lldb ' .  l:name . '"'
"  echom l:command
"  execute l:command
"  vim.eval(l:command)
"  else
"    packadd termdebug
"    Termdebug
"  endif
"  Run `=path`
"  call system(path)
  lcd `=l:cur_dir`
endfunction

function! s:CMAKE_run()
  let name = s:CMAKE_projectname() 
  let cur_dir = getcwd()
  call s:CMAKE_build("debug")
  let path = name
  let mac = name . '.app'
  let git_dir = system("git rev-parse --show-toplevel")
  lcd `=git_dir`
  cd cmake-build-release
  if isdirectory(mac) != 0
    let path = name . ".app/Contents/MacOS/" . name
"    echom mac . " IS DIRECTORY " . path
  else
    let cur_dir = getcwd()
"    echom cur_dir . ' ' . mac . " IS NOT DIRECTORY"
  endif
  execute "!" . path . "&"
"  call system(path)
  lcd `=cur_dir`
endfunction

command! CMakeClean call s:CMAKE_clean()
command! CMakeRelease call s:CMAKE_build("release")
command! CMakeDebug call s:CMAKE_build("debug")
command! CMakeRun call s:CMAKE_run()

" My bindings:
"map <leader>x  <esc>:call s:CMAKE_clean()<cr>
"map <leader>b  <esc>:call s:CMAKE_build("debug")<cr>
"map <leader>d  <esc>:call s:CMAKE_debug()<cr>
"map <leader>r  <esc>:call s:CMAKE_run()<cr>
