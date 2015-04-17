"==========================================================
" Vundle
"==========================================================

call plug#begin('~/.vim/plugged')

Plug 'amdt/vim-niji'
Plug 'csexton/trailertrash.vim'
Plug 'ervandew/supertab'
Plug 'kien/ctrlp.vim'
Plug 'benmills/vimux'
Plug 'meurkens/vim-rspec'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-rails'
Plug 'vim-ruby/vim-ruby'
Plug 'godlygeek/tabular'

" Filetypes
Plug 'kchmck/vim-coffee-script'
Plug 'nono/vim-handlebars'
Plug 'slim-template/vim-slim'
Plug 'mtscout6/vim-cjsx'

" Color schemes
Plug 'tomasr/molokai'
Plug 'nanotech/jellybeans.vim'

call plug#end()

set nocompatible

set encoding=utf-8
set t_Co=256
set ttyfast
set lazyredraw

"==========================================================
" Mappings
"==========================================================

let mapleader=","
noremap \ ,

map <Leader>vi :tabe ~/.vimrc<CR>
map <Leader>bi :source ~/.vimrc<CR>:PlugInstall<CR>
map <Leader>c :top split ~/Dropbox/Notities/cheatsheet.markdown<cr>
map <leader>q :quit<cr>
map <leader>w :write<cr>
map <leader>a :b#<cr>
map <leader>t :CtrlP<CR>
nmap <silent> <Leader>/ :noh<CR>

" map tcomment
map <leader>d gcc
vmap <leader>d gc

" Trailer trash
map <leader>s :Trailer<cr>
map <leader>sa :TrailerTrim<cr>

" reflow paragraph with Q in normal and visual mode
nnoremap Q gqap
vnoremap Q gq

" sane movement with wrap turned on
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

" RSpec.vim
map <Leader>rf :call RunCurrentSpecFile()<CR>
map <Leader>rs :call RunNearestSpec()<CR>
map <Leader>rl :call RunLastSpec()<CR>
map <Leader>ra :call RunAllSpecs()<CR>

" Vimux
function! VimuxSlime()
  call VimuxSendText(@v)
  call VimuxSendKeys("Enter")
endfunction

map  <Leader>vq :VimuxCloseRunner<CR>
map  <Leader>vx :VimuxInterruptRunner<CR>
map  <Leader>vl :VimuxRunLastCommand<CR>
vmap <Leader>vs "vy :call VimuxSlime()<CR>
nmap <Leader>vs vip<Leader>vs<CR>

"==========================================================
" Settings
"==========================================================

" open quickfix window after grep
autocmd QuickFixCmdPost *grep* cwindow

" split to the right side
set splitbelow
set splitright

" No swapfiles
set noswapfile
set backupdir=~/.vim/backup
set directory=~/.vim/backup

" Syntax
syntax enable
filetype plugin indent on
set showmatch
set mat=5
set autoindent
set smartindent

" Autocomplete commands
set wildmenu
set wildmode=list:longest,full

" Tab options
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set nosmarttab

" Ag, the silver searcher
if executable('ag')
  " :grep
  set grepprg=ag\ --nogroup\ --nocolor
  " ctrlp
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  let g:ctrlp_use_caching = 0
endif

" Vimux in vertical split
let g:VimuxOrientation = "h"
let g:VimuxHeight = "25"

" Search options
set hlsearch
set ignorecase

" Visual layout
set laststatus=2                  "Show statusbar
set number                        "Linenumbers
set nowrap
set winwidth=100 "active window is at least this pixels wide

" Access system clipboard
set clipboard=unnamed

" set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

set visualbell

color jellybeans

" Resize all windows to optimum distribution whenever Vim itself (the
" terminal window it lives in) is resized.
autocmd VimResized * wincmd =
