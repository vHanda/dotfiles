" Stupid vi bugs
set nocompatible

" Search
set hlsearch
set incsearch
set ignorecase      " case insensitive searching
set smartcase       " but become case sensitive if you type an upper case char

" Display Settings 
set background=dark " enable for dark terminals
set scrolloff=3     " 3 lines above/below cursor while scrolling
set showmatch       " show matching bracket (briefly jump)
set showmode        " show mode in status bar (insert/replace..)
set showcmd         " show typed command in status bar
set ruler           " show cursor position in status bar
set title           " show file in titlebar
set wildmenu        " completion with menu
set modelines=0

" Indentation
set autoindent
set smartindent
set expandtab
set tabstop=4
set shiftwidth=4

set bs=indent,eol,start " Allow backspacing over everything in insert mode
" Show line numbers
set number

" For Word wrap
set wrap
set linebreak
set nolist  " list disables linebreak

" For Shift Tab
imap <S-Tab> <Esc><<i

set nobackup " No backup~ files

set history=100   " remember 100 lines of command history

" Color Scheme
"set t_Co=256

set fillchars=vert:\ ,fold:\ " <- trailing space

" Ctrl-S to save
nnoremap <silent> <C-S> :if expand("%") == ""<CR>browse confirm w<CR>else<CR>confirm w<CR>endif<CR>

" Ctrl-j/k deletes blank line below/above, and Alt-j/k inserts.
"nnoremap <silent><C-j> m`:silent +g/\m^\s*$/d<CR>``:noh<CR>
"nnoremap <silent><C-k> m`:silent -g/\m^\s*$/d<CR>``:noh<CR>
"nnoremap <silent><A-j> :set paste<CR>m`o<Esc>``:set nopaste<CR>
"nnoremap <silent><A-k> :set paste<CR>m`O<Esc>``:set nopaste<CR>

" Use Ctrl-direction to move between windows
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

syntax on
filetype plugin indent on

" Leader
let mapleader = ","

" Remap ` and ' for marks
nnoremap ' `
nnoremap ` '

set title

" Non coding related
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

" Map Ctrl-A -> Start of line, Ctrl-E -> End of line
:map <C-a> <Home>
:map <C-e> <End>

" map control-backspace to delete the previous word
:imap <C-BS> <C-W>
