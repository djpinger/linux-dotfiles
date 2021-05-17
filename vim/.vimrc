set encoding=UTF-8
set t_Co=256
set background=dark
colorscheme molokai
syntax on
set paste
set ruler
set expandtab
set tabstop=4
set shiftwidth=4
map <F2> :retab
set laststatus=2
set number
filetype indent on
set wildmenu
map <silent> <A-Left> :tabprevious<CR>
map <silent> <A-Right> :tabnext<CR>
set listchars=tab:>-,trail:~,extends:>,precedes:<
set list
set mouse=a
filetype plugin on
call plug#begin('~/.vim/plugged')
Plug 'hashivim/vim-packer'
Plug 'hashivim/vim-terraform'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'scrooloose/nerdtree'
Plug 'dense-analysis/ale'
Plug 'ryanoasis/vim-devicons'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'scrooloose/syntastic'
Plug 'airblade/vim-gitgutter'
Plug 'plasticboy/vim-markdown'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
call plug#end()
map <F2> :NERDTreeToggle<CR>
map <F3> :NERDTreeFocus<CR>
silent! colorscheme dracula
let g:airline_theme='dracula'
