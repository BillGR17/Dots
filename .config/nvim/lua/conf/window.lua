local opts = { noremap = true, silent = true }

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.keymap.set("n", "<C-A-Right>", "<Cmd>vsplit<CR>", opts)
vim.keymap.set("n", "<C-A-Down>", "<Cmd>split<CR>", opts)
vim.keymap.set("n", "<C-A-Up>", "<Cmd>aboveleft split<CR>", opts)
vim.keymap.set("n", "<C-A-Left>", "<Cmd>leftabove vsplit<CR>", opts)

vim.keymap.set("n", "<A-Up>", "<Cmd>wincmd k<CR>", opts)
vim.keymap.set("n", "<A-Down>", "<Cmd>wincmd j<CR>", opts)
vim.keymap.set("n", "<A-Left>", "<Cmd>wincmd h<CR>", opts)
vim.keymap.set("n", "<A-Right>", "<Cmd>wincmd l<CR>", opts)

