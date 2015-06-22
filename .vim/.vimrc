" -----------------------------
"  VUNDLE
" -----------------------------
set nocompatible    " turn off vi compatibility
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'chrisyip/Better-CSS-Syntax-for-Vim'
Plugin 'flazz/vim-colorschemes'
Plugin 'sudar/vim-arduino-syntax'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'vim-scripts/CSApprox'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'bling/vim-airline'
Plugin 'tikhomirov/vim-glsl'
Plugin 'elzr/vim-json'

call vundle#end()
filetype plugin indent on

" -----------------------------
"  GENERAL SETTINGS
" -----------------------------
" use .vimrc files from current dir if present
set exrc
" visual autocomplete for cmd menu
set showcmd
" restrict usage of some commands for non default .vimrc
set secure
" set shell
set shell=/bin/zsh

syntax enable       " syntax highlighting
set number          " turn on line numbers
set mouse=a         " enable all mouse features
set statusline+=%F
set nospell

" reload files edited outside of vim
set autoread

" create <filename>.un~ for undo after file close
set undofile

" encoding is utf-8
set encoding=utf-8
set fileencoding=utf-8

" set unix line endings
set fileformat=unix
" when reading new files try unix line endings, then dos. use unix for new buffers
" set fileformats=unix,dos
" indentation
set expandtab " use spaces instead of tab
set autoindent " autoindent based on line above
set smartindent " smarter indent for c-like languages
set shiftwidth=4 " when reading, tabs are 4 spaces
set softtabstop=4 " in insert mode, tabs are 4 spaces
" limit line width to 80 and highlight col 80
set textwidth=80
if(exists('++colorcolumn'))
    set colorcolumn=81
    highlight ColorColumn ctermbg=8
endif

" change explorer style to tree
let g:netrw_liststyle=3
" change leader key to ,
let mapleader=","

" -----------------------------
"  COLOURS
" -----------------------------

" color scheme
set background=dark
set t_Co=256        " set 256 colour mode
"colorscheme railscasts
colorscheme Sunburst
"colorscheme darkeclipse
"colorscheme molokai

" -----------------------------
"  SEARCHING
" -----------------------------

set wildmenu        " visual autocomplete for cmd menu
set showmatch       " highlight matching [{()}]
set incsearch       " search as characters are entered
set hlsearch        " highlight matches

" <,-space> clears search
nnoremap <leader><space> :nohlsearch<CR>

" -------------------------------
"  KEY BINDINGS
" -------------------------------
" buffers
"
" <F5> lists buffers
":nnoremap <F5> :buffers<CR>:buffer<Space>
nnoremap <silent> <F5> :BufExplorerV<CR>

" open new empty buffer
nnoremap <leader>B :enew<CR>
" move to next buffer
nnoremap <leader>l :bnext<CR>
" move to previous buffer
nnoremap <leader>h :bprevious<CR>

" netrw
"
" <F6> explorer
nnoremap <silent> <F6> :Lexplore<CR>

" <tab> match bracket pairs
nnoremap <tab> %
vnoremap <tab> %

" disable arrow keys in insert and normal modes
" forces use of hjkl and normal mode
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
"inoremap <up> <nop>
"inoremap <down> <nop>
"inoremap <left> <nop>
"inoremap <right> <nop>
nnoremap j gj
nnoremap k gk

" -----------------------------
"  WINDOW SPLITS
" -----------------------------
set splitbelow
set splitright

" manage window splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" -----------------------------
"  PLUGINS
" -----------------------------

" vim-airline
"
" enable list of buffers
let g:airline#extensions#tabline#enabled = 1
" show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

" ----------------------------
"  FILETYPE SETS
"  ---------------------------
" autocmd BufNewFile,Bufread *.json set ft=javascript
