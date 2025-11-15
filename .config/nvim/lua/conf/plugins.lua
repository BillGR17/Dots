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

    -- LSP & Linting Infrastructure
    -- mason.nvim: Manages LSP servers, linters, and formatters.
    { "williamboman/mason.nvim", config = function()
        -- Initialize mason
        require("mason").setup()
    end },

    -- mason-lspconfig: Bridges mason with nvim-lspconfig.
    { "williamboman/mason-lspconfig.nvim", config = function()
        -- This function runs when an LSP server attaches to a buffer.
        -- It's used to set buffer-local keymaps and options.
        local on_attach = function(client, bufnr)
            -- Enable completion
            vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

            -- Set keymaps
            local opts = { buffer = bufnr, noremap = true, silent = true }
            local keymap = vim.keymap.set

            -- Show documentation on hover
            keymap("n", "K", vim.lsp.buf.hover, opts)
            -- Go to definition
            keymap("n", "gd", vim.lsp.buf.definition, opts)
            -- Go to type definition
            keymap("n", "gD", vim.lsp.buf.type_definition, opts)
            -- Go to implementation
            keymap("n", "gi", vim.lsp.buf.implementation, opts)
            -- Go to references
            keymap("n", "gr", vim.lsp.buf.references, opts)
            -- Rename symbol
            keymap("n", "<F2>", vim.lsp.buf.rename, opts)
            -- Show code actions (like "fix this" or "import module")
            keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts)
            keymap("v", "<leader>ca", vim.lsp.buf.code_action, opts)
            -- Show diagnostic information (errors/warnings) in a floating window
            keymap("n", "<leader>e", vim.diagnostic.open_float, opts)
            -- Jump to next/previous diagnostic
            keymap("n", "[d", vim.diagnostic.goto_prev, opts)
            keymap("n", "]d", vim.diagnostic.goto_next, opts)
        end

        -- Configure mason-lspconfig to bridge with lspconfig
        require("mason-lspconfig").setup({
            -- List of LSP servers to automatically install via Mason
            ensure_installed = {
                "lua_ls", -- For Neovim's own Lua environment
                "clangd", -- For C/C++
                "csharp_ls", -- For C#
                "gopls", -- For Go
                "eslint", -- For JavaScript/TypeScript
            },

            -- This 'handlers' block defines how to set up each server.
            -- It replaces the need for a separate 'setup_handlers' call.
            handlers = {
                -- This default handler is called for *each* server in 'ensure_installed'.
                function(server_name)
                    require("lspconfig")[server_name].setup({
                        on_attach = on_attach,
                    })
                end,
            },
        })
    end },

    -- nvim-lspconfig: The core plugin for LSP configurations.
    -- We only load it. Its setup is managed entirely by mason-lspconfig.
    -- However, we use its 'config' block to set global diagnostic styling.
    {"neovim/nvim-lspconfig", config = function()
        -- Configure how diagnostics (errors/warnings) are displayed
        vim.diagnostic.config({
            virtual_text = true, -- Show error message at the end of the line
            signs = true,        -- Show 'E'/'W' in the sign column
            underline = true,    -- Underline the problematic code
            update_in_insert = false, -- Don't update diagnostics while typing
            severity_sort = true,  -- Sort diagnostics by severity
            float = {
                source = "always", -- Show which linter found the issue (e.g., "clangd")
            },
        })

        -- We removed the automatic 'CursorHold' autocommand
        -- as it can be annoying. Use '<leader>e' to show errors manually.
    end},

    -- Treesitter for Syntax Highlighting
    { "nvim-treesitter/nvim-treesitter", config = function()
        require("nvim-treesitter.configs").setup({
            -- A list of parser to install
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
                -- Disable highlighting for very large files to prevent lag
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
        local result = vim.system({ "git", "clone", "--depth", "1", clone_url, target_path }):wait()

        if result.code == 0 then
            vim.notify(repo_name .. " installed successfully!")
        else
            vim.notify("Failed to install " .. repo_name .. ": " .. (result.stderr or result.stdout), vim.log.levels.ERROR)
        end
    -- If it is installed and we should update, pull changes.
    elseif should_update then
        vim.notify("Updating " .. repo_name .. "...")

        -- Use a synchronous (blocking) pull to ensure updates are finished.
        local result = vim.system({ "git", "-C", target_path, "pull" }):wait()

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

    -- Use a synchronous scanner to prevent race conditions during :RefreshPlugins
    local iter = vim.loop.fs_scandir_sync(install_path)
    if not iter then
        vim.notify("Could not scan plugin directory: " .. install_path, vim.log.levels.ERROR)
        return
    end

    while true do
        local name, type = iter()
        if not name then
            break -- No more files
        end

        if type == "directory" and not plugin_set[name] then
            vim.notify("Removing unused plugin: " .. name)
            local path_to_remove = install_path .. name

            -- Use system 'rm -rf' for robust directory removal, as vim.fn.delete can be flaky
            local result = vim.system({ "rm", "-rf", path_to_remove }):wait()
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
