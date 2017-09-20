" if empty(glob("~/.vim/autoload/plug.vim"))
"   execute 'mkdir -p ~/.vim/plugged'
"   execute 'mkdir -p ~/.vim/autoload'
"   execute '!curl -fLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
" endif

call plug#begin('~/.vim/plugged')
" Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeTabsToggle' }
" Plug 'jistr/vim-nerdtree-tabs', { 'on': 'NERDTreeTabsToggle' }

Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin' " Git for nerdtree
Plug 'airblade/vim-gitgutter' " Git for the line numbers
Plug 'tpope/vim-fugitive'
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdcommenter' " Comments with Leader + C
Plug 'valloric/youcompleteme' " Autocompletion
Plug 'scrooloose/syntastic' " Code style checker
Plug 'wesq3/vim-windowswap' " Leader WW to swap panes
Plug 'nathanaelkane/vim-indent-guides'
Plug 'JamshedVesuna/vim-markdown-preview' " Ctrl + P to see the preview
Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
Plug 'mtscout6/syntastic-local-eslint.vim'
" Plug 'zchee/nvim-go', { 'do': 'make'}
Plug 'fatih/vim-go'

" Colorschema settings
" ******************************************************************
" Plug 'jonathanfilip/vim-lucius' " color scheme
" let g:lucius_style = 'dark'
" let g:lucius_contrast = 'low'
" let g:lucius_contrast_bg = 'high'
" colorscheme lucius

" colorscheme peachpuff
Plug 'fatih/molokai'
" Add plugins to &runtimepath
call plug#end()

let g:rehash256 = 1
let g:molokai_original = 1
colorscheme molokai


" Searching/highlight stuff
set hlsearch  " highlight search
set incsearch  " Incremental search, search as you type
set exrc

let mapleader = "\<Space>"


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

nnoremap <silent> <C-l> <c-w>l
nnoremap <silent> <C-h> <c-w>h
nnoremap <silent> <C-k> <c-w>k
nnoremap <silent> <C-j> <c-w>j



" Yield global in visual mode
vnoremap <Leader>y "+y

" Vertical and horizontal split then hop to a new buffer
:noremap <Leader>v :vsp^M^W^W<cr>
:noremap <Leader>h :split^M^W^W<cr>

" Open NERDTree on start
"autocmd VimEnter * exe 'NERDTree' | wincmd l
"let NERDTreeShowHidden=1

" NERD Commenter
" **************************************************************
:map <Leader>c :call NERDComment(0, "toggle")<CR>

let NERDCreateDefaultMappings=0 " I turn this off to make it simple
" Toggle commenting on 1 line or all selected lines. Wether to comment or
" not
" is decided based on the first line; if it's not commented then all lines
" will be commented

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
:mes
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1
let NERDTreeShowHidden=1


" works as bash completition
set wildmode=longest,full
set wildmenu


" Directories
" *****************************************************************
" Setup backup location and enable
set backupdir=~/.vim/tmp/backup
"set backup

" Set Swap directory
set directory=~/.vim/tmp/swap
set noswapfile 

" Sets path to directory buffer was loaded from
" autocmd BufEnter * lcd %:p:h


" Searching
" ***************************************************************
set ignorecase " Ignore case when searching
set smartcase " Ignore case when searching lowercase

"Paste toggle
set pastetoggle=<leader>z

" Indenting
" *******************************************************************
" Indendguides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red ctermbg=236
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=237
" *******************************************************************
set ai " Automatically set the indent of a new line (local to buffer)
set si " smartindent (local to buffer)

function! Tabstyle_tabs()
  " Using 4 column tabs
  set softtabstop=0
  set shiftwidth=4
  set tabstop=4
  "set noexpandtab
  autocmd User Rails set softtabstop=4
  autocmd User Rails set shiftwidth=4
  autocmd User Rails set tabstop=4
  autocmd User Rails set noexpandtab
endfunction

function! Tabstyle_two_spaces()
  " Use 2 spaces
  set softtabstop=0
  set shiftwidth=2
  set tabstop=2
  set expandtab
endfunction

function! Tabstyle_four_spaces()
  " Use 4 spaces
  set softtabstop=0
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
autocmd FileType javascript call Tabstyle_two_spaces()

" genereally for now remove the tabs
set expandtab


"##############################################################################
" Vim-airline Settings
"##############################################################################
"set guifont=Source\ Code\ Pro\ for\ Powerline\ 14
set guifont=Fira\ Mono\ for\ Powerline\ 14
set encoding=utf-8

"airline configuration
let g:Powerline_symbols = 'fancy'
let g:airline_powerline_fonts = 1
let g:airline_detect_modified=1
let g:airline_detect_paste=1
let g:airline_detect_crypt=1
let g:airline_detect_iminsert=0
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline#extensions#tabline#enabled =1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#buffer_nr_show = 1


"##############################################################################
" Vim shorcuts changing buffers
"##############################################################################
nnoremap <Leader>1 :1b<CR>
nnoremap <Leader>2 :2b<CR>
nnoremap <Leader>3 :3b<CR>
nnoremap <Leader>4 :4b<CR>
nnoremap <Leader>5 :5b<CR>
nnoremap <Leader>6 :6b<CR>
nnoremap <Leader>7 :7b<CR>
nnoremap <Leader>8 :8b<CR>
nnoremap <Leader>9 :9b<CR>
nnoremap <Leader>0 :10b<CR>
" You complete me 
" ******************************************************************
let g:ycm_key_list_select_completion = ['<TAB>']
let g:ycm_server_python_interpreter = '/usr/local/bin/python2.7'
"let g:ycm_key_list_select_completion = ['<TAB>', '<Down>']

" Syntax highligther
" ******************************************************************
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0 
let g:syntastic_javascript_checkers=['eslint']

let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#whitespace#enabled = 1
" ******************************************************************
" ******************************************************************


" Markdown
" ******************************************************************
let vim_markdown_preview_github=1
let vim_markdown_preview_browser='Google Chrome'



map <C-n> :NERDTreeToggle<CR>
map  <Help> <Esc>
map! <Help> <Esc>
map  <Insert> <Esc>
map! <Insert> <Esc>

filetype plugin indent on
syntax enable


" Line number highligther
" ******************************************************************
highlight CursorLine cterm=NONE ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE
set cursorline
set number

" Settings for python interpreter
" ******************************************************************
let g:python2_host_prog = '/usr/local/bin/python'
let g:python3_host_prog = '/usr/local/bin/python3'

" Settings for go
" ******************************************************************
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1

let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck']
let g:go_metalinter_autosave = 1

let g:go_fmt_command = "goimports"

let g:go_def_mode = 'godef' " go to defenition


" Fzf stuff
" ******************************************************************
let g:fzf_command_prefix = 'F'
