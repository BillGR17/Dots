" check for executables here
let s:has = {}
let s:has.js = executable("js-beautify")
let s:has.clang = executable("clang-format")
let s:has.gofmt = executable("gofmt")
let s:has.rustfmt = executable("rustfmt")
let s:has.yapf = executable("yapf")
" enable syntax
syn on
" format function init
fu FormatIt()
  " check if the current file has at least more than 1 line of code
  if line('$') > 1
    " save current position
    let l:pos=winsaveview()
    " check file syntax and if format exec exist
    if &syn =~# '^\(javascript\|json\)' && s:has.js
      undoj|exe "%! js-beautify -s 2"
    elsei &syn =~# '\(html\|mustache\|svg\)' && s:has.js
      undoj|exe "%! js-beautify -s 2 --type html"
    elsei &syn ==# 'css' && s:has.js
      undoj|exe "%! js-beautify -s 2 --type css"
    elsei &syn =~# '^\(c$\|cpp\)' && s:has.clang
      undoj|exe "%! clang-format --style=file"
    elsei &syn =~# 'rust' && s:has.rustfmt
      undoj|cal s:MyFMT("rustfmt --emit stdout")
    elsei &syn ==# 'go' && s:has.gofmt
      undoj|cal s:MyFMT("gofmt")
    elsei &syn ==# 'python' && s:has.yapf
      undoj|cal s:MyFMT("yapf")
    en
    " remove trailing spaces
    %s/\s\+$//e
    " always remove tabs and use spaces instead
    %s/\t/  /g
    " move to old position after done executing¬
    cal winrestview(l:pos)
  en
endf
" Fixes the issue from gofmt&rustfmt
" on error it will ignore the output
fu s:MyFMT(exec)
  " get all text from file before running the exec command
  let s:buff = join(getline(1, '$'), "\n")
  exe "%!" a:exec
  " if the executable exits with a non-zero
  " delete everything and paste the old text
  if v:shell_error != 0
    1,$d|pu! = s:buff
  en
endf
au BufWritePre * sil! cal FormatIt()
