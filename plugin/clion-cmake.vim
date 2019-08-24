
function! s:CMAKE_projectname()
  return system("grep -ri 'project(' CMakeLists.txt| head -1 | sed -e 's/[Pp][Rr][Oo][Jj][Ee][Cc][Tt].//' | sed -e 's/)//' | sed -e 's/CMakeLists.txt://' | tr -d '\\n'")
endfunction

function! s:CMAKE_clean()
  let cur_dir = getcwd()
  let git_dir = system("git rev-parse --show-toplevel")
  lcd `=git_dir`
  call VimuxRunCommand("rm -rf cmake-build-debug cmake-build-release && mkdir -p cmake-build-debug cmake-build-release")
  call VimuxRunCommand("cd cmake-build-debug && cmake -DCMAKE_BUILD_TYPE=Debug ..")
  call VimuxRunCommand("cd cmake-build-release && cmake -DCMAKE_BUILD_TYPE=Release ..")
"  !rm -rf cmake-build-debug
"  !mkdir -p cmake-build-debug cmake-build-release
"  cd cmake-build-debug
"  !rm Resources.bin
"  !cmake -DCMAKE_BUILD_TYPE=Debug ..
"  lcd `=git_dir`
"  cd cmake-build-release
"  !cmake -DCMAKE_BUILD_TYPE=Release ..
  lcd `=cur_dir`
endfunction

function! s:CMAKE_build(configuration)
  let cur_dir = getcwd()
  let git_dir = system("git rev-parse --show-toplevel")
  lcd `=git_dir`
"  if a:configuration == "debug"
    call VimuxRunCommand("cmake --build cmake-build-debug  --target Modite -- -j 20")
"    cd cmake-build-debug
"    if filereadable("CmakeCache.txt")
"      !rm -rf Resources.h Resources.bin CMakeCache.txt CMakeFiles Makefile cmake_install.cmake
"    endif
"    !cmake -DCMAKE_BUILD_TYPE=Debug ..
"  else
"    !cmake --build cmake-build-debug  --target Modite -- -j 20
"    cd cmake-build-release
"    if filereadable("CmakeCache.txt")
"      !rm -rf Resources.h Resources.bin CMakeCache.txt CMakeFiles Makefile cmake_install.cmake
"    endif
"    !cmake -DCMAKE_BUILD_TYPE=Release ..
"  endif
  "/Users/mschwartz/Library/Application Support/JetBrains/Toolbox/apps/CLion/ch-0/192.5728.100/CLion.app/Contents/bin/cmake/mac/bin/cmake" --build 
"  /Users/mschwartz/github/ModusCreateOrg/modite-adventure/cmake-build-debug --target Modite -- -j 10
"  make -j 20
endfunction

function! s:CMAKE_debug()
  let git_dir = substitute(system("git rev-parse --show-toplevel"), '\n\+$', '', 'g')
  let project = substitute(s:CMAKE_projectname() , '\n\+$', '', 'g')
  let name = project
  let cur_dir = getcwd()
  call s:CMAKE_build("debug")
  let path = './cmake-build-debug/' . name
  let mac = './cmake-build-debug/' . project . '.app'

  lcd `=git_dir`
  cd cmake-build-debug
  lcd `=git_dir`

  if isdirectory(mac) != 0
    let path = name . ".app/Contents/MacOS/" . name
"    echom mac . " IS DIRECTORY " . path
  else
    let cur_dir = getcwd()
"    echom cur_dir . ' ' . mac . " IS NOT DIRECTORY"
  endif
"  echom path
"  call VimuxRunCommand("ls -l")
  call VimuxRunCommand("/usr/bin/lldb ./cmake-build-debug/" .path)
  lcd `=cur_dir`
  
  
endfunction

function! s:CMAKE_run()
  let git_dir = substitute(system("git rev-parse --show-toplevel"), '\n\+$', '', 'g')
"  call VimuxRunCommand("echo git_dir " . git_dir)
  let project = substitute(s:CMAKE_projectname() , '\n\+$', '', 'g')
  let name = project
"  call VimuxRunCommand("echo name " . name)
  let cur_dir = getcwd()
  call s:CMAKE_build("debug")
  let path = './cmake-build-debug/' . name
  let mac = './cmake-build-debug/' . project . '.app'

  lcd `=git_dir`
  cd cmake-build-debug
  lcd `=git_dir`

  if isdirectory(mac) != 0
    let path = name . ".app/Contents/MacOS/" . name
"    echom mac . " IS DIRECTORY " . path
  else
    let cur_dir = getcwd()
"    echom cur_dir . ' ' . mac . " IS NOT DIRECTORY"
  endif
"  echom path
"  call VimuxRunCommand("ls -l")
  let command = "./cmake-build-debug/" .path
"  echom command
  call VimuxRunCommand(command)
"  execute "!" . path . "&"
"  call system(path)
  lcd `=cur_dir`
endfunction

command! CMakeClean call s:CMAKE_clean()
command! CMakeRelease call s:CMAKE_build("release")
"command! CMakeDebug call s:CMAKE_build("debug")
command! CMakeDebug call s:CMAKE_debug()
command! CMakeRun call s:CMAKE_run()

" My bindings:
"map <leader>x  <esc>:call s:CMAKE_clean()<cr>
"map <leader>b  <esc>:call s:CMAKE_build("debug")<cr>
"map <leader>d  <esc>:call s:CMAKE_debug()<cr>
"map <leader>r  <esc>:call s:CMAKE_run()<cr>
