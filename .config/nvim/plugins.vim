let s:dein_path = '$HOME/.cache/dein'
let s:dein_src = s:dein_path . '/repos/github.com/Shougo/dein.vim'
if &runtimepath !~# '/dein.vim'
  if !isdirectory(expand(s:dein_src))
    exe '!git clone https://github.com/Shougo/dein.vim' s:dein_src
  en
  exe 'se rtp+=' . s:dein_src
en
cal dein#begin(s:dein_path)
cal dein#add(s:dein_src)
" Better Lang Syntax
cal dein#add('sheerun/vim-polyglot')
" Tools
cal dein#add('dense-analysis/ale')
cal dein#add('Shougo/ddc.vim')
cal dein#add('Shougo/ddc-ui-native')
cal dein#add('vim-denops/denops.vim')
cal dein#add('Exafunction/codeium.vim')
cal dein#add('Shougo/ddc-source-codeium')
cal dein#add('mattn/emmet-vim')
cal dein#add('terryma/vim-multiple-cursors')
" UI & Tools
cal dein#add('airblade/vim-gitgutter')
cal dein#add('arcticicestudio/nord-vim')
cal dein#add('rrethy/vim-hexokinase',{'build': 'make hexokinase'})
cal dein#end()
if dein#check_install()
  cal dein#install()
en
nm <F5> :cal dein#update() <CR>
" Plugin Settings
let g:user_emmet_expandabbr_key='<C-e>'

let g:gitgutter_realtime=1
let g:gitgutter_eager=0

let g:ale_linters = {'c': ['clang'],'javascript': ['eslint']}
let g:ale_pattern_options = {'.*\.hbs$': {'ale_enabled': 0},'.*\.handlebars$': {'ale_enabled': 0}}
let g:ale_open_list=0

colo nord

cal ddc#custom#patch_global('ui', 'native')
ino <silent><expr> <TAB>
\ pumvisible() ? '<C-n>' :
\ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
\ '<TAB>' : ddc#map#manual_complete()
ino <expr><S-TAB>  pumvisible() ? '<C-p>' : '<C-h>'
cal ddc#enable()

let g:Hexokinase_optInPatterns = [ 'full_hex', 'triple_hex', 'rgb', 'rgba', 'hsl', 'hsla', 'colour_names']
