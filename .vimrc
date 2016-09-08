call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree'
"Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'runoshun/nerdtree-git-plugin', { 'branch': 'ignored_status' } "Has marking for gitignored files
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdcommenter'
"Plug 'valloric/youcompleteme' "Autocompletion

" Add plugins to &runtimepath
call plug#end()

" Searching/highlight stuff
set hlsearch  " highlight search
set incsearch  " Incremental search, search as you type

let mapleader = ","

" Windows
" *********************************************************************
set equalalways " Multiple windows, when created, are equal in size
set splitbelow splitright

" Window management
" navigate buffers with Ctrl+Arrows
nnoremap <silent> <C-Right> <c-w>l
nnoremap <silent> <C-Left> <c-w>h
nnoremap <silent> <C-Up> <c-w>k
nnoremap <silent> <C-Down> <c-w>j

" Vertical and horizontal split then hop to a new buffer
:noremap <Leader>v :vsp^M^W^W<cr>
:noremap <Leader>h :split^M^W^W<cr>


" Open NERDTree on start
autocmd VimEnter * exe 'NERDTree' | wincmd l


" NERD Commenter
" **************************************************************
let NERDCreateDefaultMappings=0 " I turn this off to make it simple

" Toggle commenting on 1 line or all selected lines. Wether to comment or
" not
" is decided based on the first line; if it's not commented then all lines
" will be commented
:map <Leader>c :call NERDComment(0, "toggle")<CR>

" works as bash completition
set wildmode=longest:full
set wildmenu

" Directories
" *****************************************************************
" Setup backup location and enable
set backupdir=~/.vim/tmp/backup
"set backup

" Set Swap directory
set directory=~/.vim/tmp/swap

" Sets path to directory buffer was loaded from
autocmd BufEnter * lcd %:p:h


" Searching
" ***************************************************************
set ignorecase " Ignore case when searching
set smartcase " Ignore case when searching lowercase

"Paste toggle
set pastetoggle=<leader>z

" Indenting
" *******************************************************************
set ai " Automatically set the indent of a new line (local to buffer)
set si " smartindent (local to buffer)

function! Tabstyle_tabs()
  " Using 4 column tabs
  set softtabstop=4
  set shiftwidth=4
  set tabstop=4
  set noexpandtab
  autocmd User Rails set softtabstop=4
  autocmd User Rails set shiftwidth=4
  autocmd User Rails set tabstop=4
  autocmd User Rails set noexpandtab
endfunction

function! Tabstyle_two_spaces()
  " Use 2 spaces
  set softtabstop=2
  set shiftwidth=2
  set tabstop=2
  set expandtab
endfunction

function! Tabstyle_four_spaces()
  " Use 4 spaces
  set softtabstop=4
  set shiftwidth=4
  set tabstop=4
  set expandtab
endfunction

call Tabstyle_two_spaces()

autocmd FileType python call Tabstyle_four_spaces()
autocmd FileType ruby call Tabstyle_two_spaces()
autocmd FileType scss call Tabstyle_two_spaces()
autocmd FileType haml call Tabstyle_two_spaces()
autocmd FileType php call Tabstyle_four_spaces()
autocmd FileType make call Tabstyle_tabs()


" Airline fix
" ******************************************************************
"set fillchars+=stl:\ ,stlnc:\
set guifont=Source\ Code\ Pro\ for\ Powerline
"airline configuration
let g:Powerline_symbols = 'fancy'
"let g:airline_powerline_fonts = 1
let g:airline_detect_modified=1
let g:airline_detect_paste=1
let g:airline_detect_crypt=1
let g:airline_detect_iminsert=0

"if !exists('g:airline_symbols')
  "let g:airline_symbols = {}
"endif
"let g:airline_symbols.space = "\ua0"

 "if !exists('g:airline_symbols')
     "let g:airline_symbols = {}
     "endif

 ""*******************************************************************
map <C-n> :NERDTreeToggle<CR>

filetype plugin indent on
syntax enable
colorscheme monokai

execute pathogen#infect()
call pathogen#helptags()

set number
