" te: Skip initialization for vim-tiny or vim-small.
if 0 | endif

filetype off

if has('vim_starting')
    if &compatible
        set nocompatible
    endif
    set runtimepath+=~/.vim/bundle/neobundle.vim
endif

call neobundle#begin(expand('~/.vim/bundle/'))

NeoBundle 'Shougo/neobundle.vim'
NeoBundle 'VimClojure'
NeoBundle 'Shougo/vimshell'
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'jpalardy/vim-slime'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'Shougo/vimfiler.vim'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 't9md/vim-textmanip'

" Editor config
NeoBundle 'editorconfig/editorconfig-vim'

" gitgutter
NeoBundle 'airblade/vim-gitgutter'

" vim-figtive
NeoBundle 'tpope/vim-fugitive'

" unite
NeoBundle 'Shougo/unite.vim'
NeoBundle 'ujihisa/unite-colorscheme'

" NERDTree
NeoBundle 'scrooloose/nerdtree'
nnoremap <silent><C-e> :NERDTreeToggle<CR>
autocmd vimenter * if !argc() | NERDTree | endif

" Airline
NeoBundle 'vim-airline/vim-airline'
NeoBundle 'vim-airline/vim-airline-themes'
"let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:Powerline_symbols = 'fancy'
let g:airline_theme='badwolf'
let g:airline_left_sep = '⮀'
let g:airline_right_sep = '⮂'
let g:airline#extensions#tabline#left_sep = '⮀'
let g:airline#extensions#tabline#left_alt_sep = '⮀'

" Indent line
NeoBundle 'Yggdroot/indentLine'

" theme
NeoBundle 'nanotech/jellybeans.vim'

call neobundle#end()

filetype plugin indent on     " required!
filetype indent on

syntax on

" 色設定
colorscheme jellybeans
set t_Co=256
set t_Sf=[3%dm
set t_Sb=[4%dm
set t_ut=

" status line
set laststatus=2

" tab line
set showtabline=2

" line number
set number

" show special chars
"set list
"set listchars=tab:›\ ,trail:_,extends:>,precedes:<,nbsp:%

" tab
set tabstop=2
set noexpandtab
set shiftwidth=2

" which wrap
set whichwrap=b,s,h,l,<,>,[,]

" backspace
set backspace=indent,eol

NeoBundleCheck

set encoding=utf-8
set fileencodings=utf-8,iso-2022-jp,euc-jp,sjis,cp932,cp20932
set fileencoding=utf-8
