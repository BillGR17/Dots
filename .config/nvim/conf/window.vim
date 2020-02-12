" Quick split with ctr + arrow
nm <silent> <C-A-Right> :vs<CR>:wincmd l<CR>
nm <silent> <C-A-Down> :sp<CR>:wincmd j<CR>
nm <silent> <C-A-Up> :sp<CR>:wincmd R<CR>wincmd k<CR>
nm <silent> <C-A-Left> :vs<CR>
" Change window with alt + arrow
nm <silent> <A-Up> :wincmd k<CR>
nm <silent> <A-Down> :wincmd j<CR>
nm <silent> <A-Left> :wincmd h<CR>
nm <silent> <A-Right> :wincmd l<CR>
