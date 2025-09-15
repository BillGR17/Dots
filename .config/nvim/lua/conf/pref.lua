-- ## General GUI, Performance & Mouse Settings ##
--------------------------------------------------------------------------------
vim.o.mouse = "a"           -- Enable mouse in all modes.
vim.o.lazyredraw = true     -- Better performance with lazy screen refresh.
vim.o.updatetime = 100      -- Time (ms) to trigger events like CursorHold.
vim.o.synmaxcol = 300       -- Column limit for syntax highlighting for better performance.
vim.o.title = true          -- Show file name in the window title.
vim.o.undofile = true       -- Enable persistent undo history.

-- ## Autocompletion Menu ##
--------------------------------------------------------------------------------
vim.o.pumheight = 20
vim.o.completeopt = "menuone,preview"

-- ## Editor Behavior ##
--------------------------------------------------------------------------------
vim.o.showmatch = true      -- Instantly highlight matching brackets.
vim.o.cursorcolumn = true   -- Highlight the current column.
vim.o.cursorline = true     -- Highlight the current line.

-- ## Indentation Settings (Tabs & Spaces) ##
--------------------------------------------------------------------------------
vim.o.tabstop = 2           -- A tab corresponds to 2 spaces.
vim.o.shiftwidth = 2        -- Indentation width for >> and << commands.
vim.o.softtabstop = 2       -- Number of spaces inserted with the Tab key.
vim.o.expandtab = true      -- Convert tabs to spaces.
vim.o.smartindent = true    -- Smart auto-indentation.

-- ## Visual Aids (Whitespace, Numbering, etc.) ##
--------------------------------------------------------------------------------
vim.o.wrap = false          -- Disable line wrapping.
vim.o.number = true         -- Show line numbers.
vim.o.list = true           -- Show non-printable characters.
vim.o.listchars = "eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:."

-- ## Encoding Settings ##
--------------------------------------------------------------------------------
vim.o.fileencoding = "utf-8"

-- ## Theme Settings ##
--------------------------------------------------------------------------------
vim.o.termguicolors = true  -- Enable 24-bit "true" colors.
vim.o.background = "dark"   -- Set a dark background.

-- ## Autocommand for Auto-Saving ##
--------------------------------------------------------------------------------
-- When focus is lost from a buffer, save everything.
local autosave_group = vim.api.nvim_create_augroup("AutoSaveOnLeave", { clear = true })
vim.api.nvim_create_autocmd("BufLeave", {
  group = autosave_group,
  pattern = "*",
  callback = function()
    -- Use pcall to ignore any errors (equivalent to "sil!")
    pcall(vim.cmd, "wa")
  end,
  desc = "Automatically save all files when leaving a buffer",
})

