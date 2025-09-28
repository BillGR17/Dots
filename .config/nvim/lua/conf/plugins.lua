local M = {}

-- The path where plugins are installed, following Neovim's standard.
local install_path = vim.fn.stdpath("config") .. "/pack/plugins/start/"

-- ## Your Plugin List ##
-- This new structure allows co-locating configuration with the plugin definition.
-- 'globals': Sets vim.g variables BEFORE the plugin loads.
-- 'config': A function that runs AFTER the plugin loads.
M.plugins = {
    -- Colorscheme
    { "folke/tokyonight.nvim", config = function()
        -- Set the colorscheme after the plugin is loaded
        vim.cmd("colorscheme tokyonight-storm")
    end },

    -- Git
    { "airblade/vim-gitgutter", globals = {
        -- These settings must be defined before the plugin loads
        gitgutter_realtime = 1,
        gitgutter_eager = 0,
    } },

    -- Linting and Fixing
    { "dense-analysis/ale", globals = {
        ale_linters = { c = { "clang" }, javascript = { "eslint" }, cs = { "dotnet-build" } },
        ale_fixers = { cs = { "dotnet-format" } },
        ale_pattern_options = {
            [".*\\.handlebars$"] = { ale_enabled = 0 }
          },
        ale_open_list = 1,
    }, config = function()
        vim.keymap.set("n", "gr", "<Cmd>ALEFindReferences<CR>", {
            noremap = true,
            silent = true,
            desc = "ALE: Show References",
        })
    end },

    -- Treesitter for Syntax Highlighting
    { "nvim-treesitter/nvim-treesitter", config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = {
                "c", "cpp", "c_sharp", "lua", "vim", "vimdoc", "query",
                "markdown", "markdown_inline", "javascript", "typescript",
                "razor", "html", "css", "json", "python", "rust", "bash", "ini",
                "yaml", "toml", "jsonc", "xml", "sql", "dockerfile", "cmake", "make",
                "regex", "go",
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
    end },

    -- Color Preview
    { "catgoose/nvim-colorizer.lua", config = function()
        require("colorizer").setup({
            filetypes = { "css", "stylus", "javascript", "html", "scss", "typescript" },
            user_default_options = {
                css = true,      -- Enable all CSS color formats
                mode = "background", -- Display mode
            },
        })
    end },

    -- Other utilities
    { "Exafunction/windsurf.vim" },
    { "terryma/vim-multiple-cursors" },
    { "mattn/emmet-vim", globals = {
        user_emmet_expandabbr_key = "<C-e>",
    } },
}

--- Helper function to get the repository name from a 'owner/repo' string.
-- @param repo_url string: The plugin spec, e.g., "folke/tokyonight.nvim"
-- @return string: The repository name, e.g., "tokyonight.nvim"
local function get_repo_name(repo_url)
    return repo_url:match("/([^/]+)$")
end

--- Asynchronously syncs plugins using git.
-- @param plugin_spec table: The plugin definition from the M.plugins list.
-- @param should_update boolean: If true, pulls updates for existing plugins.
local function sync_plugin(plugin_spec, should_update)
    local repo_url = plugin_spec[1]
    local repo_name = get_repo_name(repo_url)
    local target_path = install_path .. repo_name

    -- If plugin isn't installed, clone it.
    if not vim.loop.fs_stat(target_path) then
        vim.notify("Installing " .. repo_name .. "...")
        local clone_url = "https://github.com/" .. repo_url .. ".git"
        vim.system({ "git", "clone", "--depth", "1", clone_url, target_path }, {}, function(result)
            if result.code == 0 then
                vim.notify(repo_name .. " installed successfully!")
            else
                vim.notify("Failed to install " .. repo_name, vim.log.levels.ERROR)
            end
        end)
    -- If it is installed and we should update, pull changes.
    elseif should_update then
        vim.notify("Updating " .. repo_name .. "...")
        vim.system({ "git", "-C", target_path, "pull" }, {}, function(result)
            if result.code == 0 then
                vim.notify(repo_name .. " updated!")
            else
                vim.notify("Failed to update " .. repo_name, vim.log.levels.ERROR)
            end
        end)
    end
end

--- Removes any plugins found in the install directory that are not in the list.
local function remove_unused_plugins()
    local plugin_set = {}
    for _, plugin_spec in ipairs(M.plugins) do
        plugin_set[get_repo_name(plugin_spec[1])] = true
    end

    vim.loop.fs_scandir(install_path, function(_, iter)
        if not iter then return end
        for name, type in iter do
            if type == "directory" and not plugin_set[name] then
                vim.notify("Removing unused plugin: " .. name)
                vim.fn.delete(install_path .. name, "rf")
            end
        end
    end)
end

--- The main setup function, called from init.lua.
function M.setup()
    -- Ensure the plugin directory exists
    vim.fn.mkdir(install_path, "p")

    -- Set global variables BEFORE plugins are loaded
    for _, plugin_spec in ipairs(M.plugins) do
        if plugin_spec.globals then
            for key, value in pairs(plugin_spec.globals) do
                vim.g[key] = value
            end
        end
    end

    -- Asynchronously install any missing plugins
    for _, plugin_spec in ipairs(M.plugins) do
        sync_plugin(plugin_spec, false) -- `false` means don't update on startup
    end

    -- Load all plugins into the runtime
    vim.cmd("packloadall!")

    -- Run the configuration function for each plugin
    for _, plugin_spec in ipairs(M.plugins) do
        if plugin_spec.config then
            local ok, err = pcall(plugin_spec.config)
            if not ok then
                vim.notify("Error configuring " .. plugin_spec[1] .. ":\n" .. err, vim.log.levels.ERROR)
            end
        end
    end

    -- Autocommand for razor files
    vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
        pattern = "*.razor",
        command = "set filetype=razor",
    })
end

--- User command to force-sync all plugins.
function M.refresh()
    vim.notify("Refreshing plugins in the background...")
    remove_unused_plugins()
    for _, plugin_spec in ipairs(M.plugins) do
        sync_plugin(plugin_spec, true) -- `true` means pull updates
    end
    vim.cmd("packloadall!")
    vim.notify("Plugin refresh started. See notifications for progress.")
end

vim.api.nvim_create_user_command("RefreshPlugins", M.refresh, {})

return M
