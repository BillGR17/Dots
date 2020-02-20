let s:has = {}
let s:has.js = executable("js-beautify")
let s:has.clang = executable("clang-format")
let s:has.gofmt = executable("gofmt")
" enable syntax
syn on
" this function saves cursor position and executes beautify and deletes empty lines
fu B_C()
  if line('$') > 1
    " current position¬
    let s:_c_c=getpos(".")
    if &syn =~# '\(\^*javascript\|json\)' && s:has.js
      sil! undoj|sil! exe "%!js-beautify -s 2"|sil! g/^$/d
    elsei &syn =~# '\(html\|mustache\|svg\)' && s:has.js
      sil! undoj|sil! exe "%!js-beautify -s 2 --type html"|sil! g/^$/d
    elsei &syn ==# 'css' && s:has.js
      sil! undoj|sil! exe "%!js-beautify -s 2 --type css"|sil! g/^$/d
    elsei &syn =~# '\^\(c\|cpp\)\$' && s:has.clang
      sil! undoj|sil! exe "%!clang-format --style=file"|sil! g/^$/d
    elsei &syn ==# 'go' && s:has.gofmt
      sil! undoj|sil! cal GoFMT()
    en
    " move to current position after done executing¬
    cal setpos(".",s:_c_c)
  en
endf
" Fixes all the issues from gofmt
" tabs and empty lines
" and on error it will ignore the output
fu GoFMT()
  " get all text from file before gofmt
  let s:buff = join(getline(1, '$'), "\n")
  execute("%!gofmt")
  " if the gofmt exits with a non-zero
  " delete everything and paste the old text
  if v:shell_error != 0
    1,$d|pu = s:buff
  en
  " remove empty lines and tabs
  g/^$/d|%s/\t/  /g
endf
au BufWritePre * cal B_C()
