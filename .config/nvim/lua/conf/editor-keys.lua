-- Define a table with common options to avoid repetition
local opts = { noremap = true, silent = true }

--------------------------------------------------------------------------------
-- ## Quick Line Movement ##
--------------------------------------------------------------------------------
vim.keymap.set("n", "<C-Up>", ":m-2<CR>", opts)
vim.keymap.set("n", "<C-Down>", ":m+<CR>", opts)
vim.keymap.set("i", "<C-Up>", "<Esc>:m .-2<CR>==gi", opts)
vim.keymap.set("i", "<C-Down>", "<Esc>:m .+1<CR>==gi", opts)
vim.keymap.set("v", "<C-Up>", ":m '<-2<CR>gv=gv", opts)
vim.keymap.set("v", "<C-Down>", ":m '>+1<CR>gv=gv", opts)

--------------------------------------------------------------------------------
-- ## Automatic Bracket Closing ##
-- 💡 For a more robust solution, consider a plugin like nvim-autopairs.
--------------------------------------------------------------------------------
vim.keymap.set("i", "(", "()<Left>", { noremap = true })
vim.keymap.set("i", "[", "[]<Left>", { noremap = true })
vim.keymap.set("i", "{", "{}<Left>", { noremap = true })
vim.keymap.set("i", "<", "<><Left>", { noremap = true })

--------------------------------------------------------------------------------
-- ## Tab for Indentation ##
--------------------------------------------------------------------------------
vim.keymap.set("n", "<Tab>", ">>", opts)
vim.keymap.set("n", "<S-Tab>", "<<", opts)
vim.keymap.set("i", "<Tab>", ">>", opts)
vim.keymap.set("i", "<S-Tab>", "<C-d>", opts)

-- In Visual mode (selection)
vim.keymap.set("v", "<Tab>", ":s/^/  /g<CR>:nohls<CR>gv", opts)
vim.keymap.set("v", "<S-Tab>", "<gv", opts)

--------------------------------------------------------------------------------
-- ## Miscellaneous Shortcuts ##
--------------------------------------------------------------------------------
-- Trim trailing whitespace
opts.desc = "Trim trailing whitespace"
vim.keymap.set("n", "<F2>", [[:%s/\s\+$//e<CR>]], opts)

-- Convert tabs to spaces
opts.desc = "Convert tabs to spaces"
vim.keymap.set("n", "<F3>", [[:%s/\t/  /ge<CR>]], opts)

-- Save file
opts.desc = "Save file"
vim.keymap.set("n", "<C-s>", ":w<CR>", opts)
vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>", opts)

-- Save without triggering autocommands
opts.desc = "Save file without autocommands"
vim.keymap.set("n", "<C-A-s>", ":noau w<CR>", opts)
vim.keymap.set("i", "<C-A-s>", "<Esc>:noau w<CR>", opts)

--------------------------------------------------------------------------------
-- ## Toggle Syntax Highlighting ##
--------------------------------------------------------------------------------
opts.desc = "Toggle Syntax Highlighting"
vim.keymap.set("n", "<F7>", function()
  if vim.fn.exists("g:syntax_on") == 1 then
    vim.cmd("syntax off")
  else
    vim.cmd("syntax on")
  end
end, opts)
