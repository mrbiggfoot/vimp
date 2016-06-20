#!/bin/sh

rm -Rf ~/ycm_build
mkdir ~/ycm_build
cd ~/ycm_build
scl enable devtoolset-3 python27 'cmake -G "Unix Makefiles" \
	-DEXTERNAL_LIBCLANG_PATH=~/projects/libclang_3.8/build/lib/libclang.so.3.8 \
	-DPYTHON_LIBRARY=/usr/lib64/libpython2.7.so.1.0 \
	-DPYTHON_INCLUDE_DIR=/usr/include/python2.7 \
	. ~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp'
scl enable devtoolset-3 python27 'cmake --build . --target ycm_core --config Release'
