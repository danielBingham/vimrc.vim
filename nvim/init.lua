
------------------------------------------------------------------------------
-- PLUGINS (plugin settings at bottom)
------------------------------------------------------------------------------

-- if packer isn't installed, lets grab it
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd [[packadd packer.nvim]]
end

require('packer').startup({function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  
  ----- Making Vim look good ------------------------------------------
  use {
      'maxmx03/solarized.nvim',
      config = function()
        vim.o.background = 'dark' -- or 'light'

        vim.cmd.colorscheme 'solarized'
      end
  }
  use 'bling/vim-airline'
  use 'vim-airline/vim-airline-themes'
  use 'gcmt/taboo.vim'

  ----- Vim as a programmer's text editor -----------------------------
  use 'scrooloose/nerdtree'
  use 'jistr/vim-nerdtree-tabs'
  use 'xolox/vim-misc'
  use 'vadimr/bclose.vim'
  use 'mileszs/ack.vim'
  use 'junegunn/fzf'
  use 'junegunn/fzf.vim'

  ----- Working with Git ----------------------------------------------
  use 'airblade/vim-gitgutter'
  use 'tpope/vim-fugitive'

  ----- Folding -------------------------------------------------------
  use 'Konfekt/FastFold'

  ----- Syntax plugins ------------------------------------------------
  use 'sheerun/vim-polyglot'
  use 'lifepillar/pgsql.vim'

  -- LSP integration and autocomplete
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-nvim-lsp-signature-help'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'

  use({
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    tag = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!:).
    run = "make install_jsregexp"
  })

  -- if we bootstrapped packer then sync config
  if packer_bootstrap then
    require('packer').sync()
  end
end})


vim.opt.ruler = true
vim.opt.number = true
vim.opt.showcmd = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ts=4 
vim.opt.sw=4 
vim.opt.et = true

vim.opt.foldmethod = 'indent'
vim.opt.foldnestmax = 6
vim.opt.foldlevelstart=1

vim.cmd[[colorscheme solarized]]

-- LSP Mappings + Settings -----------------------------------------------------
-- modified from: https://github.com/neovim/nvim-lspconfig#suggested-configuration
local opts = { noremap=true, silent=true }
-- Basic diagnostic mappings, these will navigate to or display diagnostics
vim.keymap.set('n', '<space>d', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings to magical LSP functions!
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'gk', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', 'gK', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Capabilities required for the visualstudio lsps (css, html, etc)
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Activate LSPs
-- All LSPs in this list need to be manually installed via NPM/PNPM/whatevs
local lspconfig = require('lspconfig')

lspconfig.tsserver.setup {
  on_attach = on_attach,
  capabilities = capabilities
}

lspconfig.jsonls.setup {
  on_attach = on_attach,
  capabilities = capabilities
}

lspconfig.eslint.setup {
  on_attach = on_attach,
  capabilities = capabilities
}

lspconfig.cssls.setup {
    on_attach = on_attach,
    capabilities = capabilities
}

lspconfig.html.setup {
    on_attach = on_attach,
    capabilities = capabilities
}

lspconfig.pyright.setup {
  on_attach = on_attach,
  capabilities = capabilities
}

lspconfig.pylsp.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    pylsp = {
      configurationSource = {"flake8"},
      plugins = {
        pycodestyle = {
          enabled = false
        },
        mccabe = {
          enabled = false
        },
        pyflakes = {
          enabled = false
        },
        flake8 = {
          enabled = true
        }
      }
    }
  }
}

-- Luasnip ---------------------------------------------------------------------
-- Load as needed by filetype by the luasnippets folder in the config dir
local luasnip = require("luasnip")
require("luasnip.loaders.from_lua").lazy_load()
-- set keybinds for both INSERT and VISUAL.
vim.api.nvim_set_keymap("i", "<C-n>", "<Plug>luasnip-next-choice", {})
vim.api.nvim_set_keymap("s", "<C-n>", "<Plug>luasnip-next-choice", {})
vim.api.nvim_set_keymap("i", "<C-p>", "<Plug>luasnip-prev-choice", {})
vim.api.nvim_set_keymap("s", "<C-p>", "<Plug>luasnip-prev-choice", {})
-- Set this check up for nvim-cmp tab mapping
local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- CMP - Autocompletion --------------------------------------------------------
local cmp = require 'cmp'
cmp.setup {
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    mapping = {
        ['<C-k>'] = cmp.mapping.select_prev_item(),
        ['<C-j>'] = cmp.mapping.select_next_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
        else
            fallback()
        end
    end, { "i", "s" }),
    },
    completion = {
        autocomplete = false
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'luasnip' },
        --{ name = 'buffer' },
        --{ name = 'path' }
    },
}

----- bling/vim-airline settings -----
-- Always show statusbar
vim.opt.laststatus = 2
vim.g.airline_theme='solarized'
vim.g.airline_solarized_bg='dark'

vim.g.airline_detect_paste=1
vim.cmd[[
let g:airline#extensions#default#layout = [
  \ [ 'a', 'b', 'c' ],
  \ [  'z', 'error' ]
  \ ]
]]

-- Show airline for tabs too
vim.cmd[[
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#tab_nr_type = 1 " tab number
let g:airline#extensions#tabline#buffer_idx_mode = 0
]]

----- Fzf ------
vim.cmd[[
let $FZF_DEFAULT_COMMAND = 'ag -g ""'
]]

----- jistr/vim-nerdtree-tabs -----
-- Open/close NERDTree Tabs with \t
vim.cmd[[
nmap <silent> <leader>t :NERDTreeTabsToggle<CR>
]]

-- To have NERDTree always open on startup
vim.g.nerdtree_tabs_open_on_console_startup = 1

-- Ignore python's compiled binaries
vim.cmd[[
let NERDTreeIgnore = ['\.pyc$', '__pycache__']
]]

----- mileszs/ack.vim -----
-- Make :ack use ag instead of ack.
vim.cmd[[
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif
cnoreabbrev Ack Ack!
]]

