set fileencodings=utf-8,iso-2022-jp,sjis,euc-jp,cp932
set encoding=utf-8
"set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).'])]}>
set nocompatible
filetype off

if has('vim_starting')
  set runtimepath+=~/.vim/neobundle.vim
  call neobundle#rc(expand('~/.vim/bundle'))
endif
NeoBundle 'Lokaltog/vim-easymotion'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimshell.git'
NeoBundle 'quickrun.vim'
NeoBundle 'thinca/vim-ref'
NeoBundle 'javascript.vim'
NeoBundle 'svn-diff.vim'
NeoBundle 'Syntastic'
NeoBundle 'pangloss/vim-javascript'
NeoBundle 'majutsushi/tagbar'
NeoBundle 'itchyny/landscape.vim'
NeoBundle 't9md/vim-unite-ack'
NeoBundle 'rking/ag.vim'
NeoBundle 'derekwyatt/vim-scala.git'
NeoBundle 'nathanaelkane/vim-indent-guides'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'szw/vim-tags'
NeoBundle 'vim-scripts/errormarker.vim.git'
NeoBundle 'wincent/Command-T'
filetype plugin indent on
"   Installation check.
if neobundle#exists_not_installed_bundles()
  echomsg 'Not installed bundles : ' .
        \ string(neobundle#get_not_installed_bundle_names())
  echomsg 'Please execute ":NeoBundleInstall" command.'
endif

set autoindent
set smartindent
set expandtab
set backspace=indent,eol,start
set formatoptions+=m

set wildmenu
set wildmode=list:full

set wrapscan
set ignorecase
set smartcase
set hlsearch

set nobackup
set autoread
set noswapfile
set hidden

set showmatch
set showcmd
set number
set nowrap
set ruler
set cursorline

set antialias " アンチエイリアス
set tabstop=4 shiftwidth=4 softtabstop=0 " タブサイズ
set visualbell t_vb= " ビープ音なし
set history=50

syntax on

colorscheme landscape

" vimsehll
let g:vimshell_interactive_update_time = 10
let g:vimshell_prompt = $USER."% "
"vimshell map
nmap vs :VimShell<CR>
nmap vp :VimShellPop<CR>

" make
autocmd FileType scala :compiler sbt
autocmd QuickFixCmdPost make if len(getqflist()) != 0 | copen | endif

" marker
let g:errormarker_errortext     = '!!'
let g:errormarker_warningtext   = '??'
let g:errormarker_errorgroup    = 'Error'
let g:errormarker_warninggroup  = 'ToDo'

" TagBar
nmap <F8> :TagbarToggle<CR>

" NERDTree
nmap <silent> <C-e> :NERDTreeToggle<CR>
vmap <silent> <C-e> <Esc> :NERDTreeToggle<CR>
omap <silent> <C-e> :NERDTreeToggle<CR>
imap <silent> <C-e> <Esc> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
let g:NERDTreeShowHidden=1

" vim-tags
nnoremap <C-]> g<C-]>

" indent-guides
let g:indent_guides_guide_size = 1
let g:indent_guides_auto_colors = 1

" キーバインド
" BackSpace, Delete
imap <D-u> <BS>
imap <D-i> <Del>
" 空行追加
imap <C-o> <ESC>o
" エスケープ
imap <D-d> <ESC>
" 括弧
imap { {}<Left>
imap [ []<Left>
imap ( ()<Left>
imap < <><Left>

" prefix key
let mapleader = '\'
let maplocalleader = ','

" Syntastic
let g:syntastic_enable_signs=1
let g:syntastic_auto_loc_list=2

" ファイルを閉じた場所を記憶
if has("autocmd")
    autocmd BufReadPost *
    \ if line("'\"") > 0 && line ("'\"") <= line("$") |
    \   exe "normal! g'\"" |
    \ endif
endif

" 行末の不要なスペースを削除
function! RTrim()
    let s:cursor = getpos(".")
    %s/\s\+$//e
    call setpos(".", s:cursor)
endfunction
autocmd BufWritePre *.php,*.rb,*.js,*.py call RTrim()

" JSON Reformat
map ¥j !python -m json.tool<CR>

" Anywhere SID.
function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

" Set tabline.
function! s:my_tabline()  "{{{
  let s = ''
  for i in range(1, tabpagenr('$'))
    let bufnrs = tabpagebuflist(i)
    let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
    let no = i  " display 0-origin tabpagenr.
    let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
    let title = fnamemodify(bufname(bufnr), ':t')
    let title = '[' . title . ']'
    let s .= '%'.i.'T'
    let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
    let s .= no . ':' . title
    let s .= mod
    let s .= '%#TabLineFill# '
  endfor
  let s .= '%#TabLineFill#%T%=%#TabLine#'
  return s
endfunction "}}}
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2 " 常にタブラインを表示

" The prefix key.
nnoremap    [Tag]   <Nop>
nmap    t [Tag]
" Tab jump
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
" t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ

map <S-t> :tabnew<CR>
" Shift+t 新しいタブを一番右に作る
map <S-w> :tabclose<CR>
" Shift+w タブを閉じる
map <silent> [Tag]n :tabnext<CR>
" tn 次のタブ
map <silent> [Tag]p :tabprevious<CR>
" tp 前のタブ

if has('gui_macvim')
    source ~/.gvimrc
endif

