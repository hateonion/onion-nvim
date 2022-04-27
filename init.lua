vim.g.coq_settings = {
  auto_start = true,
  clients = {
    tmux = {
      enabled = false
    },
  }
}

require('plugins')
require('options')
require('config.nvim-tree')
require('config.telecom')

--Set statusbar
require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = 'onedark',
    component_separators = '|',
    section_separators = '',
  },
}

--Enable Comment.nvim
require('Comment').setup()

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Indent blankline
require('indent_blankline').setup {
  char = '|',
  show_trailing_blankline_indent = false,
}


-- Gitsigns
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' }, }, }

-- Telescope

--Add leader shortcuts

-- Treesitter configuration
-- Parsers must be installed manually via :TSInstall
require('nvim-treesitter.configs').setup {
  ensure_installed = { "typescript", "lua", "rust", "beancount", "css", "scss", "yaml", "javascript", "dockerfile" },
  highlight = {
    enable = true, -- false will disable the whole extension
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = 'gnn',
      node_incremental = 'grn',
      scope_incremental = 'grc',
      node_decremental = 'grm',
    },
  },
  indent = {
    enable = true,
  },
  autotag = {
    enable = true,
  },
  rainbow = {
    enable = true,
    -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = nil, -- Do not enable for files with more than n lines, int
    -- colors = {}, -- table of hex strings
    -- termcolors = {} -- table of colour name strings
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
  },
}

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- LSP settings
local lspconfig = require 'lspconfig'
local common_on_attach = function(_, bufnr)
  local opts = { buffer = bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
  vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
  vim.keymap.set('n', '<leader>wl', function()
    vim.inspect(vim.lsp.buf.list_workspace_folders())
  end, opts)
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', '<leader>so', require('telescope.builtin').lsp_document_symbols, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '[d]', vim.diagnostic.goto_prev, opts)
  vim.api.nvim_create_user_command("Format", vim.lsp.buf.formatting, {})
end


-- Enable the following language servers
--
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')


local util = require 'vim.lsp.util'
local formatting_callback = function(client, bufnr)
  vim.keymap.set('n', '<leader>f', function()
    local params = util.make_formatting_params({})
    client.request('textDocument/formatting', params, nil, bufnr)
  end, { buffer = bufnr })
end

local lsp_installer = require('nvim-lsp-installer')
lsp_installer.on_server_ready(function(server)
  local opts = {
    on_attach = common_on_attach
  }
  if server.name == "tsserver" then opts = {
      on_attach = common_on_attach
    }
  end
  if server.name == "sumneko_lua" then opts = {
      on_attach = common_on_attach,
      settings = {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            version = 'LuaJIT',
            -- Setup your lua path
            path = runtime_path,
          },
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = { 'vim' },
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = vim.api.nvim_get_runtime_file('', true),
          },
          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = {
            enable = false,
          },
        },
      },
    }
  end

  server:setup(coq.lsp_ensure_capabilities(opts))
end
)
vim.keymap.set('n', '<leader>gg', ':Neogit <CR>')
vim.keymap.set('n', '<leader>rp', ':source lua/plugins.lua')
vim.keymap.set('n', '<leader>pi', ':PackerInstall <CR>')

require 'colorizer'.setup()
require 'colorizer'.setup({
  'css';
  'javascript';
  'typescript';
  'json';
  'rust';
  html = { mode = 'background' };
}, { mode = 'foreground' })

require('nvim-autopairs').setup {}

vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]

vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true

require("coq_3p") {
  { src = "copilot", short_name = "COP", accept_key = "<c-f>" },
}

require("null-ls").setup({
  sources = {
    require("null-ls").builtins.diagnostics.eslint,
    require("null-ls").builtins.formatting.prettier,
    require("null-ls").builtins.code_actions.eslint,
    require("null-ls").builtins.completion.spell,
  },
})

vim.keymap.set('n', '==', ':Format <CR>')
vim.keymap.set('n', '<leader>ff', ':Format <CR>')

vim.o.guifont = "JetbrainsMono Nerd Font:h18"
