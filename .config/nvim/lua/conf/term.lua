-- ## Autocommands for the Terminal ##
--------------------------------------------------------------------------------
-- We create an augroup to keep terminal settings organized.
local term_group = vim.api.nvim_create_augroup("TerminalConfig", { clear = true })

-- When a terminal window opens, apply the following settings.
vim.api.nvim_create_autocmd("TermOpen", {
  group = term_group,
  pattern = "*",
  desc = "Settings for new terminal windows.",
  callback = function()
    -- ## Automatically start in insert mode ##
    vim.cmd("startinsert")

    -- ## Window-local settings ##
    -- Change the statusline to indicate it's a terminal.
    vim.wo.statusline = "Term[%{b:term_title}]"
    -- Disable auto-resize.
    vim.wo.winfixwidth = false
    vim.wo.winfixheight = false
    -- Disable spell checking (this is a window-local option).
    vim.wo.spell = false
  end,
})

-- ## Keymaps for the Terminal ##
-- Create a new terminal in a horizontal split at the bottom.
vim.keymap.set("n", "<C-A-t>", ":bo 10sp | term<CR>", {
  noremap = true,
  silent = true,
  desc = "Open terminal in a new split",
})

-- Use <Esc> to exit terminal mode.
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", {
  noremap = true,
  silent = true,
  desc = "Exit terminal mode",
})

