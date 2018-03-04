# vimp
This is my vim 8 configuration. Use at your own risk.

## Build vim 8 from source
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
- [ctags](https://github.com/fdinoff/exuberant-ctags) with protobuf support (just because I work with protobuf a lot)
- [GNU idutils](http://www.gnu.org/software/idutils)

## Installation

Add the following line to your .vimrc (assuming vimp is checked out in the home dir):
`source ~/vimp/vimrc`

## Notes

Some key bindings may not work as I use iTerm2 with customized keyboard shortcuts.
Just remap them to whatever you want.
