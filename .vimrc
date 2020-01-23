call plug#begin('~/.vim/plugged')
let g:syntastic_ignore_files = ['\.py$']
let g:syntastic_ignore_files = ['\.py$']

" Plug 'jistr/vim-nerdtree-tabs', { 'on': 'NERDTreeTabsToggle' }
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin' " Git for nerdtree
Plug 'airblade/vim-gitgutter' " Git for the line numbers
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdcommenter' " Comments with Leader + C
Plug 'valloric/youcompleteme' " Autocompletion
Plug 'wesq3/vim-windowswap' " Leader WW to swap panes
" Plug 'nathanaelkane/vim-indent-guides'
Plug 'yggdroot/indentline'

Plug 'JamshedVesuna/vim-markdown-preview' " Ctrl + P to see the preview
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'mtscout6/syntastic-local-eslint.vim'
Plug 'fatih/vim-go'
" Plug 'roman/golden-ratio'
Plug 'chun-yang/auto-pairs' " Add the pairing bracket
Plug 'tiagofumo/vim-nerdtree-syntax-highlight' " symbols for neerdtree file types
Plug 'ryanoasis/vim-devicons' " dependency of nerdtree syntax highliter
Plug 'tpope/vim-surround' " change surroundinng breakets
Plug 'terryma/vim-multiple-cursors' " multiple cursor support

" Py1 - places the column lists in select statement on new lines thon
Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
Plug 'nvie/vim-flake8' " flake 8 install
Plug 'psf/black' " install black auto formatter for python

Plug 'csexton/trailertrash.vim' " Trailing whitespaces are highlighted

" Typescript 
Plug 'leafgarland/typescript-vim'


" SQL Section
Plug 'vim-scripts/SQLUtilities'
Plug 'vim-scripts/Align'

" More tools
" Plug 'hashivim/vim-terraform' " Terraform plugin
Plug 'hashivim/vim-terraform'
" Plug 'scrooloose/syntastic' " Code style checker
Plug 'vim-syntastic/syntastic'
Plug 'juliosueiras/vim-terraform-completion'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }


" Colorschema settings
" ******************************************************************

Plug 'jonathanfilip/vim-lucius'
Plug 'fatih/molokai'
Plug 'beigebrucewayne/min_solo'
Plug 'trusktr/seti.vim'
Plug 'flrnd/plastic.vim'
Plug 'drewtempelmeyer/palenight.vim'
" Plug 'beigebrucewayne/subtle_solo'
" Plug 'kadekillary/subtle_solo'

" Add plugins to &runtimepath
call plug#end()

" let g:lucius_style = 'dark'
" let g:lucius_contrast = 'low'
" let g:lucius_contrast_bg = 'high'
" colorscheme lucius
" colorscheme darkblue
" colorscheme seti

set background=dark
colorscheme palenight
" let g:lightline.colorscheme = 'palenight'
let g:airline_theme = "palenight"

" True colors recommended by palenight theme
if (has("nvim"))
  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

"For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
" < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
if (has("termguicolors"))
  set termguicolors
endif

" panelight says italics are cool to polish shit
let g:palenight_terminal_italics=1





" let g:rehash256 = 1
" let g:molokai_original = 1
" colorscheme molokai
" ccolorscheme subtle_dark

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

" Window resizing with golden ration
let g:golden_ratio_exclude_nonmodifiable = 0
let b:golden_ratio_resizing_ignored = 0


" Yield global in visual mode
vnoremap <Leader>y "+y
vnoremap <Leader>Y "*y

" Vertical and horizontal split then hop to a new buffer
:noremap <Leader>v :vsp^M^W^W<cr>
:noremap <Leader>h :split^M^W^W<cr>

" Nerdtree
" *********************************************************************
" Open NERDTree on start
"autocmd VimEnter * exe 'NERDTree' | wincmd l
"let NERDTreeShowHidden=1

" Nerdtree ignore hide don't show pyc
let NERDTreeIgnore = ['\.pyc$','.ropeproject$','__pycache__','.vscode']
map <C-n> :NERDTreeToggle<CR>

set fillchars+=vert:│
" autocmd VertSplit ctermbg=NONE guibg=NONE
" hi

" let g:NERDTreeMinimalUI = 1
" let g:NERDTreeDirArrows = 1

