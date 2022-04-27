--Set highlight on search
vim.o.hlsearch = false

--Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true


--Enable mouse mode
vim.o.mouse = 'a'

--Enable break indent
vim.o.breakindent = true

--Save undo history
vim.opt.undofile = true

--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

--Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

--Set colorscheme
vim.o.termguicolors = true
vim.cmd [[colorscheme onedark]]

--Remap space as leader key
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('i', 'kj', '<ESC>')
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

vim.keymap.set('n', '<leader>fs', ':w <CR>')

vim.o.clipboard = 'unnamedplus'

--Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })


