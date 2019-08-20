# clion-cmake.vim

Implements CLion friendly/compatible vim commands for working with CMake projects.

## Commands

This plugin implements 4 comamnds:
* CMakeClean - clean project
* CMakeBuild - build (debug) version of project
* CMakeDebug - build and run debug version under debugger
* CMakeRun - build and run release version

Bind your favorite keys to those commands.

## Details

The project name is found in the CMakeLists.txt PROJECT() line.  This becomes the output binary or .app (Mac) name.

Like CLion, builds are done in cmake-build-debug/ and cmake-build-release/.




