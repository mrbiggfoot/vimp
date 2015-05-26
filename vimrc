"------------------------------------------------------------------------------
" Vundle config (plugins list)
"------------------------------------------------------------------------------

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
"Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
"Plugin 'L9'
" Git plugin not hosted on GitHub
"Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Avoid a name conflict with L9
"Plugin 'user/L9', {'name': 'newL9'}

Plugin 'Valloric/YouCompleteMe'

"Plugin 'gtags.vim'
Plugin 'Shougo/unite.vim'
"Plugin 'hewes/unite-gtags'
Plugin 'mrbiggfoot/unite-tselect2'
Plugin 'mrbiggfoot/unite-id'

Plugin 'majutsushi/tagbar'
Plugin 'vim-scripts/a.vim'

"Plugin 'kien/ctrlp.vim'
"Plugin 'bling/vim-airline'

Plugin 'octol/vim-cpp-enhanced-highlight'
"Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'Yggdroot/indentLine'
Plugin 'guns/xterm-color-table.vim'

Plugin 'moll/vim-bbye'

Plugin 'mrbiggfoot/my-colors-light'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

"------------------------------------------------------------------------------
" Plugins configuration
"------------------------------------------------------------------------------

" YouCompleteMe
let g:ycm_confirm_extra_conf = 0
let g:ycm_autoclose_preview_window_after_completion = 1

" Gtags
"set csprg=gtags-cscope
"let g:Gtags_OpenQuickfixWindow = 0 " don't open quickfix window by default
" treelize is nice, but file path coloring does not work properly
"let g:unite_source_gtags_project_config = { '_': { 'treelize': 1 } }

" Unite
call unite#custom#profile('default', 'context', {
\	'direction': 'dynamicbottom',
\	'cursor_line_time': '0.0',
\	'prompt_direction': 'top',
\	'auto_resize': 1,
\	'select': '1'
\ })
let g:prj_open_files_direction = 'dynamictop'
" Custom mappings for the unite buffer
autocmd FileType unite call s:unite_settings()
function! s:unite_settings()
	nmap <buffer> p <Plug>(unite_toggle_auto_preview)
	imap <buffer> <Tab> <C-x><Down>
	imap <buffer> <S-Tab> <C-x><Up>
	" Disable cursor looping
	silent! nunmap <buffer> <Up>
	silent! nunmap <buffer> <Down>
	" Unmap keys defined globally
	silent! nunmap <buffer> <C-p>
	silent! iunmap <buffer> <C-p>
	hi! link CursorLine PmenuSel
endfunction
call unite#custom#source('file,file/new,file_list,buffer', 'matchers', 'matcher_fuzzy')
call unite#custom#source('file,file/new,file_list,buffer', 'sorters', 'sorter_rank')

" Airline
"let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#tabline#fnamemod = ':t'

"let g:airline_section_a = ''
"let g:airline_section_b = ''

"let g:airline_theme = 'understated'

" Indent-guides
"let g:indent_guides_auto_colors = 0
"let g:indent_guides_default_mapping = 0

" indentLine
let g:indentLine_enabled = 0
let g:indentLine_faster = 1
let g:indentLine_color_term = 252

"------------------------------------------------------------------------------
" Projects configuration
"------------------------------------------------------------------------------

if has('vim_starting')
	let s:vimp_path = fnamemodify(resolve(expand('<sfile>:p')), ':h')
endif

function! s:configure_project()
	let prj_meta_root = '/home/apyatkov/projects/.meta' " must be an absolute path, or 'lid' won't work
	let cur_prj_root = getcwd()
	let cur_prj_branch = system('git rev-parse --abbrev-ref HEAD 2>/dev/null')
	let cur_prj_branch = substitute(cur_prj_branch, '\n', '', '')
	let cur_prj_meta_root = prj_meta_root . cur_prj_root . '/' . cur_prj_branch

	if isdirectory(cur_prj_meta_root)
		"let cur_prj_gtags = cur_prj_meta_root . "/GTAGS"
		let cur_prj_ctags = cur_prj_meta_root . "/tags"

		" The following line is needed for Unite project files opener key mapping
		let g:cur_prj_files = cur_prj_meta_root . "/files"

		" The following line specifies the IDs db path for unite-id plugin
		let g:unite_ids_db_path = cur_prj_meta_root . "/ID"

		"let $GTAGSGLOBAL="GTAGSROOT=" . cur_prj_root . " GTAGSDBPATH=" . cur_prj_meta_root . " global"
		"cscope add cur_prj_gtags
		exec "set tags=" . cur_prj_ctags . ";"

		"exec "let g:ctrlp_user_command = [ cur_prj_root, 'cat " . prj_meta_root . "/%s/files' ]"
	endif
