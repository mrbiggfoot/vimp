
" Install vim-plug and plugins if required.
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync
endif

" Deoplete/mucomplete switch.
let s:deoplete = 1

" Whether gtags should be autoupdated on write.
let g:gtags_auto_update = 1

"------------------------------------------------------------------------------
" Load plugins.
"------------------------------------------------------------------------------
call plug#begin('~/.vim/plugged')

Plug 'moll/vim-bbye'
Plug 'mrbiggfoot/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'mrbiggfoot/neoview'
Plug 'mrbiggfoot/fzf.vim'
Plug 'mrbiggfoot/vim-oscyank'

Plug 'vim-scripts/a.vim'
Plug 'Yggdroot/indentLine'
Plug 'dense-analysis/ale'
Plug 'vim-python/python-syntax'
if v:version > 800 || (v:version == 800 && has('patch1453'))
  Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
endif
Plug 'zchee/vim-flatbuffers'
Plug 'mrbiggfoot/vim-tmux-navigator'

Plug 'mrbiggfoot/vim-cpp-enhanced-highlight'
if $VIMP_COLOR_SCHEME == 'solarized_dark'
  Plug 'lifepillar/vim-solarized8'
else
  Plug 'mrbiggfoot/my-colors-light'
endif

Plug 'Shougo/unite.vim'
if exists('s:deoplete') && has('python3')
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
else
  Plug 'lifepillar/vim-mucomplete'
endif

call plug#end()

"------------------------------------------------------------------------------
" Plugins configuration
"------------------------------------------------------------------------------

if exists('s:deoplete') && has('python3')
  let g:deoplete#enable_at_startup = 1
  inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
else
  " MuComplete
  set completeopt=menuone
  if v:version > 704 || (v:version == 704 && has('patch775'))
    set completeopt+=noselect,noinsert
    set belloff+=ctrlg " If Vim beeps during completion
  endif
  "set completeopt+=fuzzy  " Works only in 'mrbiggfoot/[neo]vim'
  set complete=.,w,b,u
  let g:mucomplete#enable_auto_at_startup = 1
  let g:mucomplete#chains = {}
  let g:mucomplete#chains.default = ['path', 'c-n', 'dict', 'uspl']
  let g:mucomplete#chains.vim = ['path', 'c-n', 'cmd']
  let g:mucomplete#chains.cpp = ['path', 'c-n', 'tags']
  let g:mucomplete#chains.c = g:mucomplete#chains.cpp
  let g:mucomplete#chains.python = ['path', 'c-n', 'tags']
  let g:mucomplete#chains.unite = []
  set shortmess+=c   " Shut off completion messages
endif

" neoview
let g:neoview_fzf_common_opt = '--reverse --bind=tab:down
  \ --bind=ctrl-s:line-up --bind=ctrl-x:line-down'

if has('terminal')
  " Ctrl-up|down - scroll search by one line
  tnoremap <expr><silent> <C-Up> neoview#is_search_win() ? "\<C-s>" : "\<C-Up>"
  tnoremap <expr><silent> <C-Down> neoview#is_search_win() ?
    \ "\<C-x>" : "\<C-Down>"

  " Opt-. and Opt-; preview scrolling (1 line)
  tnoremap <silent> … <C-\><C-n>
    \ :call neoview#feed_keys_to_preview("\<lt>C-y>")<CR>
  tnoremap <silent> ≥ <C-\><C-n>
    \ :call neoview#feed_keys_to_preview("\<lt>C-e>")<CR>
  tnoremap <silent> <Esc>; <C-\><C-n>
    \ :call neoview#feed_keys_to_preview("\<lt>C-y>")<CR>
  tnoremap <silent> <Esc>. <C-\><C-n>
    \ :call neoview#feed_keys_to_preview("\<lt>C-e>")<CR>

  " Opt-, and Opt-l preview scrolling (page)
  tnoremap <silent> ¬ <C-\><C-n>
    \ :call neoview#feed_keys_to_preview("\<lt>PageUp>")<CR>
  tnoremap <silent> ≤ <C-\><C-n>
    \ :call neoview#feed_keys_to_preview("\<lt>PageDown>")<CR>
  tnoremap <silent> <Esc>l <C-\><C-n>
    \ :call neoview#feed_keys_to_preview("\<lt>PageUp>")<CR>
  tnoremap <silent> <Esc>, <C-\><C-n>
    \ :call neoview#feed_keys_to_preview("\<lt>PageDown>")<CR>
endif

