local M = {}

-- Set the global <leader> key.
-- This must be set BEFORE any plugins are loaded to take effect.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- The path where plugins are installed, following Neovim's standard.
local install_path = vim.fn.stdpath("config") .. "/pack/plugins/start/"

-- ## Your Plugin List ##
-- This structure allows co-locating configuration with the plugin definition.
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

    -- nvim-lspconfig: The core plugin for LSP configurations.
    -- nvim-lspconfig: The core plugin for LSP configurations.
    {"neovim/nvim-lspconfig", config = function()
        -- Use LspAttach autocommand for keybindings (Modern way)
        vim.api.nvim_create_autocmd('LspAttach', {
            callback = function(args)
                local bufnr = args.buf
                local opts = { noremap = true, silent = true, buffer = bufnr }

                -- Keybindings for LSP features
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
                vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
            end,
        })

        -- Configure clangd using the modern vim.lsp.config API (Neovim 0.11+)
        vim.lsp.config('clangd', {
            cmd = {
                "clangd",
                "--background-index",
                "--clang-tidy",
                "--header-insertion=iwyu",
                "--completion-style=detailed",
                "--function-arg-placeholders",
                "--fallback-style=llvm",
            },
            init_options = {
                usePlaceholders = true,
                completeUnimported = true,
                clangdFileStatus = true,
            },
        })
        vim.lsp.enable('clangd')

        -- Configure global diagnostic styling
        vim.diagnostic.config({
            virtual_text = true,
            signs = true,
            underline = true,
            update_in_insert = false,
            severity_sort = true,
            float = { source = "always", border = "rounded" },
        })

        -- Automatic hover on cursor hold
        vim.api.nvim_create_autocmd("CursorHold", {
            callback = function()
                if #vim.lsp.get_clients({ bufnr = 0 }) == 0 then return end
                for _, win in ipairs(vim.api.nvim_list_wins()) do
                    if vim.api.nvim_win_get_config(win).relative ~= "" then return end
                end
                vim.lsp.buf.hover({ focusable = false })
            end,
        })

        -- Modern way to add rounded borders to hover windows
        local orig_hover = vim.lsp.handlers["textDocument/hover"]
        vim.lsp.handlers["textDocument/hover"] = function(err, result, ctx, config)
            config = config or {}
            config.border = "rounded"
            return orig_hover(err, result, ctx, config)
        end
    end},

    -- Polyglot for Syntax Highlighting
    { "sheerun/vim-polyglot" },

    -- Color Preview
    { "catgoose/nvim-colorizer.lua", config = function()
        require("colorizer").setup({
            filetypes = { "css", "stylus", "javascript", "html", "scss", "typescript" },
            user_default_options = {
                css = true, -- Enable all CSS color formats
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

--- Synchronously installs or updates a single plugin using git.
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

        -- We must use a synchronous (blocking) system call here.
        -- This ensures the plugin is fully cloned before we proceed.
        local result = vim.system({ "git", "clone", "--depth", "1", clone_url, target_path }, { cwd = vim.fn.stdpath("config") }):wait()

        if result.code == 0 then
            vim.notify(repo_name .. " installed successfully!")
        else
            vim.notify("Failed to install " .. repo_name .. ": " .. (result.stderr or result.stdout), vim.log.levels.ERROR)
        end
    -- If it is installed and we should update, pull changes.
    elseif should_update then
        vim.notify("Updating " .. repo_name .. "...")

        -- Use a synchronous (blocking) pull to ensure updates are finished.
        local result = vim.system({ "git", "-C", target_path, "pull" }, { cwd = vim.fn.stdpath("config") }):wait()

        if result.code == 0 then
            -- Don't show a success message if the repo was already up to date.
            if result.stdout:match("Already up to date") then
                vim.notify(repo_name .. " is already up to date.", vim.log.levels.INFO)
            else
                vim.notify(repo_name .. " updated!")
            end
        else
            vim.notify("Failed to update " .. repo_name .. ": " .. (result.stderr or result.stdout), vim.log.levels.ERROR)
        end
    end
end

--- Removes any plugins found in the install directory that are not in the list.
local function remove_unused_plugins()
    local plugin_set = {}
    for _, plugin_spec in ipairs(M.plugins) do
        plugin_set[get_repo_name(plugin_spec[1])] = true
    end

    local ok, files = pcall(vim.fn.readdir, install_path)
    if not ok then
        vim.notify("Could not scan plugin directory: " .. install_path, vim.log.levels.ERROR)
        return
    end

    for _, name in ipairs(files) do
        if not plugin_set[name] then
            vim.notify("Removing unused plugin: " .. name)
            local path_to_remove = install_path .. name

            -- Use system 'rm -rf' for robust directory removal, as vim.fn.delete can be flaky
            local result = vim.system({ "rm", "-rf", path_to_remove }, { cwd = vim.fn.stdpath("config") }):wait()
            if result.code ~= 0 then
                vim.notify("Failed to remove directory: " .. path_to_remove, vim.log.levels.ERROR)
            end
        end
    end
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

    -- Synchronously install any missing plugins
    for _, plugin_spec in ipairs(M.plugins) do
        sync_plugin(plugin_spec, false) -- `false` means don't update on startup
    end

    -- Load all plugins into the runtime
    vim.cmd("packloadall!")

    -- Run the configuration function for each plugin
    for _, plugin_spec in ipairs(M.plugins) do
        if plugin_spec.config then
            -- pcall (protected call) safely executes the config function
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

-- Creates the :RefreshPlugins user command
vim.api.nvim_create_user_command("RefreshPlugins", M.refresh, {})

return M
