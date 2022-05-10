-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packerrstart/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', { command = 'source <afile> | PackerCompile', group = packer_group, pattern = 'init.lua' })

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim' -- Package manager
  use { 'TimUntersberger/neogit', requires = 'nvim-lua/plenary.nvim' }
  use 'tpope/vim-fugitive' -- Git commands in nvim
  -- use 'tpope/vim-rhubarb' -- Fugitive-companion to interact with github
  use 'numToStr/Comment.nvim' -- "gc" to comment visual regions/lines
  use 'bluz71/vim-nightfly-guicolors'
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icon
    }
  }
  -- use 'ludovicchabant/vim-gutentags' -- Automatic tags management
  -- UI to select things (files, grep results, open buffers...)
  use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-live-grep-raw.nvim' } }
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  -- use {'kevinhwang91/nvim-bqf', ft = 'qf'}

  -- optional
  use {'junegunn/fzf', run = function()
    vim.fn['fzf#install']()
  end
  }
  use { 'nvim-telescope/telescope-project.nvim' }
  use 'kosayoda/nvim-lightbulb'
  -- colors
  use 'norcalli/nvim-colorizer.lua'
  use 'mjlbach/onedark.nvim' -- Theme inspired by Atom

  use 'marko-cerovac/material.nvim'

  use 'nvim-lualine/lualine.nvim' -- Fancier statusline
  use 'ms-jpq/coq_nvim'
  use 'ms-jpq/coq.thirdparty'
  use 'f-person/git-blame.nvim'
  use 'rmagatti/goto-preview'
  use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  }

  use 'gpanders/editorconfig.nvim'
  use {
    'phaazon/hop.nvim',
    branch = 'v1', -- optional but strongly recommended
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require 'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
    end
  }

  use 'tpope/vim-surround'
  use 'tpope/vim-abolish'
  use 'kdheepak/lazygit.nvim'

 -- Add indentation guides even on blank lines
  use 'lukas-reineke/indent-blankline.nvim'
  -- Add git related info in the signs columns and popups
  use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }
  -- Highlight, edit, and navigate code using a fast incremental parsing library
  use 'nvim-treesitter/nvim-treesitter'
  -- Additional textobjects for treesitter
  use 'nvim-treesitter/nvim-treesitter-textobjects'
  use 'p00f/nvim-ts-rainbow'
  use 'windwp/nvim-ts-autotag'
  use 'windwp/nvim-autopairs'

  use 'neovim/nvim-lspconfig' -- Collection of configurations for built-in LSP client
  use 'williamboman/nvim-lsp-installer'
  -- use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
  -- use 'hrsh7th/cmp-nvim-lsp'
  -- use 'saadparwaiz1/cmp_luasnip'
  use 'L3MON4D3/LuaSnip' -- Snippets plugin
  use 'github/copilot.vim'
  use 'jose-elias-alvarez/null-ls.nvim'
  use { "tami5/sqlite.lua" }
  use {
    "nvim-telescope/telescope-frecency.nvim",
    requires = { "tami5/sqlite.lua" }
  }
  use 'Darazaki/indent-o-matic'
  use 'simrat39/rust-tools.nvim'
  use 'nvim-pack/nvim-spectre'


  use {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  }

end)
