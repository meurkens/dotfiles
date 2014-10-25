"==========================================================
" Vundle
"==========================================================
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

Plugin 'csexton/trailertrash.vim'
Plugin 'ervandew/supertab'
Plugin 'tpope/vim-rails'
Plugin 'vim-ruby/vim-ruby'
Plugin 'tomtom/tcomment_vim'
Plugin 'kien/ctrlp.vim'

" Filetypes
Plugin 'kchmck/vim-coffee-script'
Plugin 'nono/vim-handlebars'
Plugin 'slim-template/vim-slim'
Plugin 'mtscout6/vim-cjsx'

" Color schemes
Plugin 'tomasr/molokai'
Plugin 'nanotech/jellybeans.vim'

call vundle#end()
filetype plugin indent on

"==========================================================
" Mappings
"==========================================================

let mapleader=","
noremap \ ,

map <Leader>vi :tabe ~/.vimrc<CR>
map <Leader>bi :source ~/.vimrc<CR>
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

" Search options
set hlsearch
set ignorecase

" Visual layout
set laststatus=2                  "Show statusbar
set number                        "Linenumbers
set nowrap

" Access system clipboard
set clipboard=unnamed

" set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

set visualbell

color jellybeans
