" File: .vimrc
" Author: Daniel Bingham <dbingham@theroadgoeson.com>
"
" Forked from: https://github.com/jez/vim-as-an-ide

" Vundle needs this 
set nocompatible

filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

" ----- Making Vim look good ------------------------------------------
Plugin 'altercation/vim-colors-solarized'
Plugin 'bling/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'gcmt/taboo.vim'

" ----- Vim as a programmer's text editor -----------------------------
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'xolox/vim-misc'
Plugin 'vadimr/bclose.vim'
Plugin 'mileszs/ack.vim'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'

" ----- Working with Git ----------------------------------------------
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-fugitive'

" ----- Folding -------------------------------------------------------
Plugin 'Konfekt/FastFold'

" ----- Syntax plugins ------------------------------------------------
Plugin 'sheerun/vim-polyglot'
Plugin 'lifepillar/pgsql.vim'

"Plugin 'tpope/vim-markdown'
"Plugin 'jtratner/vim-flavored-markdown'
"Plugin 'othree/yajs.vim'
" Plugin 'pangloss/vim-javascript'
"Plugin 'othree/javascript-libraries-syntax.vim'
"Plugin 'othree/html5.vim'
" Plugin 'mxw/vim-jsx'
"Plugin 'vim-ruby/vim-ruby'
"Plugin 'noprompt/vim-yardoc'
"Plugin 'hashivim/vim-terraform'
"Plugin 'kchmck/vim-coffee-script'
"Plugin 'pearofducks/ansible-vim'
"Plugin 'hashivim/vim-hashicorp-tools'

call vundle#end()

filetype plugin indent on

" Load and use localized vimrc files
set exrc

" --- General settings ---
set backspace=indent,eol,start
set ruler
set number
set showcmd
set incsearch
set hlsearch
set ts=4 sw=4 et

" Ruby specific spacing
au FileType ruby setlocal ts=2 sw=2 et

" Folding
set foldmethod=indent
set foldnestmax=6
set foldlevelstart=1

" PHP Specific folding
let g:php_folding=2
" Ruby Specific Folding
let ruby_no_comment_fold=1

syntax on

" ----- Plugin-Specific Settings --------------------------------------

" ----- altercation/vim-colors-solarized settings -----
set background=dark

" Uncomment the next line if your terminal is not configured for solarized
let g:solarized_termcolors=256

" Set the colorscheme
colorscheme solarized

" ----- bling/vim-airline settings -----
" Always show statusbar
set laststatus=2
let g:airline_theme='solarized'
let g:airline_solarized_bg='dark'

" Show PASTE if in paste mode
let g:airline_detect_paste=1
let g:airline#extensions#default#layout = [
      \ [ 'a', 'b', 'c' ],
      \ [  'z', 'error' ]
      \ ]

" Show airline for tabs too
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#tab_nr_type = 1 " tab number
let g:airline#extensions#tabline#buffer_idx_mode = 0

" ----- Fzf ------

let $FZF_DEFAULT_COMMAND = 'ag -g ""'

" ----- jistr/vim-nerdtree-tabs -----
" Open/close NERDTree Tabs with \t
nmap <silent> <leader>t :NERDTreeTabsToggle<CR>
" To have NERDTree always open on startup
let g:nerdtree_tabs_open_on_console_startup = 1
" Ignore python's compiled binaries
let NERDTreeIgnore = ['\.pyc$', '__pycache__']

" ----- mileszs/ack.vim -----
" Make :ack use ag instead of ack.
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif
cnoreabbrev Ack Ack!

" ----- pangloss/vim-javascript settings -----
" Highlight jsdoc
let g:javascript_plugin_jsdoc = 1

" ----- airblade/vim-gitgutter settings -----
" Required after having changed the colorscheme
hi clear SignColumn
" In vim-airline, only display "hunks" if the diff is non-zero
let g:airline#extensions#hunks#non_zero_only = 1
let g:gitgutter_max_signs = 1000  " 

" ----- sheerun/polyglot (php) -----
" Override syntax coloring for php comments to highlight phpdoc
function! PhpSyntaxOverride()
  hi! def link phpDocTags  phpDefine
  hi! def link phpDocParam phpType
endfunction

"------- lifepillar/pgsql.vim ------
let g:sql_type_default = 'pgsql'

augroup phpSyntaxOverride
  autocmd!
  autocmd FileType php call PhpSyntaxOverride()
augroup END

