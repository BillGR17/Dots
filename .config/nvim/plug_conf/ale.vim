let g:ale_open_list=1
let g:ale_linters = {
  \'c': ['clang'],
  \'javascript': ['eslint']
\}
let g:ale_pattern_options = {
  \'.*\.hbs$': {'ale_enabled': 0},
  \'.*\.handlebars$': {'ale_enabled': 0}
\}
aug CloseLoclistWindowGroup
  au!
  au QuitPre * if empty(&buftype) | lcl | en
aug END