" Unite
call unite#custom#profile('default', 'context', {
\ 'direction': 'dynamicbottom',
\ 'cursor_line_time': '0.0',
\ 'prompt_direction': 'top',
\ 'auto_resize': 1,
\ 'select': '1'
\ })
" Custom mappings for the unite buffer
autocmd FileType unite call s:unite_settings()
function! s:unite_settings()
  nmap <buffer> p <Plug>(unite_toggle_auto_preview)
  nmap <buffer> <Esc> <Plug>(unite_exit)
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
call unite#custom#source('file,file/new,file_list,buffer', 'matchers',
  \'matcher_fuzzy')
call unite#custom#source('file,file/new,file_list,buffer', 'sorters',
  \'sorter_rank')

" indentLine
let g:indentLine_enabled = 0
let g:indentLine_faster = 1
let g:indentLine_color_term = 252

" ALE
let g:ale_lint_delay = 1000

" Disable ALE until the first insert mode entering
let g:ale_enabled = 0
autocmd InsertEnter * if !exists('g:no_ale') | let g:no_ale = 1 |
  \ ALEEnable | endif

if filereadable("./.ale_cfg.vim")
  silent source ./.ale_cfg.vim
else
  let g:no_ale = 1
endif

augroup ALEProgress
    autocmd!
    autocmd User ALELintPre  redrawstatus!
    autocmd User ALELintPost redrawstatus!
augroup end

" python-syntax
let g:python_version_2 = 1
let g:python_highlight_all = 1

" vim-go
let g:go_fmt_autosave = 0

" vim-tmux-navigator
let g:tmux_navigator_no_mappings = 1
let g:tmux_navigator_no_wrap = 1

nnoremap <silent> <S-Left> :TmuxNavigateLeft<cr>
nnoremap <silent> <S-Down> :TmuxNavigateDown<cr>
nnoremap <silent> <S-Up> :TmuxNavigateUp<cr>
nnoremap <silent> <S-Right> :TmuxNavigateRight<cr>
nnoremap <silent> <C-\> :TmuxNavigatePrevious<cr>

inoremap <silent> <S-Left> <C-o>:TmuxNavigateLeft<cr>
inoremap <silent> <S-Down> <C-o>:TmuxNavigateDown<cr>
inoremap <silent> <S-Up> <C-o>:TmuxNavigateUp<cr>
inoremap <silent> <S-Right> <C-o>:TmuxNavigateRight<cr>
inoremap <silent> <C-\> <C-o>:TmuxNavigatePrevious<cr>

"------------------------------------------------------------------------------
" Projects configuration
"------------------------------------------------------------------------------

if has('vim_starting')
  let s:vimp_path = fnamemodify(resolve(expand('<sfile>:p')), ':h')
endif

" Read project config from g:prj_settings_sh file
function! ReadProjectConfig()
  if !filereadable(g:prj_settings_sh)
    let g:prj_tags_type = ''
    return
  endif

  let lines = readfile(g:prj_settings_sh)
  for line in lines
    let str = matchstr(line, '^\s*PRJ_TAGS\s*=\s*\zs\w\+\ze\s*$')
    if !empty(str)
      let g:prj_tags_type = str
    endif

    let str = matchstr(line,
      \ '^\s*PRJ_GTAGS_NUM_INSTANCES\s*=\s*\zs\d\+\ze\s*$')
    if !empty(str)
      let g:prj_gtags_num_instances = str
    endif
  endfor
endfunction

function! s:configure_project()
  " prj_meta_root must be an absolute path, or 'lid' won't work
  if !empty($VIMP_PROJECTS_META_ROOT)
    let prj_meta_root = $VIMP_PROJECTS_META_ROOT
  else
    let prj_meta_root = $HOME . '/projects/.meta'
  endif
  let prj_root = getcwd()
  let g:prj_meta_root = prj_meta_root . prj_root

  let prj_branch = system('git rev-parse --abbrev-ref HEAD 2>/dev/null')
  let prj_branch = substitute(prj_branch, '\n', '', '')
  if !empty(prj_branch)
    let g:prj_meta_root = g:prj_meta_root . '/' . prj_branch
  endif

  let g:prj_settings_sh = g:prj_meta_root . '/project_settings.sh'

  call ReadProjectConfig()

  if isdirectory(g:prj_meta_root)
    let g:prj_ctags = g:prj_meta_root . "/tags"

    let g:prj_tagnames = g:prj_meta_root . "/tagnames"

    " Used only when g:prj_gtags_num_instances is 0
    let g:prj_gtags = g:prj_meta_root . "/GTAGS"
    let g:prj_grtags = g:prj_meta_root . "/GRTAGS"

    " The following line is needed for project files opener
    let g:prj_files = g:prj_meta_root . "/files"

    exec "set tags=" . g:prj_ctags . ";"
  endif
