require('plugins')
require('options')
require('config.nvim-tree')
require('config.telecom')

--Set statusbar
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'sonokai',
    component_separators = '|',
    section_separators = '',
  },
}

require('spectre').setup()

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
--
local parser_config = require 'nvim-treesitter.parsers'.get_parser_configs()
parser_config.gotmpl = {
  install_info = {
    url = "https://github.com/ngalaiko/tree-sitter-go-template",
    files = { "src/parser.c" }
  },
  filetype = "gotmpl",
  used_by = { "gohtmltmpl", "gotexttmpl", "gotmpl", "tpl", "tmpl" }
}

require('nvim-treesitter.configs').setup {
  ensure_installed = { "typescript", "lua", "rust", "beancount", "css", "scss", "yaml", "javascript", "dockerfile", "gotmpl", "tsx", "svelte" },
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
    disable = { "jsx", "cpp", "tsx" },
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

require('luasnip.loaders.from_vscode').lazy_load()

local cmp = require 'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      require 'luasnip'.lsp_expand(args.body)
    end
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    -- { name = 'vsnip' }, -- For vsnip users.
    { name = 'luasnip' }, -- For luasnip users.
    { name = 'copilot' }, -- For luasnip users.
    { name = 'path' },
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
  })
})

-- Set configuration for specific filetype.
-- cmp.setup.filetype('gitcommit', {
--   sources = cmp.config.sources({
--     { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
--   }, {
--     { name = 'buffer' },
--   })
-- })
--
-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
local lspconfig = require 'lspconfig'
local common_on_attach = function(client, bufnr)
  local opts = { buffer = bufnr }
  if client.name == "tsserver" or client.name == "rust_analyzer" then
    client.resolved_capabilities.document_formatting = false
  end
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

local servers = { 'rust_analyzer', 'pyright', 'tsserver', 'vimls', 'jsonls', 'yamlls', 'bashls', 'dockerls', 'gopls', 'denols', 'beancount', 'svelte', 'rescriptls' }
require('nvim-lsp-installer').setup({
  ensure_installed = servers
})

for _, lsp in ipairs(servers) do
  if lsp == "beancount" then
    local journal_file = os.getenv("MAIN_BEAN_FILE")
    lspconfig[lsp].setup {
      on_attach = common_on_attach,
      capabilities = capabilities,
      init_options = {
        journal_file = journal_file
      }
    }
  elseif lsp == "denols" then
    lspconfig[lsp].setup({
      on_attach = common_on_attach,
      capabilities = capabilities,
      root_dir = lspconfig.util.root_pattern("deno.json")
    })
  elseif lsp == "tsserver" then
    lspconfig[lsp].setup({
      on_attach = common_on_attach,
      capabilities = capabilities,
      root_dir = lspconfig.util.root_pattern("package.json")
    })
  else
    lspconfig[lsp].setup {
      on_attach = common_on_attach,
      capabilities = capabilities
    }
  end
end

require('rust-tools').setup({
  server = {
    on_attach = common_on_attach,
    capabilities = capabilities
  }
})

lspconfig.sumneko_lua.setup({
  on_attach = common_on_attach,
  capabilities = capabilities,
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
})

vim.keymap.set('n', '<leader>gg', ':LazyGit <CR>')
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

require('goto-preview').setup { default_mappings = true }

local null_ls = require('null-ls')
null_ls.setup({
  sources = {
    null_ls.builtins.diagnostics.eslint.with({
      prefer_local = "node_modules/.bin"
    }),
    null_ls.builtins.formatting.prettier.with({
      prefer_local = "node_modules/.bin"
    }),
    null_ls.builtins.code_actions.eslint.with({
      prefer_local = "node_modules/.bin"
    }),
    null_ls.builtins.completion.spell,
    null_ls.builtins.formatting.rustfmt,

  },
})

vim.keymap.set('n', '==', ':Format <CR>')
vim.keymap.set('n', '<leader>ff', ':Format <CR>')
vim.api.nvim_set_keymap("n", ",", ":HopWord <CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>xx", ":Trouble <CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>S", "<cmd>lua require('spectre').open() <CR>", {})
vim.api.nvim_set_keymap("n", "<leader>sw", "<cmd>lua require('spectre').open_visual({select_word=true}) <CR>", {})
vim.api.nvim_set_keymap("v", "<leader>S", "<cmd>lua require('spectre').open_visual() <CR>", {})
vim.api.nvim_set_keymap("n", "<leader>qq", ":q <CR>", {})

vim.o.guifont = "JetbrainsMono Nerd Font:h18"

-- require('indent-o-matic').setup {
--   -- The values indicated here are the defaults
--
--   -- Number of lines without indentation before giving up (use -1 for infinite)
--   max_lines = 2048,
--
--   -- Space indentations that should be detected
--   standard_widths = { 2, 4, 8 },
-- }

vim.api.nvim_exec([[ autocmd BufNewFile,BufRead *.bean set filetype=beancount ]], false)
