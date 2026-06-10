-- ## General Settings for netrw ##
--------------------------------------------------------------------------------
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 15
vim.g.netrw_wiw = 15
vim.g.netrw_keepdir = 0
vim.g.netrw_hide = 0
vim.g.netrw_browse_split = 0
vim.g.netrw_fastbrowse = 0

-- ## Core Functions ##
--------------------------------------------------------------------------------

-- Function to run when netrw is opened
local function on_netrw()
  vim.cmd("norm! <CR>")
  -- Buffer-local keymaps for mouse interaction
  local opts = { buffer = true, noremap = true, silent = false }
  -- Map the double-click to our new, dedicated function
  vim.keymap.set("n", "<2-LeftMouse>", "", opts)
  vim.keymap.set("n", "<MiddleMouse>", "<C-l>", opts)
  vim.keymap.set("n", "<LeftDrag>", "<CR>", opts)

end

-- ## Autocommands ##
--------------------------------------------------------------------------------
local netrw_group = vim.api.nvim_create_augroup("NetrwConfig", { clear = true })

-- Apply settings when netrw filetype is detected
vim.api.nvim_create_autocmd("FileType", {
  group = netrw_group,
  pattern = "netrw",
  callback = on_netrw,
})

-- ## Keymaps ##
--------------------------------------------------------------------------------
-- Keymap to open netrw
vim.keymap.set({ "n", "i" }, "<C-\\>", "<Cmd>Explore<CR>", {
  noremap = true,
  silent = true,
  desc = "Open netrw file explorer",
})
