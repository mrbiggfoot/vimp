# vimp
This is my vim 8 configuration. Use at your own risk.

## Build vim 8 from source

### CentOS 7
Install libraries:
```sh
sudo yum install ncurses ncurses-devel libX11-devel libXt-devel xclip python3-devel
```

Build:
```sh
git clone https://github.com/vim/vim.git
cd vim/src
make distclean  # if you built Vim before
./configure --with-features=huge --enable-pythoninterp --without-x --enable-gui=no --enable-python3interp --with-python3-config-dir=/usr/lib64/python3.6/config-3.6m-x86_64-linux-gnu
make
sudo make install
```

### Ubuntu
Install libraries:
```sh
sudo apt install python3-distutils libncurses-dev python-dev python3-dev
```

Build:
```sh
git clone https://github.com/vim/vim.git
cd vim/src
make distclean  # if you built Vim before
./configure --with-features=huge --enable-pythoninterp --without-x --enable-gui=no --enable-python3interp --with-python3-config-dir=/usr/lib/python3.8/config-3.8-aarch64-linux-gnu/
make
sudo make install
```

## Prerequisites

- [ctags](https://github.com/mrbiggfoot/exuberant-ctags) with protobuf support
- [ripgrep](https://github.com/BurntSushi/ripgrep)

## Installation

Add the following line to your .vimrc (assuming vimp is checked out in the
home dir): `source ~/vimp/vimrc`
