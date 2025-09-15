-- ## Creating & Managing Splits (with Ctrl+Alt+Arrow) ##
--------------------------------------------------------------------------------
local opts = { noremap = true, silent = true }

-- Create a vertical split to the right
opts.desc = "Create vertical split (right)"
vim.keymap.set("n", "<C-A-Right>", ":vs<CR>", opts)

-- Create a horizontal split below
opts.desc = "Create horizontal split (below)"
vim.keymap.set("n", "<C-A-Down>", ":sp<CR>", opts)

-- Create a horizontal split above
opts.desc = "Create horizontal split (above)"
vim.keymap.set("n", "<C-A-Up>", ":aboveleft sp<CR>", opts)

-- Create a vertical split to the left
opts.desc = "Create vertical split (left)"
vim.keymap.set("n", "<C-A-Left>", ":leftabove vs<CR>", opts)


-- ## Navigating Between Windows (with Alt+Arrow) ##
--------------------------------------------------------------------------------
-- Use <Cmd> instead of the colon (:) to execute the command
-- without moving the cursor to the command line.

opts.desc = "Move to the window above"
vim.keymap.set("n", "<A-Up>", "<Cmd>wincmd k<CR>", opts)

opts.desc = "Move to the window below"
vim.keymap.set("n", "<A-Down>", "<Cmd>wincmd j<CR>", opts)

opts.desc = "Move to the window on the left"
vim.keymap.set("n", "<A-Left>", "<Cmd>wincmd h<CR>", opts)

opts.desc = "Move to the window on the right"
vim.keymap.set("n", "<A-Right>", "<Cmd>wincmd l<CR>", opts)

