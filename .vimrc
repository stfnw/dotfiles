" -------- Allow for configuration with/without plugins ----------------------
" ------------------------------------------------------------------------------
if filereadable(glob('~/.vimrc-plugins'))
    let vimrc_config_with_plugins = 1
    source ~/.vimrc-plugins
endif


" -------- General Settings ----------------------------------------------------
" ------------------------------------------------------------------------------
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab

set autoindent

set ignorecase smartcase

set foldmethod=syntax
set nofoldenable                                    " unfold all text per default; toggle with zi

set linebreak breakindent
let &showbreak = '>>> '

let is_bash         = 1                             " prefer bash shell syntax
let asmsyntax       = 'nasm'                        " prefer nasm assembly syntax
let c_syntax_for_h  = 1                             " use c (and not c++) syntax for header files
let tex_flavor      = 'latex'                       " use latex for tex files
let tex_fold_enabled=1

set guioptions-=T                                   " remove toolbar

set number                                          " enable line numbers
set ruler                                           " show line / column number in status line

syntax on                                           " enable syntax highlighting
if !exists('vimrc_config_with_plugins') | colorscheme desert | endif

filetype on
filetype plugin on
filetype indent on


" -------- Encoding Settings ---------------------------------------------------
" ------------------------------------------------------------------------------
scriptencoding=utf-8
set encoding=utf-8 " fileencoding=utf-8


" -------- Key Bindings and Shortcuts ------------------------------------------
" ------------------------------------------------------------------------------
" copy/paste to/from system / x clipboard
vnoremap <C-c> "+y
nnoremap <Space> "+p

" show location list
nnoremap <leader>ls :lopen<CR>
" close location list
nnoremap <leader>lc :lclose<CR>

" toggle spell checking
nnoremap <silent> <leader>s :set spell!<CR>

" easier navigation between tabs
nnoremap tj :tabnext<CR>
nnoremap tk :tabprev<CR>


" -------- Spell Checking ------------------------------------------------------
" ------------------------------------------------------------------------------
set spelllang=de,en


" -------- Swapfiles in one place ----------------------------------------------
" ------------------------------------------------------------------------------
if !isdirectory($HOME . '/.vim/swapfiles/')         " change directory for swap files
    call mkdir($HOME . '/.vim/swapfiles/','p')
endif
set directory=$HOME/.vim/swapfiles//                " if a directory ends in two path separators, file name uniqueness is ensured


" -------- Persistent undo -----------------------------------------------------
" ------------------------------------------------------------------------------
if has('persistent_undo')                           " enable persistent undo across writes/quits
    if !isdirectory($HOME . '/.vim/undo/')
        call mkdir($HOME . '/.vim/undo/','p')
    endif
    set undofile
    set undodir=$HOME/.vim/undo/
endif


" -------- Autocmds ------------------------------------------------------------
" ------------------------------------------------------------------------------
augroup trailing_whitespace
    autocmd!
    autocmd Syntax * syntax match Error /\s\+$\| \+\ze\t/ containedin=ALL
    " autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red

    " autocmd BufWritePre * :call StripTrailintWhitespace()
augroup end

function! StripTrailintWhitespace()     " strips trailing whitespaces (may be costly / take long, => disabled for now)
    if exists('b:keepTwoTrailingWhitespaces') && b:keepTwoTrailingWhitespaces == 1
        " preserve last two whitespaces (e.g. important for markdown paragraphs etc.)
        call Preserve('%s/\(\s\@!.\)\s$/\1/e')
        call Preserve('%s/\s\{2,}$/  /e')
        call Preserve('%s/^[[:blank:]]\+$//e')
    else
        " strip all trailing whitespace
        call Preserve('%s/\s\+$//e')
    endif
endfunction

" see http://vimcasts.org/episodes/tidying-whitespace/
function! Preserve(command)
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line('.')
  let c = col('.')
  " Do the business:
  execute a:command
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction
