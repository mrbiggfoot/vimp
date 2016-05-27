#!/bin/sh

rm -Rf ~/ycm_build
mkdir ~/ycm_build
cd ~/ycm_build
scl enable devtoolset-3 'cmake -G "Unix Makefiles" -DEXTERNAL_LIBCLANG_PATH=~/projects/libclang_3.8/build/lib/libclang.so.3.8 . ~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp'
scl enable devtoolset-3 'cmake --build . --target ycm_core --config Release'
