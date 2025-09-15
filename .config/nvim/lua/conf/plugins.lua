-- lua/conf/plugins.lua

-- This file manages plugins manually using git, as an alternative to a plugin manager.

-- ## Settings that must be defined BEFORE loading plugins ##
--------------------------------------------------------------------------------
-- GitGutter
vim.g.gitgutter_realtime = 1
vim.g.gitgutter_eager = 0

-- ALE (Linting & Fixing)
vim.g.ale_linters = { c = { "clang" }, javascript = { "eslint" }, cs = { "dotnet-build" } }
vim.g.ale_fixers = { cs = { "dotnet-format" } }
vim.g.ale_pattern_options = {
  [".*\\.hbs$"] = { ale_enabled = 0 },
  [".*\\.handlebars$"] = { ale_enabled = 0 },
}
vim.g.ale_open_list = 1
vim.keymap.set("n", "gr", "<Cmd>ALEFindReferences<CR>", {
  noremap = true,
  silent = true,
  desc = "ALE: Show References"
})
-- Emmet
vim.g.user_emmet_expandabbr_key = "<C-e>"

--------------------------------------------------------------------------------
-- ## Manual Plugin Management Logic ##
--------------------------------------------------------------------------------
local fn = vim.fn
-- Plugins will be installed in ~/.config/nvim/pack/plugins/start/
local install_path = fn.stdpath("config") .. "/pack/plugins/start/"
local has_git = fn.executable("git") == 1

-- ## Your Plugin List ##
local plugins = {
  "dense-analysis/ale",
  "nvim-treesitter/nvim-treesitter",
  "Exafunction/windsurf.vim",
  "chrisbra/Colorizer",
  "mattn/emmet-vim",
  "terryma/vim-multiple-cursors",
  "airblade/vim-gitgutter",
  "folke/tokyonight.nvim",
}

-- Helper function to get repo name from a 'owner/repo' string
local function get_repo_name(repo_url)
  return repo_url:match("/([^/]+)$")
end

-- Removes any plugins found in the install directory that are not in the list
local function remove_unused_plugins()
  -- Create a set of plugin names for quick lookup
  local plugin_set = {}
  for _, plugin in ipairs(plugins) do
    plugin_set[get_repo_name(plugin)] = true
  end

  -- Scan the install directory for subdirectories
  local handle = vim.loop.fs_scandir(install_path)
  if not handle then return end

  while true do
    local name, type = vim.loop.fs_scandir_next(handle)
    if not name then break end

    if type == 'directory' and not plugin_set[name] then
      vim.notify("Removing unused plugin: " .. name)
      local dir_to_remove = install_path .. name
      fn.system({"rm", "-rf", dir_to_remove})
    end
  end
end

-- Installs missing plugins and optionally updates existing ones
local function sync_plugins(should_update)
  if not has_git then
    vim.notify("git not found. Please install git to manage plugins.", vim.log.levels.ERROR)
    return
  end

  for _, plugin in ipairs(plugins) do
    local repo_name = get_repo_name(plugin)
    local target_path = install_path .. repo_name

    -- Check if plugin directory exists
    if not vim.loop.fs_stat(target_path) then
      vim.notify("Installing " .. repo_name .. "...")
      local clone_url = "https://github.com/" .. plugin
      fn.system({"git", "clone", "--depth", "1", clone_url, target_path})
    elseif should_update then
      vim.notify("Updating " .. repo_name .. "...")
      fn.system({"git", "-C", target_path, "pull"})
    end
  end
end

-- ## User Command to Refresh Plugins ##
function RefreshPlugins()
  vim.notify("Refreshing plugins...")
  remove_unused_plugins()
  sync_plugins(true)
  vim.cmd("packloadall!")
  vim.notify("Plugins refreshed! Please restart Neovim if you encounter issues.", vim.log.levels.INFO)
end
vim.api.nvim_create_user_command("RefreshPlugins", RefreshPlugins, {})

-- ## Initial Sync on Startup ##
-- Ensures plugins are installed, but doesn't update them every time.
remove_unused_plugins()
sync_plugins(false)

--------------------------------------------------------------------------------
-- ## Plugin Configurations (to be run after sync) ##
--------------------------------------------------------------------------------

-- Set the colorscheme
vim.cmd("colorscheme tokyonight-storm")

-- Setup nvim-treesitter
-- We separate the pcall from the setup call to handle errors correctly.
local status_ok, treesitter_configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  vim.notify("Treesitter configs not found. Plugin might not be installed yet.", vim.log.levels.WARN)
else
  treesitter_configs.setup({
    ensure_installed = {
      "c", "cpp", "c_sharp", "lua", "vim", "vimdoc", "query",
      "markdown", "markdown_inline", "javascript", "typescript",
      "razor", "html", "css", "json", "python", "rust", "bash", "ini",
      "yaml",  "toml",  "jsonc",  "xml",  "sql",  "dockerfile","cmake",  "make",
      "regex",  "go"
    },
    sync_install = false,
    auto_install = true,
    highlight = {
      enable = true,
      disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
      end,
      additional_vim_regex_highlighting = false,
    },
  })
end

-- Setup Colorizer autocommand
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  command = "ColorHighlight",
  group = vim.api.nvim_create_augroup("Colorizer", { clear = true }),
})

-- Set filetype for razor files
vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
  pattern = "*.razor",
  command = "set filetype=razor",
})
