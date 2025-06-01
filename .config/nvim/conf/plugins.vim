let s:list = [
  \"dense-analysis/ale",
  \"sheerun/vim-polyglot",
  \"github/copilot.vim",
  \"mattn/emmet-vim",
  \"terryma/vim-multiple-cursors",
  \"airblade/vim-gitgutter",
  \"arcticicestudio/nord-vim"
\]
let s:hasgit = executable("git")
let s:loc = "~/.config/nvim/pack/plugin/start/"
" check if the plugin is installed 
" but not in the list and remove it
fu s:removed()
  if empty(s:loc)
    let s:plist = split(execute("!ls -1 " . s:loc ), "\n")[1:]
    for s:l in s:plist
      if match(s:list, s:l) == -1
        ec "Plugin Not Found " . s:l
        exe "!rm -rf " . s:loc . s:l
      en
    endfo
  en
endf
cal s:removed()
" check if the plugin is installed
fu s:init(r)
  if s:hasgit
    for s:plugin in s:list
      " init if the plugin is already installed
      " if it is not installed, clone the plugin
      if empty(glob(s:loc . split(s:plugin, "/")[1]))
        " plugin not installed, clone it
        exe "!git clone https://github.com/" . s:plugin . " ". s:loc . split(s:plugin, "/")[1]
      elseif a:r == 1
        cal s:removed()
        " plugin already installed, init if it is up to date
        exe "!git -C ". s:loc . split(s:plugin, "/")[1] . " pull"
      en
    endfo
  el
    ec "git not found, please install git"
  en
endf
" check if the plugins is already installed
cal s:init(0)
" remove the plugin and reinstall it
fu Refresh()
  cal s:init(1)
  packl!
  sil! so ~/.config/nvim/init.vim
endf
" set nord theme
colo nord
