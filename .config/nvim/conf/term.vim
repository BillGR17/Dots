" terminal starts on insert mode
au TermOpen * star
au TermOpen * setf terminal
" rename status line for terminal
au TermOpen * setl stl=Term[%{b:term_title}]
" disable spellcheker on terminal
au TermOpen * setlocal nospell
" Create terminal window on bottom
nm <silent> <C-A-t> :bo 10sp <bar> term <CR>
" leave terminal
tno <Esc> <c-\><c-n>
