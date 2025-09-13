let s:list = [
  \"dense-analysis/ale",
  \"nvim-treesitter/nvim-treesitter",
  \"Exafunction/windsurf.vim",
  \"chrisbra/Colorizer",
  \"mattn/emmet-vim",
  \"terryma/vim-multiple-cursors",
  \"airblade/vim-gitgutter",
  \"folke/tokyonight.nvim"
\]
let s:hasgit = executable("git")
let s:loc = "~/.config/nvim/pack/plugin/start/"
" check if the plugin is installed
" but not in the list and remove it
fu s:removed()
  if !empty(s:loc)
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
au BufEnter * sil! :ColorHighlight
" set theme
colo tokyonight-storm

let g:gitgutter_realtime=1
let g:gitgutter_eager=0
let g:ale_linters = {'c': ['clang'],'javascript': ['eslint'], 'cs': ['dotnet-build']}
let g:ale_fixers = { 'cs': ['dotnet-format'] }
let g:ale_pattern_options = {'.*\.hbs$': {'ale_enabled': 0},'.*\.handlebars$': {'ale_enabled': 0}}
let g:ale_open_list=0

lua << EOF
require('nvim-treesitter.configs').setup {
ensure_installed = {
  "c", "cpp", "c_sharp", "lua", "vim", "vimdoc", "query",
  "markdown", "markdown_inline", "javascript", "typescript",
  "razor", "html", "css", "json", "python", "rust", "bash", "ini",
  "yaml",  "toml",  "jsonc",  "xml",  "sql",  "dockerfile","cmake",  "make",
  "regex",  "go"
  },
  sync_install = false,

  auto_install = true,

  ignore_install = { "javascript" },

  highlight = {
    enable = true,

    disable = function(lang, buf)
        local max_filesize = 100 * 1024
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,
    additional_vim_regex_highlighting = false,
  },
}
EOF
au BufNewFile,BufRead *.razor se filetype=razor
let g:user_emmet_expandabbr_key='<C-e>'
