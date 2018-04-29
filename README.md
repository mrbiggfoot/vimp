# vimp
This is my vim 8 configuration. Use at your own risk.

## Build vim 8 from source

Install libraries (CentOS):
```sh
sudo yum install ncurses ncurses-devel libX11-devel libXt-devel xclip
```

Build:
```sh
git clone https://github.com/vim/vim.git
cd vim/src
make distclean  # if you build Vim before
./configure --with-features=huge --enable-pythoninterp
make
sudo make install
```

## Prerequisites

- [vim-plug](https://github.com/junegunn/vim-plug)
- [ctags](https://github.com/mrbiggfoot/exuberant-ctags) with protobuf support
- [GNU idutils](http://www.gnu.org/software/idutils)

## Installation

Add the following line to your .vimrc (assuming vimp is checked out in the
home dir): `source ~/vimp/vimrc`
