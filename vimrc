
" Install vim-plug and plugins if required.
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync
endif

"------------------------------------------------------------------------------
" Load plugins.
"------------------------------------------------------------------------------
call plug#begin('~/.vim/plugged')

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'moll/vim-bbye'
Plug 'mrbiggfoot/neoview'

call plug#end()

set timeoutlen=500 ttimeoutlen=0
