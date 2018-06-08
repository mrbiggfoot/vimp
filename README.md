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
make distclean  # if you built Vim before
./configure --with-features=huge --enable-pythoninterp --without-x --enable-gui=no
make
sudo make install
```

## Prerequisites

- [ctags](https://github.com/mrbiggfoot/exuberant-ctags) with protobuf support
- [ripgrep](https://github.com/BurntSushi/ripgrep)

## Installation

Add the following line to your .vimrc (assuming vimp is checked out in the
home dir): `source ~/vimp/vimrc`
