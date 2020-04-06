call plug#begin('~/.vim/plugged')
Plug 'benmills/vimux'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'w0rp/ale'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'losingkeys/vim-niji'

"Filetypes
Plug 'ElmCast/elm-vim'
Plug 'guns/vim-clojure-static'
Plug 'ianks/vim-tsx'
Plug 'keith/swift.vim'
Plug 'leafgarland/typescript-vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'pangloss/vim-javascript'
Plug 'slim-template/vim-slim'
Plug 'tpope/vim-rails'
call plug#end()

let g:vim_jsx_pretty_colorful_config = 1

set nocompatible
set backupcopy=yes
set encoding=utf-8

" No swapfiles
set noswapfile
set backupdir=~/.vim/backup
set directory=~/.vim/backup

set laststatus=2                  "Show statusbar
set number
set nowrap
set ttyfast
set incsearch

let g:ale_sign_column_always = 1
let g:ale_linters = {
  \ 'clojure': ['clj-kondo'],
  \}

let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html PrettierAsync

let g:is_posix = 1

let mapleader = ","
map <leader>w :w<enter>
map <leader>q :q<enter>

map <leader>t :FZF<enter>
nmap <silent> <Leader>/ :noh<CR>

" Map tcomment plugin
map <leader>d gcc
vmap <leader>d gc

" Map reload vimrc
map <leader>vi :source ~/.vimrc<CR>

nmap <leader>h :ALEHover<CR>

" Sane movement with wrap turned on
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

" Syntax
syntax enable
filetype plugin indent on
set showmatch
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

" Search options
set hlsearch
set ignorecase

" Theming
set background=dark
colorscheme noctu

" Access system clipboard
set clipboard=unnamed

" Open splits to the bottom/right
set splitbelow
set splitright

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column -i --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

" Trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
map <leader>s :%s/\s\+$//g<CR>

" Vimux
function! VimuxZoomVim()
  call _VimuxTmux("resize-pane -Z")
endfunction

function! VimuxZoomRunner2()
  call _VimuxUnzoomVim()
  call VimuxZoomRunner()
endfunction

function! _VimuxUnzoomVim()
  if exists("g:VimuxRunnerIndex")
    call _VimuxTmux("select-pane -t ".g:VimuxRunnerIndex)
    call _VimuxTmux("last-pane")
  endif
endfunction

" Vimux - Clojure

" I don't know why this is 'q C-u' by default, but it messes up my repl
let g:VimuxResetSequence = ""

function! VimuxSlime(...)
  let l:cmd = a:0 == 1 ? a:1 : @v

  " call VimuxStartRepl()
  call VimuxRunCommand(l:cmd)
endfunction

function! VimuxStartRepl()
  if !exists("g:VimuxRunnerIndex") || _VimuxHasRunner(g:VimuxRunnerIndex) == -1
    call VimuxOpenRunner()
  endif

  call _VimuxUnzoomVim()

  let l:parent_pid = substitute(_VimuxTmux("display-message -p -t ".g:VimuxRunnerIndex." '#{pane_pid}'"), '\n\+$', '', '')
  let l:child_pid = substitute(system("pgrep -P ".l:parent_pid), '\n\+$', '', '')
  let l:running_command = split(system("ps -p ".l:child_pid." -o command="), "/")[-1]

  let l:repl_command = _VimuxReplCommand()

  if substitute(l:running_command, '\n\+$', '', '') == l:repl_command
    return
  endif

  call VimuxRunCommand(l:repl_command)
endfunction

function! _VimuxReplCommand()
  let l:commandFile = ".repl-command"
  if filereadable(l:commandFile)
    return readfile(l:commandFile)[0]
  else
    return "lein repl"
  endif
endfunction

function! VimuxOpenNamespace()
  let l:cmd = "(in-ns '"._GetNamespace().")"
  call VimuxSlime(l:cmd)
endfunction

function! _GetNamespace()
  let l:fileLength = line("$")
  let l:nr = 1

  while l:nr <= l:fileLength
    let l:line = getline(l:nr)
    let l:match = matchlist(l:line, '\v\s*\(\s*ns\s+(\f+)\)?\s*')
    if !empty(l:match)
      return l:match[1]
    endif
    let l:nr += 1
  endwhile
endfunction

" Vimux - Ruby
function! RunSpec()
  if match(bufname("%"), "_spec.rb$") != -1
    let s:current_spec = bufname("%") . ":" . line(".")
  endif
  if !exists("s:current_spec")
    echo "No current spec defined, please run from a *_spec.rb file first."
  else
    let s:command = "rspec " . s:current_spec
    call VimuxRunCommand("clear; echo " . s:command . "; " . s:command)
  endif
endfunction

nmap <silent> <leader>rz :call VimuxZoomRunner2()<CR>
nmap <silent> <Leader>rv :call VimuxZoomVim()<CR>
nmap <silent> <leader>rq :VimuxCloseRunner<CR>
nmap <silent> <leader>rl :VimuxRunLastCommand<CR>

augroup vimux
  autocmd!

  autocmd FileType clojure nmap <buffer> <silent> <Leader>rs :call VimuxStartRepl()<CR>
  autocmd FileType clojure vmap <buffer> <silent> <CR> "vy :call VimuxSlime()<CR>
  autocmd FileType clojure nmap <buffer> <silent> <CR> va(<CR>
  autocmd FileType clojure nmap <buffer> <silent> <Leader><CR> vap<CR>
  autocmd FileType clojure nmap <buffer> <silent> <Leader>rn :call VimuxOpenNamespace()<CR>

  autocmd FileType ruby vmap <buffer> <silent> <Leader>rc "vy :call VimuxSlime()<CR>
  autocmd FileType ruby nmap <buffer> <silent> <CR> :call RunSpec()<CR>
  autocmd FileType ruby nmap <buffer> <silent> <C-c> :VimuxInterruptRunner<CR>
augroup END
