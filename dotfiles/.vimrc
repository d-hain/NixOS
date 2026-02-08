"" -- Suggested options --
" Show a few lines of context around the cursor. Note that this makes the
" text scroll if you mouse-click near the start or end of the window.
set scrolloff=5

" Do incremental searching.
set incsearch

" Set relative line numbers and line number
set rnu
set number

" Move Lines up or down with Alt + k or Alt + j
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" When using Ctrl + d and Ctrl + u move cursor to the middle of the screen
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

syntax on
colorscheme habamax
filetype plugin indent on