endfunction

call s:configure_project()

function! s:update_project(args)
  exec '!' . s:vimp_path . '/project_generate.sh ' . a:args
  call s:configure_project()
endfunction

"------------------------------------------------------------------------------
" Neoview find functions
"------------------------------------------------------------------------------

" Finds the pattern either in the project files or in all files, based on
" the 'in_project' value.
function! FindPattern(pattern, in_project, ripgrep_opt)
  let rg_opt = "--follow --colors 'path:fg:blue' --colors 'path:style:bold' " .
    \ a:ripgrep_opt
  if a:in_project
    if exists('g:prj_files') && filereadable(g:prj_files)
      let arg = neoview#fzf#ripgrep_arg(a:pattern, rg_opt)
      let arg.source = 'xargs -d ''\n'' -a "' . g:prj_files .
        \ '" ' . arg.source
    elseif filereadable(g:prj_settings_sh)
      let rg_opt = rg_opt . ' $PRJ_FILE_TYPES_ARG $PRJ_DIRS_EXCLUDE_ARG'
      let arg = neoview#fzf#ripgrep_arg(a:pattern, rg_opt)
      let arg.source = 'source ' . g:prj_settings_sh . ' && ' .
        \ 'eval "' . arg.source . ' $PRJ_DIRS_ARG"'
    endif
  endif
  if !exists('arg')
    let arg = neoview#fzf#ripgrep_arg(a:pattern, rg_opt)
  endif
  let arg.fzf_win = 'botright %40split | set winfixheight'
  let arg.preview_win = 'above %100split'
  let arg.opt = arg.opt .
    \ '--no-sort --vim --no-prompt --info=hidden --no-bold
    \ --color=fg+:0,bg+:159,hl+:196,hl:172'
  call neoview#fzf#run(arg)
endfunction

" Find gtags, or call FindPattern() if g:prj_tags_type is not 'gtags'.
" 'tagtype' can be 'd' for definitions, 'r' for references or empty string
" for everything.
function! FindGtags(tagname, tagtype, ignore_case)
  let case_flag = ''
  if a:ignore_case
    let case_flag = '-i '
  endif
  if g:prj_tags_type != 'gtags'
    call FindPattern(a:tagname, v:true, case_flag . '-w')
    return
  endif
  let arg = neoview#fzf#gtags_arg(g:prj_meta_root, g:prj_gtags_num_instances,
    \ a:tagtype, case_flag . '--literal --color=always', a:tagname)
  let arg.fzf_win = 'botright %40split | set winfixheight'
  let arg.preview_win = 'above %100split'
  let arg.opt = arg.opt .
    \ '--vim --no-prompt --info=hidden --no-bold
    \ --color=fg+:0,bg+:159,hl+:196,hl:172'
  call neoview#fzf#run(arg)
endfunction

" Find tag, either in g:prj_ctags (if in_project is set) or b:compl_tags.
function! FindTag(tagname, in_project, ignore_case)
  if g:prj_tags_type == 'gtags'
    call FindGtags(a:tagname, 'd', a:ignore_case)
    return
  endif
  if a:in_project
    if exists('g:prj_ctags') && filereadable(g:prj_ctags)
      let tagfile = g:prj_ctags
    endif
  else
    " If 'in_project' is not set, prefer b:compl_tags over g:prj_ctags.
    if exists('b:compl_tags') && filereadable(b:compl_tags)
      let tagfile = b:compl_tags
    elseif exists('g:prj_ctags') && filereadable(g:prj_ctags)
      let tagfile = g:prj_ctags
    endif
  endif
  if !exists('tagfile')
    echomsg "No tag file!"
    return
  endif
  let arg = neoview#fzf#tags_arg(a:tagname, a:ignore_case, tagfile)
  let arg.fzf_win = 'botright %40split | set winfixheight'
  let arg.preview_win = 'above %100split'
  let arg.opt = arg.opt .
    \ '--vim --no-prompt --info=hidden --no-bold
    \ --color=fg+:0,bg+:159,hl+:196,hl:172'
  call neoview#fzf#run(arg)
endfunction

" Show all tags of the current buffer.
function! FindBufTag()
  let arg = neoview#fzf#buf_tags_arg()
  let arg.fzf_win = 'botright %40split | set winfixheight'
  let arg.preview_win = 'above %100split'
  let arg.opt = arg.opt .
    \ '--vim --no-prompt --info=hidden --no-bold
    \ --color=fg+:0,bg+:159,hl+:196,hl:172'
  call neoview#fzf#run(arg)
endfunction

