-- ## General Settings for netrw ##
--------------------------------------------------------------------------------
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 15
vim.g.netrw_wiw = 15
vim.g.netrw_keepdir = 0
vim.g.netrw_hide = 0
vim.g.netrw_browse_split = 4
vim.g.netrw_fastbrowse = 0

-- ## Core Functions ##
--------------------------------------------------------------------------------

-- Toggles the netrw window
function Toggle_netrw()
  pcall(vim.cmd, "Lex %:p:h | setl stl=%{strftime('%H:%M')} | wincmd p")
end

-- Closes all netrw windows
function Close_netrw()
  -- Get all window IDs
  for _, win_id in ipairs(vim.api.nvim_list_wins()) do
    -- Check the filetype of each window
    local bufnr = vim.api.nvim_win_get_buf(win_id)
    local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')

    -- If the filetype is netrw, close the window
    if filetype == 'netrw' then
      vim.api.nvim_win_close(win_id, false)  -- false = don't force close
    end
  end
end


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

-- Open netrw on startup
vim.api.nvim_create_autocmd("VimEnter", {
  group = netrw_group,
  callback = Toggle_netrw,
})

-- Close netrw on exit
vim.api.nvim_create_autocmd("VimLeavePre", {
  group = netrw_group,
  callback = Close_netrw,
})


-- Apply settings when netrw filetype is detected
vim.api.nvim_create_autocmd("FileType", {
  group = netrw_group,
  pattern = "netrw",
  callback = on_netrw,
})

-- ## Keymaps ##
--------------------------------------------------------------------------------
-- Keymap to toggle netrw
vim.keymap.set({ "n", "i" }, "<C-\\>", Toggle_netrw, {
  noremap = true,
  silent = true,
  desc = "Toggle netrw file explorer",
})
