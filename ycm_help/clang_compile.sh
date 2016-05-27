#!/bin/bash
# Usage: clang_compile.sh <version> <target_dir>

if [ $# -ne 2 ]; then
	echo Usage: $0 "<version> <target_dir>"
	exit
fi

VERSION=$1
TARGET_DIR=$2

LLVM_URL=http://llvm.org/releases/${VERSION}

fetch_tar_xz()
{
	URL="$1"
	FILENAME=$(basename $URL)
	TARGET="$2"
	wget $URL
	if [ $? -ne 0 ]; then
		echo Failed to wget \"$URL\"
		exit
	fi
	echo Extracting \"$FILENAME\"
	tar -xf $FILENAME
	if [ $? -ne 0 ]; then
		echo Failed to extract from \"$FILENAME\"
		exit
	fi
	mv $(basename $FILENAME .tar.xz) $TARGET
	if [ $? -ne 0 ]; then
		echo Failed to rename \"$(basename $FILENAME .tar.xz)\" to \"$TARGET\"
		exit
	fi
	rm -f $FILENAME
}

echo Building clang $VERSION in \"$TARGET_DIR\"
mkdir $TARGET_DIR
if [ $? -ne 0 ]; then
	exit
fi

cd $TARGET_DIR
fetch_tar_xz $LLVM_URL/llvm-${VERSION}.src.tar.xz llvm

cd llvm/tools
fetch_tar_xz $LLVM_URL/cfe-${VERSION}.src.tar.xz clang
cd -

mkdir build
if [ $? -ne 0 ]; then
	exit
fi

cd build
scl enable devtoolset-3 python27 'cmake -DCMAKE_BUILD_TYPE=Release -G "Unix Makefiles" ../llvm'
if [ $? -ne 0 ]; then
	echo Failed to create makefiles
	exit
fi

scl enable devtoolset-3 python27 'make'
if [ $? -ne 0 ]; then
	echo Failed to build llvm/clang
	exit
fi

echo Success!