" let g:NERDTreeDisableFileExtensionHighlight = 1
" let g:NERDTreeDisableExactMatchHighlight = 1
" let g:NERDTreeDisablePatternMatchHighlight = 1

" let g:NERDTreeFileExtensionHighlightFullName = 1
" let g:NERDTreeExactMatchHighlightFullName = 1
" let g:NERDTreePatternMatchHighlightFullName = 1

let g:NERDTreeHighlightFolders = 1 " enables folder icon highlighting using exact match
let g:NERDTreeHighlightFoldersFullName = 1 " highlights the folder name

" you can add these colors to your .vimrc to help customizing
let s:brown = "905532"
let s:aqua =  "3AFFDB"
let s:blue = "689FB6"
let s:darkBlue = "44788E"
let s:purple = "834F79"
let s:lightPurple = "834F79"
let s:red = "AE403F"
let s:beige = "F5C06F"
let s:yellow = "F09F17"
let s:orange = "D4843E"
let s:darkOrange = "F16529"
let s:pink = "CB6F6F"
let s:salmon = "EE6E73"
let s:green = "8FAA54"
let s:lightGreen = "31B53E"
let s:white = "FFFFFF"
let s:rspec_red = 'FE405F'
let s:git_orange = 'F54D27'

let g:NERDTreeExtensionHighlightColor = {} " this line is needed to avoid error
let g:NERDTreeExtensionHighlightColor['css'] = s:blue " sets the color of css files to blue

let g:NERDTreeExactMatchHighlightColor = {} " this line is needed to avoid error
let g:NERDTreeExactMatchHighlightColor['.gitignore'] = s:git_orange " sets the color for .gitignore files

let g:NERDTreePatternMatchHighlightColor = {} " this line is needed to avoid error
let g:NERDTreePatternMatchHighlightColor['.*_spec\.rb$'] = s:rspec_red " sets the color for files ending with _spec.rb

let g:NERDTreeLimitedSyntax = 1


" Clipboard magic
" *********************************************************************
set clipboard=unnamedplus


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
" let g:indent_guides_enable_on_vim_startup = 1
" let g:indent_guides_auto_colors = 0
" autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red ctermbg=236
" autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=237
" set ts=4 sw=4 et
" let g:indent_guides_start_level = 2
" let g:indent_guides_guide_size = 1

" autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=3
" autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=4
" let g:indentguides_spacechar = '┆'

" Use black to autoindent file on save
" autocmd BufWritePre *.py execute ':Black'
let g:black_linelength = 120

" vim flake8 settings
let g:flake8_show_in_gutter = 1
let g:flake8_show_in_file = 1
let g:flake8_show_quickfix=1  " show (default)
let g:flake8_quickfix_height=5
let g:flake8_error_marker='EE'     " set error marker to 'EE'
let g:flake8_warning_marker='WW'   " set warning marker to 'WW'
" let g:flake8_pyflake_marker=''     " disable PyFlakes warnings
" let g:flake8_complexity_marker=''  " disable McCabe complexity warnings
" let g:flake8_naming_marker=''      " disable naming warnings

" to use colors defined in the colorscheme
highlight link Flake8_Error      Error
highlight link Flake8_Warning    WarningMsg
highlight link Flake8_Complexity WarningMsg
highlight link Flake8_Naming     WarningMsg
highlight link Flake8_PyFlake    WarningMsg

autocmd BufWritePost *.py call flake8#Flake8()

" Indentline
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
" autocmd FileType ruby call Tabstyle_two_spaces()
" autocmd FileType scss call Tabstyle_two_spaces()
" autocmd FileType haml call Tabstyle_two_spaces()
" autocmd FileType php call Tabstyle_four_spaces()
autocmd FileType make call Tabstyle_tabs()
autocmd FileType javascript call Tabstyle_two_spaces()
autocmd FileType javascript call Tabstyle_two_spaces()
autocmd FileType typescript call Tabstyle_two_spaces()

" genereally for now remove the tabs
set expandtab


