
function! s:CMAKE_projectname()
  return substitute(system("grep -ri 'project(' CMakeLists.txt| head -1 | sed -e 's/[Pp][Rr][Oo][Jj][Ee][Cc][Tt].//' | sed -e 's/)//' | sed -e 's/CMakeLists.txt://' | tr -d '\\n'"), '\n+$', '', 'g')
endfunction

function! s:CMAKE_clean()
  let git_dir = system("git rev-parse --show-toplevel")
  lcd `=git_dir`
  call VimuxRunCommand("rm -rf cmake-build-debug cmake-build-release && mkdir -p cmake-build-debug && mkdir -p cmake-build-release")
  call VimuxRunCommand("cd cmake-build-debug && cmake -DCMAKE_BUILD_TYPE=Debug ..")
  call VimuxRunCommand("cd ../cmake-build-release && cmake -DCMAKE_BUILD_TYPE=Release ..")
  call VimuxRunCommand("cd ..")
  lcd `=git_dir`
endfunction

function! s:CMAKE_build(configuration)
  let git_dir = system("git rev-parse --show-toplevel")
  lcd `=git_dir`
  call VimuxRunCommand("cmake --build cmake-build-debug  --target Modite -- -j 20")
endfunction

function! s:CMAKE_debug()
  let git_dir = substitute(system("git rev-parse --show-toplevel"), '\n\+$', '', 'g')
  let project = s:CMAKE_projectname()
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
  else
    let cur_dir = getcwd()
  endif
"  call VimuxRunCommand("/usr/bin/lldb ./cmake-build-debug/" .path)
  call VimuxRunCommand("/usr/bin/cgdb ./cmake-build-debug/" .path)
  lcd `=cur_dir`
endfunction

function! s:CMAKE_run()
  let git_dir = substitute(system("git rev-parse --show-toplevel"), '\n\+$', '', 'g')
  let project = s:CMAKE_projectname()
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
  else
    let path = project
  endif
  let command = "./cmake-build-debug/" .path
  echom command
  call VimuxRunCommand(command)
  lcd `=git_dir`
endfunction

command! CMakeClean call s:CMAKE_clean()
command! CMakeRelease call s:CMAKE_build("release")
command! CMakeDebug call s:CMAKE_debug()
command! CMakeRun call s:CMAKE_run()

" My bindings:
"map <leader>x  <esc>:call s:CMAKE_clean()<cr>
"map <leader>b  <esc>:call s:CMAKE_build("debug")<cr>
"map <leader>d  <esc>:call s:CMAKE_debug()<cr>
"map <leader>r  <esc>:call s:CMAKE_run()<cr>
