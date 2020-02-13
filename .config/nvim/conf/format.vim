" enable syntax
syn on
" this function saves cursor position and executes beautify and deletes empty lines
fu B_C(_file)
  if line('$') > 1
    " current position¬
    let _c_c=getpos(".")
    if a:_file=="js"
      sil! undoj|sil! exe "%!js-beautify -s 2"|sil! g/^$/d
    elsei a:_file=="ht"
      sil! undoj|sil! exe "%!js-beautify -s 2 --type html"|sil! g/^$/d
    elsei a:_file=="cs"
      sil! undoj|sil! exe "%!js-beautify -s 2 --type css"|sil! g/^$/d
    elsei a:_file=="c"
      sil! undoj|sil! exe "%!clang-format --style=file"|sil! g/^$/d
    elsei a:_file=="go"
      sil! undoj|sil! call GoFMT()
    en
    " move to current position after done executing¬
    call setpos(".",_c_c)
  en
endf
" Fixes all the issues from gofmt
" tabs and empty lines
" and on error it will ignore the output
fu GoFMT()
  " get all text from file before gofmt
  let buff = join(getline(1, '$'), "\n")
  execute("%!gofmt")
  " if the gofmt exits with a non-zero
  " delete everything and paste the old text
  if v:shell_error != 0
    1,$d|pu = buff
  en
  " remove empty lines and tabs
  g/^$/d | %s/\t/  /g
endf
" if js-beautify exist beautify code on every save¬
if executable("js-beautify")
  au FileType javascript.jsx,json,javascript au BufWrite *.js,*.json call B_C("js")
  au FileType html,html.handlebars au BufWrite *.html,*.hbs,*.handlebars,*.twig call B_C("ht")
  au FileType css au BufWritePre *.css call B_C("cs")
en
" if clang-format exist beautify code on every save¬
if executable("clang-format")
  au FileType c,cpp au BufWritePre *.c,*.cpp call B_C("c")
en
if executable("gofmt")
  au FileType go au BufWritePre *.go call B_C("go")
en
" Remove empty whitespace
au FileType sass au BufWritePre <buffer> %s/\s\+$//e
