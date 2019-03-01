" slight modifications to the light PaperColorTheme
highlight clear
if exists('syntax_on')
    syntax reset
endif

set t_Co=256
set background=light
runtime colors/PaperColor.vim

let g:colors_name = 'PaperColorPatched'

highlight StatusLine ctermfg=246 guifg=246