endfunction

call s:configure_project()

function! s:update_project()
	exec '!' . s:vimp_path . '/project_generate.sh'
	call s:configure_project()
endfunction

"------------------------------------------------------------------------------
" Keyboard shortcuts
"------------------------------------------------------------------------------

" Enter insert mode - F13 on Mac
nnoremap <Esc>[1;2P :startinsert<CR>

" Word navigation
nnoremap <Esc>b b
nnoremap <Esc>f e

inoremap <Esc>b <C-Left>
inoremap <Esc>f <C-Right>
" Ctrl-left|right on Mac
inoremap <Esc>[1;5D <C-Left>
inoremap <Esc>[1;5C <C-Right>

" Opt-up|down scrolling
nnoremap <Esc>[1;9B <C-e>
nnoremap <Esc>[1;9A <C-y>
inoremap <Esc>[1;9B <C-x><C-e>
inoremap <Esc>[1;9A <C-x><C-y>
"inoremap <Esc>[1;9B <C-o><C-e>
"inoremap <Esc>[1;9A <C-o><C-y>

" Ctrl-up|down scrolling
nnoremap <C-Down> <C-e>
nnoremap <C-Up> <C-y>
inoremap <C-Down> <C-x><C-e>
inoremap <C-Up> <C-x><C-y>
"inoremap <C-Down> <C-o><C-e>
"inoremap <C-Up> <C-o><C-y>

" Window navigation: Shift-arrows
inoremap <Esc>[1;2D <C-o><C-w><Left>
inoremap <Esc>[1;2C <C-o><C-w><Right>
inoremap <Esc>[1;2A <C-o><C-w><Up>
inoremap <Esc>[1;2B <C-o><C-w><Down>

nnoremap <Esc>[1;2D <C-w><Left>
nnoremap <Esc>[1;2C <C-w><Right>
nnoremap <Esc>[1;2A <C-w><Up>
nnoremap <Esc>[1;2B <C-w><Down>

" Buffer navigation
" Ctrl-left|right
nnoremap <Esc>[1;5D :bprev<CR>
nnoremap <Esc>[1;5C :bnext<CR>
" Cmd-Alt-left|right
nnoremap <Esc>[1;9D :bprev<CR>
nnoremap <Esc>[1;9C :bnext<CR>
inoremap <Esc>[1;9D <C-o>:bprev<CR>
inoremap <Esc>[1;9C <C-o>:bnext<CR>

" Enhance '<' '>' - do not need to reselect the block after shift it.
vnoremap < <gv
vnoremap > >gv

" Close buffer
nnoremap <leader>q :Bdelete<CR>

" Alt-c|v - copy/paste from X clipboard.
vnoremap ç "+y
nnoremap ç V"+y:echo "1 line yanked"<CR>
nnoremap √ "+P
inoremap √ <C-o>"+P

" Alt-/ - switch to correspondent header/source file
nnoremap ÷ :A<CR>
inoremap ÷ <C-o>:A<CR>
" Alt-Shift-/ - swich to file under cursor
nnoremap ¿ :IH<CR>
inoremap ¿ <C-O>:IH<CR>

function! ToggleColorColumn()
  if &colorcolumn == 0
    set colorcolumn=80
  else
    set colorcolumn=0
  endif
endfunction
nnoremap <F7> :call ToggleColorColumn()<CR>
inoremap <F7> <C-o>:call ToggleColorColumn()<CR>

nnoremap <leader>8 :vertical resize 90<CR>

function! DupRight()
  let l:cur_wnd = winnr()
  let l:cur_view = winsaveview()
  let l:cur_buf = bufnr('%')
  exec "wincmd l"
  if winnr() == l:cur_wnd
    exec "wincmd v"
    exec "wincmd l"
  endif
  exec "b " . l:cur_buf
  call winrestview(l:cur_view)
endfunction
nnoremap <Bar> :call DupRight()<CR>

function! TSRight()
  let l:cur_wnd = winnr()
  let l:cur_view = winsaveview()
  let l:cur_buf = bufnr('%')
  let l:tag = expand("<cword>")
  exec "wincmd l"
  if winnr() == l:cur_wnd
    exec "wincmd v"
    exec "wincmd l"
  endif

  exec "b ".l:cur_buf
  call winrestview(l:cur_view)
  exec "Unite -immediately tselect:".l:tag
"  exec "3match ex_SynObjectLine /".l:tag."/"
"  exec "redraw"
"  exec "wincmd h"
endfunction
nnoremap <C-\> :call TSRight()<CR>
inoremap <C-\> <C-o>:call TSRight()<CR>
nnoremap « :call TSRight()<CR>
inoremap « <C-o>:call TSRight()<CR>

" F8 - clear highlight of the last search until the next search
nnoremap <Esc>[19~ :noh<CR>
inoremap <Esc>[19~ <C-o>:noh<CR>

function! StartOrCloseUnite(unite_cmd)
"	let unite_winnr = unite#helper#get_unite_winnr('default')
	let unite_winnr = unite#get_unite_winnr('default')
	if unite_winnr > 0
		exec "Unite -toggle"
	else
		exec a:unite_cmd
	endif
endfunction

function! StartOrCloseUniteCallCmd(unite_cmd)
	return ':call StartOrCloseUnite("' . a:unite_cmd . '")<CR>'
endfunction

" F12 - find definitions of the word under cursor
let s:f12_cmd = StartOrCloseUniteCallCmd('Unite tselect:<C-r><C-w>')
exec 'nnoremap <Esc>[24~ ' . s:f12_cmd
exec 'inoremap <Esc>[24~ <Esc>' . s:f12_cmd

" Shift-F12 - find references to the word under cursor using lid (IDs db)
let s:s_f12_cmd = StartOrCloseUniteCallCmd('Unite id/lid:<C-r><C-w>:-w')
exec 'nnoremap <Esc>[24;2~ ' . s:s_f12_cmd
exec 'inoremap <Esc>[24;2~ <Esc>' . s:s_f12_cmd

" Alt-F12 - find references to the word under cursor using lid (IDs db)
let s:a_f12_cmd = StartOrCloseUniteCallCmd('Unite id/lid:<C-r><C-w>:-r')
exec 'nnoremap <Esc>[24;4~ ' . s:a_f12_cmd
exec 'inoremap <Esc>[24;4~ <Esc>' . s:a_f12_cmd

" Cmd-F9|F10 - backward/forward jump stack navigation
nnoremap <Esc>[20;3~ <C-o><CR>
nnoremap <Esc>[21;3~ <C-i><CR>

" Ctrl-P - open list of files
if exists("g:cur_prj_files")
	let s:ctrl_p_cmd = 'Unite -direction=' . g:prj_open_files_direction .
	\ ' -start-insert file_list:' . g:cur_prj_files
else
	let s:ctrl_p_cmd = 'Unite -direction=' . g:prj_open_files_direction .
	\ ' -start-insert file'
endif
exec 'nnoremap <C-p> ' . StartOrCloseUniteCallCmd(s:ctrl_p_cmd)
exec 'inoremap <C-p> <Esc>' . StartOrCloseUniteCallCmd(s:ctrl_p_cmd)

" F11 - toggle default Unite window
function! ToggleUniteWindow()
"	let unite_winnr = unite#helper#get_unite_winnr('default')
	let unite_winnr = unite#get_unite_winnr('default')
	if unite_winnr > 0
		exec unite_winnr . "wincmd w"
		let g:last_unite_view = winsaveview()
		exec "Unite -toggle"
	else
		exec "UniteResume"
		if exists("g:last_unite_view")
			call winrestview(g:last_unite_view)
		endif
	endif
endfunction
nnoremap <Esc>[23~ :call ToggleUniteWindow()<CR>
inoremap <Esc>[23~ <Esc>:call ToggleUniteWindow()<CR>

" F10 - toggle tag bar
nnoremap <F10> :TagbarToggle<CR>
inoremap <F10> <C-x>:TagbarToggle<CR>

" F4 - toggle indent guides
nmap <F4> :IndentLinesToggle<CR>
imap <F4> <C-o>:IndentLinesToggle<CR>

" F3 - browse buffers
let s:f3_cmd = StartOrCloseUniteCallCmd('Unite buffer')
exec 'nnoremap <F3> ' . s:f3_cmd
exec 'inoremap <F3> <Esc>' . s:f3_cmd

"------------------------------------------------------------------------------
" Custom commands
"------------------------------------------------------------------------------

" F - find a pattern in the IDs database (case sensitive)
command! -nargs=1 -complete=tag F :Unite id/lid:<args>:-r

" FW - find an exact word in the IDs database (case sensitive)
command! -nargs=1 -complete=tag FW :Unite id/lid:<args>:-w

" FC - find a pattern in the IDs database (case insensitive)
command! -nargs=1 -complete=tag FC :Unite id/lid:<args>:-r\ -i

" FWC - find an exact word in the IDs database (case insensitive)
command! -nargs=1 -complete=tag FWC :Unite id/lid:<args>:-w\ -i
" ...and alias:
command! -nargs=1 -complete=tag FCW :Unite id/lid:<args>:-w\ -i

" FT - find a tag (case insensitive)
command! -nargs=1 -complete=tag FT :Unite tselect:<args>

" Up - update project metadata
command! Up :call s:update_project()

"------------------------------------------------------------------------------
" Misc configuration
"------------------------------------------------------------------------------

" Make Backspace work
set backspace=indent,eol,start

" Catch mouse events
set mouse=a

" Disable wrapping
set nowrap

" Vim UI
set wildmenu " turn on wild menu, try typing :h and press <Tab>
set showcmd	" display incomplete commands
set cmdheight=1 " 1 screen lines to use for the command-line
set ruler " show the cursor position all the time
set hid " allow to change buffer without saving
set shortmess=atI " shortens messages to avoid 'press a key' prompt
set lazyredraw " do not redraw while executing macros (much faster)
set display+=lastline " for easy browse last line with wrap text
set laststatus=2 " always have status-line

" Show line numbers
set number

" Search (/)
set hls " Enable search pattern highlight
set incsearch " Do incremental searching
set ignorecase " Set search/replace pattern to ignore case
set smartcase " Set smartcase mode on, If there is upper case character in the search patern, the 'ignorecase' option will be override.

" Common indent settings
set shiftwidth=4
set tabstop=4
set sts=4
set noexpandtab
set autoindent
set smartindent
"see help cinoptions-values for more details
set	cinoptions=>s,e0,n0,f0,{0,}0,^0,:0,=s,l0,b0,g0,hs,ps,ts,is,+s,c3,C0,0,(0,us,U0,w0,W0,m0,j0,)20,*30

" File type specific indent settings
autocmd FileType c,cpp,proto,python,cmake setlocal sw=2 ts=2 sts=2 expandtab autoindent

" Highlight lines >= 80 chars and trailing whitespaces
function! HighlightFormatting()
  if &filetype == 'cpp' || &filetype == 'c' || &filetype == 'proto' ||
  \ &filetype == 'python' || &filetype == 'cmake' || &filetype == 'vim'
"    highlight OverLength ctermbg=red ctermfg=white
"    match OverLength /\%80v.\+/
    highlight WhiteSpaceEOL ctermbg=gray
    2match WhiteSpaceEOL /\s\+$/
  endif
endfunction
autocmd BufNewFile,BufReadPost,WinEnter * call HighlightFormatting()

" Show syntax highlighting groups for word under cursor
nmap <leader>s :call <SID>SynStack()<CR>
function! <SID>SynStack()
	if !exists("*synstack")
		return
	endif
	echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" Enable syntax highlighting. In iTerm2, select 'Light Background' palette.
syntax on
colorscheme my_colors_light
