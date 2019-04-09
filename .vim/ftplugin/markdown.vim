setlocal tabstop=2 softtabstop=2 shiftwidth=2 wrap textwidth=80 formatoptions+=t
let b:keepTwoTrailingWhitespaces=1
setlocal list                                       " here, trailing spaces carry meaning (line break)

" mappings to allow for LaTeX-like writing of Umlauts in Markdown
inoremap "a ä
inoremap "o ö
inoremap "u ü
inoremap "A Ä
inoremap "O Ö
inoremap "U Ü
inoremap "s ß

