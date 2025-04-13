-- Set leader key (used in many custom keybindings)
vim.g.mapleader = " "

-- Enable line numbers
vim.opt.number = true
vim.opt.relativenumber = true
-- Enable mouse support
vim.opt.mouse = "a"
vim.opt.termguicolors = true


-- Basic key mappings (quicker save/quit)
vim.keymap.set("n", "<leader>w", ":w<CR>")  -- Save with space+w
vim.keymap.set("n", "<leader>q", ":q<CR>")  -- Quit with space+q

vim.keymap.set("n", "<leader>rn",":set relativenumber!<CR>", { noremap = true }) 


