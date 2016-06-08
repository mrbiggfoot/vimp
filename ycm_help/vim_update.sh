#!/bin/bash
# Usage: vim_update.sh <vim_git_repo_dir>

if [ $# -ne 1 ]; then
	echo Usage: $0 "<vim_git_repo_dir>"
	exit
fi

cd $1
if [ $? -ne 0 ]; then
	echo \"cd $1\" failed
	exit
fi

git pull
if [ $? -ne 0 ]; then
	echo \"git pull\" failed
	exit
fi

./configure \
	--with-features=huge \
	--with-x \
	--enable-multibyte \
	--enable-cscope \
	--enable-gui \
	--enable-pythoninterp \
	--enable-rubyinterp \
	--enable-perlinterp \
	--enable-luainterp
if [ $? -ne 0 ]; then
	echo \"configure\" failed
	exit
fi

sudo make install
