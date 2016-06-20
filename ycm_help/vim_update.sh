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

sudo make clean
rm -f src/auto/config.cache

git pull
if [ $? -ne 0 ]; then
	echo \"git pull\" failed
	exit
fi

scl enable devtoolset-3 './configure \
	--with-features=huge \
	--with-x \
	--enable-multibyte \
	--enable-cscope \
	--enable-gui \
	--enable-pythoninterp=dynamic \
	--with-python-config-dir=/usr/lib64/python2.7/config \
	--enable-rubyinterp \
	--enable-perlinterp \
	--enable-luainterp'
if [ $? -ne 0 ]; then
	echo \"configure\" failed
	exit
fi

scl enable devtoolset-3 'sudo make install'
if [ $? -ne 0 ]; then
	echo \"make install\" failed
	exit
fi
echo Success!
