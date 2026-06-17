-- ## General Settings for netrw ##
--------------------------------------------------------------------------------
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_keepdir = 0
vim.g.netrw_hide = 1
vim.g.netrw_list_hide = [[^\.\.\?/$]]
vim.g.netrw_sort_sequence = [[[\/]$,*]]
vim.g.netrw_browse_split = 0
vim.g.netrw_fastbrowse = 0

-- ## Keymaps ##
--------------------------------------------------------------------------------
-- Keymap to open netrw
vim.keymap.set({ "n", "i" }, "<C-\\>", "<Cmd>Explore<CR>", {
  noremap = true,
  silent = true,
  desc = "Open netrw file explorer",
})
