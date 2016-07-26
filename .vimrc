call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'bling/vim-airline'


" Add plugins to &runtimepath
call plug#end()

nnoremap C-h :wincmd h<cr>
nnoremap C-l :wincmd l<cr>
nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>
map <C-n> :NERDTreeToggle<CR>

" autocmd vimenter * NERDTree

filetype plugin indent on
syntax enable
colorscheme monokai

execute pathogen#infect()
call pathogen#helptags()

set number
