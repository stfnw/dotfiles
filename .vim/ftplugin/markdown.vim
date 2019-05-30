setlocal tabstop=2 softtabstop=2 shiftwidth=2 wrap textwidth=80 formatoptions+=t
let b:keepTwoTrailingWhitespaces=1
setlocal list                                       " here, trailing spaces carry meaning (line break)

" mappings to allow for LaTeX-like writing of Umlauts in Markdown
inoremap <buffer> "a ä
inoremap <buffer> "o ö
inoremap <buffer> "u ü
inoremap <buffer> "A Ä
inoremap <buffer> "O Ö
inoremap <buffer> "U Ü
inoremap <buffer> "s ß