" Find tag name in g:prj_tagnames file.
function! FindTagName()
  function! ViewTagName(ctx, final)
    if a:final
      call FindTag(a:ctx[0], v:true, v:false)
    endif
  endfunction

  if !exists('g:prj_tagnames')
    echomsg "No tag names file!"
    return
  endif
  let arg = {
    \ 'source' : 'cat ' . g:prj_tagnames,
    \ 'view_fn' : function('ViewTagName'),
    \ 'fzf_win' : 'above %40split | set winfixheight',
    \ 'preview_win' : 'below %100split',
    \ 'opt' : '--inline-info',
    \ 'tag' : 'TagName'
    \ }
  call neoview#fzf#run(arg)
endfunction

" Find tag name references.
function! FindTagNameRefs()
  function! ViewTagNameRefs(ctx, final)
    if a:final
      call FindGtags(a:ctx[0], '', v:false)
    endif
  endfunction

  if !exists('g:prj_tagnames')
    echomsg "No tag names file!"
    return
  endif
  let arg = {
    \ 'source' : 'cat ' . g:prj_tagnames,
    \ 'view_fn' : function('ViewTagNameRefs'),
    \ 'fzf_win' : 'above %40split | set winfixheight',
    \ 'preview_win' : 'below %100split',
    \ 'opt' : '--inline-info',
    \ 'tag' : 'TagRefs'
    \ }
  call neoview#fzf#run(arg)
endfunction

" Find file name either in the project files or in 'rg --files' output.
function! FindFile(in_project)
  let arg = neoview#fzf#ripgrep_files_arg('--follow 2>/dev/null')
  if a:in_project && exists("g:prj_files")
    let arg.source = 'cat ' . g:prj_files
  endif
  let arg.fzf_win = 'topleft %40split | set winfixheight'
  let arg.opt = arg.opt . '--inline-info'
  call neoview#fzf#run(arg)
endfunction

" Find line in the current buffer.
function! FindBufLine()
  let arg = neoview#fzf#buf_lines_arg()
  let arg.fzf_win = 'below %40split | set winfixheight'
  let arg.opt = arg.opt .
    \ '--no-sort --inline-info --no-bold --color=fg+:0,bg+:159,hl+:196,hl:172'
  call neoview#fzf#run(arg)
endfunction

"------------------------------------------------------------------------------
" Keyboard shortcuts
"------------------------------------------------------------------------------

if &term =~ '^tmux' || &term =~ '^alacritty'
  " tmux will send xterm-style keys when its xterm-keys option is on
  execute "set <xUp>=\e[1;*A"
  execute "set <xDown>=\e[1;*B"
  execute "set <xRight>=\e[1;*C"
  execute "set <xLeft>=\e[1;*D"
endif

" Word navigation
nnoremap <C-Left> b
nnoremap <C-Right> w

" Alt-w - delete word
inoremap <Esc>w <C-w>

" Alt-backspace - delete everything to the left of the cursor
inoremap <Esc><bs> <C-u>

