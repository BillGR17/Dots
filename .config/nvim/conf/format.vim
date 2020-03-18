" check for executables here
let s:has = {}
let s:has.js = executable("js-beautify")
let s:has.clang = executable("clang-format")
let s:has.gofmt = executable("gofmt")
" enable syntax
syn on
" executes formating script
fu s:ExecFormat(exec)
  exe "%!"a:exec|g/^$/d|%s/\s\+$//e
endf
" format function init
fu FormatIt()
  " check if the current file has at least more than 1 line of code
  if line('$') > 1
    " save current position
    let l:pos=winsaveview()
    " check file syntax and if format exec exist
    if &syn =~# '^\(javascript\|json\)' && s:has.js
      undoj|cal s:ExecFormat("js-beautify -s 2")
    elsei &syn =~# '\(html\|mustache\|svg\)' && s:has.js
      undoj|cal s:ExecFormat("js-beautify -s 2 --type html")
    elsei &syn ==# 'css' && s:has.js
      undoj|cal s:ExecFormat("js-beautify -s 2 --type css")
    elsei &syn =~# '^\(c\|cpp\)' && s:has.clang
      undoj|cal s:ExecFormat("clang-format --style=file")
    elsei &syn ==# 'go' && s:has.gofmt
      undoj|cal s:GoFMT()
    en
    " always remove tabs and use spaces instead
    %s/\t/  /g
    " move to old position after done executing¬
    cal winrestview(l:pos)
  en
endf
" Fixes the issue from gofmt
" on error it will ignore the output
fu s:GoFMT()
  " get all text from file before gofmt
  let s:buff = join(getline(1, '$'), "\n")
  execute("%!gofmt")
  " if the gofmt exits with a non-zero
  " delete everything and paste the old text
  if v:shell_error != 0
    1,$d|pu = s:buff
  en
  g/^$/d|%s/\s\+$//e
endf
au BufWritePre * sil! cal FormatIt()
