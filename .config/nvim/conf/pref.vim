" faster&better gui updates + mouse + remember undo's
se mouse=a lz ut=100 smc=300 title udf
" suggestions menu
se ph=20 cot=menuone,preview
" show matching open-close brackets
se sm
" mouse cross
se cuc cul
" set tabs and spaces smart indents
se ts=2 sw=2 sts=2 et si
" show everything whitespace etc...
se nowrap nu list lcs=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:.
" Greek keymap support & Encoding
se spell fenc=utf-8 kmp=greek_utf-8 imi=0 ims=-1
" Theme Settings
se tgc bg=dark 
" Auto save on focus lost
au BufLeave * sil! wa
"Plugin settings
let g:gitgutter_realtime=1
let g:gitgutter_eager=0
let g:ale_linters = {'c': ['clang'],'javascript': ['eslint']}
let g:ale_pattern_options = {'.*\.hbs$': {'ale_enabled': 0},'.*\.handlebars$': {'ale_enabled': 0}}
let g:ale_open_list=0