" Opt-up|down scrolling
nnoremap <Esc>[1;9B <C-e>
nnoremap <Esc>[1;9A <C-y>
inoremap <Esc>[1;9B <C-x><C-e>
inoremap <Esc>[1;9A <C-x><C-y>
nnoremap . <C-e>
nnoremap ; <C-y>

" Ctrl-up|down scrolling
nnoremap <C-Down> <C-e>
nnoremap <C-Up> <C-y>
inoremap <C-Down> <C-x><C-e>
inoremap <C-Up> <C-x><C-y>

" Cmd-up|down for page up/down
nnoremap <Esc>[1;3A <C-b>
nnoremap <Esc>[1;3B <C-f>
inoremap <Esc>[1;3A <C-o><C-b>
inoremap <Esc>[1;3B <C-o><C-f>

" Cmd-left|right for moving to beginning/end of line
nnoremap <Esc>[1;3D <Home>
nnoremap <Esc>[1;3C <End>
inoremap <Esc>[1;3D <Home>
inoremap <Esc>[1;3C <End>

" Window navigation: Shift-arrows (see vim-tmux-navigator bindings above)
"inoremap <S-Left> <C-o><C-w><Left>
"inoremap <S-Right> <C-o><C-w><Right>
"inoremap <S-Up> <C-o><C-w><Up>
"inoremap <S-Down> <C-o><C-w><Down>

"nnoremap <S-Left> <C-w><Left>
"nnoremap <S-Right> <C-w><Right>
"nnoremap <S-Up> <C-w><Up>
"nnoremap <S-Down> <C-w><Down>

if has('terminal')
  " Move from the neovim terminal window to other neovim windows
  tnoremap <S-Left> <C-w>h
  tnoremap <S-Right> <C-w>l
  tnoremap <S-Up> <C-w>k
  tnoremap <S-Down> <C-w>j
endif

" Enhance '<' '>' - do not need to reselect the block after shift it.
vnoremap < <gv
vnoremap > >gv

" Close buffer
nnoremap <leader>q :Bwipeout<CR>

" Alt-c - copy to X clipboard.
vnoremap <silent> ç :<C-u>silent '<,'>w !xsel --clipboard<CR>
nnoremap <silent> ç V:<C-u>silent '<,'>w !xsel --clipboard<CR>

" Alt-Shift-c - copy to clipboard via OSC 52
vnoremap <silent> Ç :<C-u>'<,'>OSCYank<CR>
nnoremap <silent> Ç V:<C-u>'<,'>OSCYank<CR>

" Alt-/ - switch to correspondent header/source file
nnoremap ÷ :A<CR>
inoremap ÷ <C-o>:A<CR>

" Alt-Shift-/ - swich to file under cursor
nnoremap ¿ :IH<CR>
inoremap ¿ <C-O>:IH<CR>

function! SwapWindowWith(pos)
  let l:cur_wnd = winnr()
  let l:cur_buf = bufnr('%')
  let l:cur_view = winsaveview()
  exec "100wincmd h"
  if a:pos > 1
    exec (a:pos - 1) . "wincmd l"
  endif
  let l:swap_buf = bufnr('%')
  let l:swap_view = winsaveview()
  exec "b " . l:cur_buf
  call winrestview(l:cur_view)
  exec l:cur_wnd . "wincmd w"
  exec "b " . l:swap_buf
  call winrestview(l:swap_view)
endfunction

nnoremap 11 :call SwapWindowWith(1)<CR>
nnoremap 22 :call SwapWindowWith(2)<CR>
nnoremap 33 :call SwapWindowWith(3)<CR>
nnoremap 44 :call SwapWindowWith(4)<CR>

" Start terminal in the current window
nnoremap tt :terminal ++curwin<CR>

" Make window 90 chars wide
nnoremap <leader>8 :vertical resize 90<CR>

" Make windows dimensions the same
nnoremap <leader>= <C-w>=

" Redraw the screen
nnoremap <leader>r :redraw!<CR>

" Cmd-w acts as Ctrl-w in normal mode
nnoremap <Esc>w <C-w>

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

function! DupLeft()
  let l:cur_wnd = winnr()
  let l:cur_view = winsaveview()
  let l:cur_buf = bufnr('%')
  exec "wincmd h"
  if winnr() == l:cur_wnd
    exec "wincmd v"
    exec "wincmd l"
    exec "b " . l:cur_buf
    call winrestview(l:cur_view)
    exec "wincmd h"
  else
    exec "b " . l:cur_buf
    call winrestview(l:cur_view)
  endif
endfunction
nnoremap » :call DupLeft()<CR>

" Open a fzf.vim window with the specified layout.
function! FzfWindow(layout, fzf_cmd, reverse)
  if exists("g:fzf_layout")
    let l:saved_layout = g:fzf_layout
  endif
  if a:reverse != 0
    let $FZF_DEFAULT_OPTS = '--reverse --bind=tab:down'
  else
    let $FZF_DEFAULT_OPTS = '--bind=tab:down'
  endif
  let g:fzf_layout = a:layout
  exec a:fzf_cmd
  if exists("l:saved_layout")
    let g:fzf_layout = l:saved_layout
  else
    unlet g:fzf_layout
  endif
endfunction

function! StartOrCloseUnite(unite_cmd)
  let unite_winnr = unite#get_unite_winnr('default')
  if unite_winnr > 0
    exec "Unite -toggle"
  else
    exec a:unite_cmd
  endif
endfunction

" Returns the command to toggle the specified unite window.
function! StartOrCloseUniteCallCmd(unite_cmd)
  return ':call StartOrCloseUnite("' . a:unite_cmd . '")<CR>'
endfunction

" Shift-F1 - toggle location window
function! ToggleLocationWindow()
  let l:cur_wnd = winnr()
  let l:last_winnr = winnr('$')
  lclose
  if l:last_winnr == winnr('$')
    " No local location window has been closed
    "windo if &buftype == "quickfix" || &buftype == "locationlist"
    " \ | lclose | endif
    "exec l:cur_wnd . "wincmd w"
    botright lopen
  endif
endfunction
nnoremap <silent> <Esc>[1;2P :call ToggleLocationWindow()<CR>
inoremap <silent> <Esc>[1;2P <Esc>:call ToggleLocationWindow()<CR>

" F2 - search tag (case sensitive)
nnoremap <silent> <F2> :call FindTagName()<CR>
inoremap <silent> <F2> <Esc> :call FindTagName()<CR>

" Shift-F2 - search rag name references (case sensitive)
nnoremap <silent> <Esc>[1;2Q :call FindTagNameRefs()<CR>
inoremap <silent> <Esc>[1;2Q <Esc>:call FindTagNameRefs()<CR>

" Cmd-F2 - search lines in the current buffer
nnoremap <silent> <Esc>[1;3Q :call FindBufLine()<CR>
inoremap <silent> <Esc>[1;3Q <Esc>:call FindBufLine()<CR>
nnoremap <silent> <Esc><Esc>OQ :call FindBufLine()<CR>
inoremap <silent> <Esc><Esc>OQ <Esc>:call FindBufLine()<CR>

" F3 - browse buffers
let s:f3_cmd = StartOrCloseUniteCallCmd('Unite -previewheight=100 buffer')
exec 'nnoremap <silent> <F3> ' . s:f3_cmd
exec 'inoremap <silent> <F3> <Esc>' . s:f3_cmd
if has('terminal')
  exec 'tnoremap <silent> <F3> <C-\><C-n>' . s:f3_cmd
endif

" Cmd-F3 - commands history
nnoremap <silent> <Esc>[1;3R :History:<CR>
inoremap <silent> <Esc>[1;3R <Esc>:History:<CR>
nnoremap <silent> <Esc><Esc>OR :History:<CR>
inoremap <silent> <Esc><Esc>OR <Esc>:History:<CR>

" F4 - toggle paste mode
set pastetoggle=<F4>

" F5 - show syntax highlighting group under cursor
map <F5> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name")
  \ . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
  \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Shift-F7 - toggle indent guides
nmap <S-F7> :IndentLinesToggle<CR>
imap <S-F7> <C-o>:IndentLinesToggle<CR>
nmap <Esc>[18;2~ :IndentLinesToggle<CR>
imap <Esc>[18;2~ <C-o>:IndentLinesToggle<CR>

" F7 - toggle color column
function! ToggleColorColumn()
  if &colorcolumn == 0
    set colorcolumn=80
  else
    set colorcolumn=0
  endif
endfunction
nnoremap <F7> :call ToggleColorColumn()<CR>
inoremap <F7> <C-o>:call ToggleColorColumn()<CR>

" F8 - clear highlight of the last search until the next search
nnoremap <F8> :noh<CR>
inoremap <F8> <C-o>:noh<CR>

" S-F8 - clear match in the current window
nnoremap <S-F8> :match none<CR>
inoremap <S-F8> <C-o>:match none<CR>
nnoremap <Esc>[19;2~ :match none<CR>
inoremap <Esc>[19;2~ <C-o>:match none<CR>

" F9 - history
let g:history_layout = { "down":"~40%" }
nnoremap <silent> <F9> :call FzfWindow(g:history_layout, "History", 1)<CR>
inoremap <silent> <F9> <Esc>:call FzfWindow(g:history_layout, "History", 1)<CR>

" Cmd-F9|F10 - backward/forward jump stack navigation
nnoremap <M-F9> <C-o>
nnoremap <M-F10> <C-i>
inoremap <M-F9> <C-o><C-o>
inoremap <M-F10> <C-o><C-i>

nnoremap <Esc><Esc>[20~ <C-o>
nnoremap <Esc><Esc>[21~ <C-i>
inoremap <Esc><Esc>[20~ <C-o><C-o>
inoremap <Esc><Esc>[21~ <C-o><C-i>

" F10 - browse buffer tags
nnoremap <F10> :call FindBufTag()<CR>
inoremap <F10> <Esc>:call FindBufTag()<CR>

" Shift-F10 - browse all tags
let g:nvimp_fzf_tags_layout = { "down":"~40%" }
nnoremap <S-F10> :call FzfWindow(g:nvimp_fzf_tags_layout, "Tags", 1)<CR>
inoremap <S-F10> <Esc>:call FzfWindow(g:nvimp_fzf_tags_layout, "Tags", 1)<CR>

nnoremap <Esc>[21;2~
  \ :call FzfWindow(g:nvimp_fzf_tags_layout, "Tags", 1)<CR>
inoremap <Esc>[21;2~
  \ <Esc>:call FzfWindow(g:nvimp_fzf_tags_layout, "Tags", 1)<CR>

" F11 - toggle neoview window
nnoremap <silent> <F11> :call neoview#fzf#run({})<CR>
if has('terminal')
  tnoremap <silent> <F11> <C-\><C-n> :call neoview#fzf#run({})<CR>
endif

" F12 - find definitions of the word under cursor, prefer project tags
nnoremap <silent> <F12> :call FindTag(expand("<cword>"), v:true, v:false)<CR>
inoremap <silent> <F12>
  \ <Esc>:call FindTag(expand("<cword>"), v:true, v:false)<CR>

" Shift-F12 - find the whole word under cursor, use gtags if they exist
nnoremap <silent> <S-F12>
  \ :call FindGtags(expand("<cword>"), '', v:false)<CR>
inoremap <silent> <S-F12>
  \ <Esc>:call FindGtags(expand("<cword>"), '', v:false)<CR>

nnoremap <silent> <Esc>[24;2~
  \ :call FindGtags(expand("<cword>"), '', v:false)<CR>
inoremap <silent> <Esc>[24;2~
  \ <Esc>:call FindGtags(expand("<cword>"), '', v:false)<CR>

" Cmd-F12 - find the whole word under cursor in the project files
nnoremap <silent> <Esc><Esc>[24~
  \ :call FindPattern(expand("<cword>"), v:true, '-w')<CR>
inoremap <silent> <Esc><Esc>[24~
  \ <Esc>:call FindPattern(expand("<cword>"), v:true, '-w')<CR>

" Alt-P - open list of files, prefer in project
nnoremap <silent> π :call FindFile(v:true)<CR>
inoremap <silent> π <Esc>:call FindFile(v:true)<CR>

" Alt-Shift-P - open list of all files
nnoremap <silent> ∏ :call FindFile(v:false)<CR>
inoremap <silent> ∏ <Esc>:call FindFile(v:false)<CR>

"------------------------------------------------------------------------------
" Custom commands
"------------------------------------------------------------------------------

" F - find a pattern (case sensitive)
command! -bang -nargs=1 -complete=tag F
  \ :call FindPattern(shellescape(<q-args>), !<bang>0, '')

" FW - find an exact word (case sensitive)
command! -bang -nargs=1 -complete=tag FW
  \ :call FindPattern(shellescape(<q-args>), !<bang>0, '-w')

" FC - find a pattern (ignore case)
command! -bang -nargs=1 -complete=tag FC
  \ :call FindPattern(shellescape(<q-args>), !<bang>0, '-i')

" FWC - find an exact word (ignore case)
command! -bang -nargs=1 -complete=tag FWC
  \ :call FindPattern(shellescape(<q-args>), !<bang>0, '-i -w')
" ...and alias:
command! -bang -nargs=1 -complete=tag FCW
  \ :call FindPattern(shellescape(<q-args>), !<bang>0, '-i -w')

" FT - find an exact word in the ctags database (case sensitive)
command! -nargs=1 -complete=tag FT
  \ :call FindTag(shellescape(<q-args>), v:true, v:false)

" FR - find reference in gtags database (case sensitive)
command! -nargs=1 -complete=tag FR
  \ :call FindGtags(shellescape(<q-args>), '', v:false)

" FRC - find reference in gtags database (ignore case)
command! -nargs=1 -complete=tag FRC
  \ :call FindGtags(shellescape(<q-args>), '', v:true)

" Up - update project metadata (file list and ctags)
command! -nargs=0 Up :call s:update_project("")

" Uc - update project's ctags
command! -nargs=0 Uc :call s:update_project("ctags")

" Ug - update project's gtags
command! -nargs=0 Ug :call s:update_project("gtags")

" Ut - update project's ctags and gtags
command! -nargs=0 Ut :call s:update_project("tags")

"------------------------------------------------------------------------------
" Misc configuration
"------------------------------------------------------------------------------

" Make Backspace work
set backspace=indent,eol,start

" Catch mouse events
set mouse=a
set ttymouse=sgr

" Disable wrapping
set nowrap

" Vim UI
set wildmenu " turn on wild menu, try typing :h and press <Tab>
set showcmd " display incomplete commands
set cmdheight=1 " 1 screen lines to use for the command-line
set ruler " show the cursor position all the time
set hid " allow to change buffer without saving
set shortmess=atI " shortens messages to avoid 'press a key' prompt
if v:version >= 800
  set shortmess+=S
endif
"set lazyredraw " do not redraw while executing macros (much faster)
set display+=lastline " for easy browse last line with wrap text
set laststatus=2 " always have status-line
set winminheight=0 winminwidth=0 " sane window resizing behavior
set fillchars+=vert:│ " prettier vertical split window separator

" Show line numbers
set number

" Search (/)
set hls " Enable search pattern highlight
set incsearch " Do incremental searching
set ignorecase " Set search/replace pattern to ignore case
set smartcase " Set smartcase mode on, If there is upper case character in
              " the search patern, the 'ignorecase' option will be override.

" Common indent settings
set shiftwidth=4
set tabstop=4
set sts=4
set noexpandtab
set autoindent
set smartindent
" See help cinoptions-values for more details
set cinoptions=>s,e0,n0,f0,{0,}0,^0,:0,=s,l0,b0,g0,hs,ps,ts,is,+s,c3,C0,0,
  \(0,us,U0,w0,W0,m0,j0,)20,*30

" File type specific indent settings
autocmd FileType c,cpp,proto,fbs,python,cmake,conf,javascript,java,vim,json
  \ setlocal sw=2 ts=2 sts=2 expandtab autoindent

" Disable line numbers and color column in quickfix window, also enable wrap.
autocmd FileType qf setlocal wrap nonumber colorcolumn=

" Jump to the last position when reopening a file
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") |
  \ exe "normal! g'\"" | endif

" Highlight lines >= 80 chars and trailing whitespaces
function! HighlightFormatting(enable)
  if &filetype == 'cpp' || &filetype == 'c' || &filetype == 'proto' ||
  \ &filetype == 'python' || &filetype == 'cmake' || &filetype == 'vim' ||
  \ &filetype == 'javascript' || &filetype == 'java' || &filetype == 'go' ||
  \ &filetype == 'fbs'
    if a:enable
      "highlight OverLength ctermbg=red ctermfg=white
      "match OverLength /\%80v.\+/
      highlight WhiteSpaceEOL ctermbg=gray
      2match WhiteSpaceEOL /\s\+$/
    else
      "highlight WhiteSpaceEOL ctermbg=none
      2match none
    endif
  endif
endfunction
"autocmd BufNewFile,BufReadPost,WinEnter * call HighlightFormatting()
autocmd InsertEnter * call HighlightFormatting(1)
autocmd InsertLeave * call HighlightFormatting(0)

function! SetColorColumn(enable)
  if &filetype == 'cpp' || &filetype == 'c' || &filetype == 'proto' ||
  \ &filetype == 'python' || &filetype == 'cmake' || &filetype == 'vim' ||
  \ &filetype == 'javascript' || &filetype == 'java' || &filetype == 'go' ||
  \ &filetype == 'fbs' || &filetype == 'conf'
    if a:enable
      set colorcolumn=80
    else
      set colorcolumn=0
    endif
  endif
endfunction
autocmd InsertEnter * call SetColorColumn(1)
autocmd InsertLeave * call SetColorColumn(0)

" Automatically enter insert mode in terminal window
autocmd BufWinEnter,WinEnter * if &buftype == 'terminal' && mode() == 'n' |
  \ call feedkeys('i', 'x') | endif

if has('terminal')
  " No line numbers in terminal window
  autocmd TerminalOpen * setlocal nonumber norelativenumber
endif

" Update gtags using the current buffer. Gtags have to be present.
function! GtagsUpdate()
  if g:gtags_auto_update == 1
    if !exists('g:prj_gtags_num_instances') || g:prj_gtags_num_instances == 0
      if exists('g:prj_gtags') && filereadable(g:prj_gtags)
        call system('GTAGSROOT=`pwd` GTAGSDBPATH="' . g:prj_meta_root .
          \ '" global -u --single-update="' . expand("%") . '"')
      endif
    else
      let dbpath = trim(system('pglobal_find_db -n ' .
        \ g:prj_gtags_num_instances . ' ' . g:prj_meta_root . ' ' .
        \ expand("%")))
      if !empty(dbpath)
        call system('GTAGSROOT=`pwd` GTAGSDBPATH="' . dbpath .
          \ '" global -u --single-update="' . expand("%") . '"')
      endif
    endif
  endif
endfunction
autocmd BufWritePost * call GtagsUpdate()

set timeoutlen=500 ttimeoutlen=0

" Enable syntax highlighting. In iTerm2, select 'Light Background' palette.
syntax on
if $VIMP_COLOR_SCHEME == 'solarized_dark'
  set background=dark

  " https://superuser.com/questions/1284561/why-is-vim-starting-in-replace-mode
  set t_u7=

  colorscheme solarized8
else
  colorscheme my_colors_light
endif

" Status line
function! BufJobSign()
  let bufnum = bufnr('%')
  let s = ''
  if v:version >= 800 && ale#engine#IsCheckingBuffer(bufnum)
    let s = '@'
  endif
  if getbufvar(bufnum, 'compl_tags_job', 0) > 0
    let s = s . 't '
  elseif s != ''
    let s = s . ' '
  endif
  return s
endfunction

highlight BufJobSign ctermfg=LightBlue ctermbg=Black cterm=bold
set statusline=%#BufJobSign#%{BufJobSign()}
  \%*%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
