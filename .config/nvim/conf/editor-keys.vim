" completions
im <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
" Quick move line
nm <C-Up> :m-2<CR>
nm <C-Down> :m+<CR>
im <C-Up> <Esc>:m .-2<CR>==gi
im <C-Down> <Esc>:m .+1<CR>==gi
vm <C-Up> :m '<-2<CR>gv=gv
vm <C-Down> :m '>+1<CR>gv=gv
" auto close brackets
im ( ()<left>
im [ []<left>
im { {}<left>
im < <><left>
" inverse tab using shift-tab
ino <S-Tab> <C-d>
nn <S-Tab> <<
" Tab on Normal mode
nn <Tab> >>
" Tab on selection
vm <Tab> :s/^/  /g<CR>:nohls<CR>gv
vm <S-Tab> <gv
" Trim whitespace
nm <F2> :%s/\s\+$//e<CR>
" Tabs to spaces
nm <F3> :%s/\t/  /g<CR>
" Save Project
nm <C-s> :w<CR>
im <C-s> <ESC> :w<CR>
" save without any autocommands
nm <C-A-s> :noau w<CR>
im <C-A-s> <ESC> :noau w<CR>
" enable and disable syntax
nm <F7> :if exists("g:syntax_on") <bar>
  \   syn off <bar>
  \ else <bar>
  \   syn on <bar>
  \ endif <CR>
" From plugins
let g:user_emmet_expandabbr_key='<C-e>'
" set keymap to update the plugins
nm <F5> :cal Refresh()<CR>
