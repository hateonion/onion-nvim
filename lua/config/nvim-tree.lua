require('nvim-tree').setup {
  update_cwd = true,
  update_focused_file = {
    enable = true,
    update_cwd = true,
  }
}

vim.keymap.set('n', '<leader>n', ':NvimTreeToggle<CR>')
vim.keymap.set('n', '<leader>ft', ':NvimTreeToggle<CR>')