"##############################################################################
" Vim-airline Settings
"##############################################################################
" set guifont=Source\ Code\ Pro\ for\ Powerline\ 14
set guifont=SauceCodePro\ Nerd\ Font\ Mono:h12
" set guifont=Fira\ Mono\ for\ Powerline\ 12
" set guifont=DroidSansMono\ Nerd\ Font:h11
" set guifont=SauceCodePro\ Nerd\ Font:h11
set encoding=UTF-8



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
let g:ycm_server_python_interpreter = '/usr/bin/python3'
"let g:ycm_key_list_select_completion = ['<TAB>', '<Down>']

" ******************************************************************
" ******************************************************************


" Markdown
" ******************************************************************
let vim_markdown_preview_github=1
let vim_markdown_preview_browser='chromium'
let vim_markdown_preview_use_xdg_open=1 " Needed in Linux apparently


" Multicursor remap since it overwrote Nerdtree
" Default mapping
let g:multi_cursor_quit_key            = '<Esc>'
let g:multi_cursor_start_word_key      = '<C-d>'
let g:multi_cursor_select_all_word_key = '<A-n>'
let g:multi_cursor_start_key           = 'g<C-d>'
let g:multi_cursor_select_all_key      = 'g<A-d>'
let g:multi_cursor_next_key            = '<C-d>'
let g:multi_cursor_prev_key            = '<C-p>'
let g:multi_cursor_skip_key            = '<C-x>'
let g:multi_cursor_quit_key            = '<Esc>'
" let g:multi_cursor_use_default_mapping=0
" let g:multi_cursor_start_word_key      = '<C-n>'
" let g:multi_cursor_next_key            = '<C-d>'

map  <Help> <Esc>
map! <Help> <Esc>
map  <Insert> <Esc>
map! <Insert> <Esc>

filetype plugin indent on
syntax enable
syntax on

" set syntax to json for empty file extenstions - no file type
" au BufNewFile,BufRead * if &syntax == '' | set syntax=json | endif


" Line number highligther
" ******************************************************************
highlight CursorLine cterm=NONE ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE
set cursorline
set number

" Settings for python interpreter
" ******************************************************************
" let g:python2_host_prog = '/usr/bin/python'
let g:python3_host_prog = '/usr/bin/python3'

" Setting python-mode pymode
" ******************************************************************
let g:pymode_python = 'python3'
let g:pymode_folding = 0
let g:pymode_virtualenv = 1
let g:pymode_lint_on_write = 0
let g:pymode_options_max_line_length = 120
let g:pymode_lint_checkers = ['pylint', 'pyflakes', 'pep8', 'mccabe']


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
" let g:fzf_command_prefix = 'F'


" SQL Formatter
" ******************************************************************
vmap <silent>sf        <Plug>SQLU_Formatter<CR>
let g:sqlutil_col_list_terminators =
                       \ 'primary,reference,unique,check,foreign'
let g:sqlutil_align_comma = 1
let sqlutil_align_first_word = 1

" Syntastic config
" ******************************************************************
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" (Optional)Remove Info(Preview) window
set completeopt-=preview

" (Optional)Hide Info(Preview) window after completions
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif
" (Optional) Enable terraform plan to be include in filter
let g:syntastic_terraform_tffilter_plan = 1

" (Optional) Default: 0, enable(1)/disable(0) plugin's keymapping
let g:terraform_completion_keys = 1

" (Optional) Default: 1, enable(1)/disable(0) terraform module registry completion
let g:terraform_registry_module_completion = 1

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers=['eslint']
" let g:syntastic_quiet_messages = { "type": "style" } "Test if makes sence
" let g:syntastic_python_checkers = ['python3']
let g:syntastic_python_python_exec = '/usr/local/bin/python3.7'
let g:syntastic_python_flake8_exec = 'python3'
let g:syntastic_python_flake8_args = ['-m', 'flake8']

let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#whitespace#enabled = 1

let g:syntastic_ignore_files = ['\.py$']


" Deoplete settings
" ******************************************************************
let g:deoplete#omni_patterns = {}

call deoplete#custom#option('omni_patterns', {
\ 'complete_method': 'omnifunc',
\ 'terraform': '[^ *\t"{=$]\w*',
\})

call deoplete#initialize()



" URXVT & styling settings
" ******************************************************************
set cursorline

" hi Normal guibg=NONE ctermbg=NONE
hi CursorLine term=bold cterm=bold guibg=Grey40
hi VertSplit ctermbg=NONE guibg=NONE

