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
./configure --with-features=huge --enable-pythoninterp --without-x --enable-gui=no --enable-python3interp --with-python3-config-dir=/usr/lib/python3.9/config-3.9-x86_64-linux-gnu/
make
sudo make install
```

## Prerequisites

- [vim-plug](https://github.com/junegunn/vim-plug)
- [ctags](https://github.com/universal-ctags/ctags)
- [ripgrep](https://github.com/BurntSushi/ripgrep)
- Make sure [look](http://manpages.ubuntu.com/manpages/jammy/man1/look.1.html) is available for [neoview](https://github.com/mrbiggfoot/neoview)

## Installation

- Use terminal config (`dconf load /org/mate/terminal/ < mate-terminal.conf` for mate-terminal)
- Use the `inputrc` and `screenrc` files
- Add the following line to your .vimrc (assuming vimp is checked out in the
  home dir): `source ~/vimp/vimrc`
- [Install vim-plug](https://github.com/junegunn/vim-plug#installation)
- Start vim and run `PlugInstall`
- Restart shell
- Add this to .bashrc to make the terminal window title show current directory:
  `PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033]0;%s\007" "${PWD/#$HOME/\~}"'`
