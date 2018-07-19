call plug#begin('~/.config/nvim/plugged')

Plug 'AndrewRadev/splitjoin.vim'
Plug 'airblade/vim-gitgutter'
Plug 'arcticicestudio/nord-vim'
Plug 'danchoi/ri.vim'
Plug 'danro/rename.vim'
Plug 'godlygeek/tabular'
Plug 'janko-m/vim-test'
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'kana/vim-textobj-user'
Plug 'ludovicchabant/vim-gutentags'
Plug 'mileszs/ack.vim'
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'neomake/neomake'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'unblevable/quick-scope'
Plug 'vim-airline/vim-airline'

call plug#end()

set number
set ruler                               " Show the cursor position all the time
set colorcolumn=80                      " Show vertical bar at column 80
set cursorline                          " Highlight the line of the cursor
set showcmd                             " Show partial commands below the status line
set noshowmode                          " Don't show current model - it's already displayed in Airline
set shell=bash                          " Avoids munging PATH under zsh
let g:is_bash=1                         " Default shell syntax
set scrolloff=3                         " Have some context around the current line always
                                        " on screen
set noerrorbells visualbell t_vb=       " Disable bell
set hidden                              " Allow backgrounding buffers without writing
                                        " them, and remember marks/undo for backgrounded
                                        " buffers
set backupdir=~/.config/nvim/_backup    " where to put backup files
set directory=~/.config/nvim/_temp      " where to put swap files
set inccommand=nosplit                  " incremental substitute

" Whitespace
set nowrap                              " don't wrap lines
set tabstop=2                           " a tab is two spaces
set shiftwidth=2                        " an autoindent (with <<) is two spaces
set expandtab                           " use spaces, not tabs

" Searching
set ignorecase                          " searches are case insensitive...
set smartcase                           " ... unless they contain at least one capital letter

let mapleader=" "

function s:setupWrappingAndSpellcheck()
  set wrap
  set wrapmargin=2
  set textwidth=80
  set spell
endfunction

augroup vimrc
  " Remove all vimrc autocommands
  autocmd! vimrc

  " Delete empty space from the end of lines on every save
  autocmd BufWritePre * :%s/\s\+$//e

  " Make sure all markdown files have the correct filetype set and setup
  " wrapping and spell check
  autocmd BufRead,BufNewFile *.{md,md.erb,markdown,mdown,mkd,mkdn,txt} setf markdown | call s:setupWrappingAndSpellcheck()

  " Spellcheck
  autocmd BufRead,BufNewFile *.feature setlocal spell

  " Remember last location in file, but not for commit messages.
  " see :help last-position-jump
  autocmd BufReadPost * if &filetype !~ '^git\c' && line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g`\"" | endif

  " Encrypted Yaml
  autocmd BufRead,BufNewFile *.{yml.enc} setlocal filetype=yaml

  autocmd BufRead,BufNewFile *.{inky} setlocal filetype=html

  " Git
  autocmd Filetype gitcommit setlocal spell textwidth=72

  " I like relative numbering when in normal mode.
  autocmd TermOpen * setlocal conceallevel=0 colorcolumn=0 relativenumber

  " Prefer Neovim terminal insert mode to normal mode.
  autocmd BufEnter term://* startinsert

  " FZF
  autocmd FileType fzf tnoremap <buffer> <C-j> <Down>
  autocmd FileType fzf tnoremap <buffer> <C-k> <Up>
augroup END

" quick-scope
augroup qs_colors
  autocmd! qs_colors
  autocmd ColorScheme * highlight QuickScopePrimary ctermfg=3 cterm=underline
  autocmd ColorScheme * highlight QuickScopeSecondary ctermfg=5 cterm=underline
augroup END

" Toggle relative numbers
nnoremap <C-n> :let &rnu=!&rnu<CR>

" clear the search buffer when hitting return
nnoremap <CR> :nohlsearch<cr>

inoremap jj <Esc>

nmap <leader>ga :Files app<cr>
nmap <leader>gv :Files app/views<cr>
nmap <leader>gc :Files app/controllers<cr>
nmap <leader>gm :Files app/models<cr>
nmap <leader>gh :Files app/helpers<cr>
nmap <leader>gj :Files app/assets/javascripts<cr>
nmap <leader>gf :Files features<cr>
nmap <leader>gs :Files spec<cr>
nmap <leader>gt :Files test<cr>
nmap <leader>gl :Files lib<cr>
nmap <leader>ge :Files engines<cr>
nmap <leader>f :Files ./<cr>
nmap <leader>b :Buffers<cr>
nmap <leader>gd :e db/schema.rb<cr>
nmap <leader>gr :e config/routes.rb<cr>
nmap <leader>gg :e Gemfile<cr>
nmap <leader>s :A<CR>
nmap <leader>v :AV<CR>

" vim-test
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>l :TestLast<CR>
let test#strategy="neovim"

set wildignore+=tmp/**
set wildignore+=*/vendor/*
set wildignore+=*/plugged/*

" switch between 2 files opened last
nnoremap <leader><leader> <c-^>

" easier navigation between split windows
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" map Ctrl+S to :w
noremap <silent> <C-S>  :update<CR>
vnoremap <silent> <C-S> <C-C>:update<CR>
inoremap <silent> <C-S> <C-O>:update<CR>

" Ack
let g:ackprg="ack-grep -H --nocolor --nogroup --column"
nmap <leader>a :Ack ""<Left>
nmap <leader>A :Ack <C-r><C-w>

" Airline
let g:airline_left_sep=""
let g:airline_right_sep=""
let g:airline_section_x=""
let g:airline_section_y=""
let g:airline_section_z="%l/%L %-3.c"
let g:airline_theme="nord"

" Nvim Terminal
" Make escape work in the Neovim terminal.
tnoremap <Esc> <C-\><C-n>

" Make navigation into and out of Neovim terminal splits nicer.
tnoremap <C-h> <C-\><C-N><C-w>h
tnoremap <C-j> <C-\><C-N><C-w>j
tnoremap <C-k> <C-\><C-N><C-w>k
tnoremap <C-l> <C-\><C-N><C-w>l

" Ruby on Rails
let g:rubycomplete_rails = 1

" FZF
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Neomake
call neomake#configure#automake('w')

" Abbreviations
ab fsl # frozen_string_literal: true

" Color scheme
colorscheme nord
