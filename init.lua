-- [[ Basic Settings ]]
vim.g.loaded_netrw = 1
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local opt = vim.opt
opt.relativenumber = true
opt.number = true
opt.linebreak = true
opt.hlsearch = false
opt.mouse = 'a'
opt.clipboard = 'unnamedplus'
opt.breakindent = true
opt.undofile = true
opt.ignorecase = true
opt.smartcase = true
opt.updatetime = 250
opt.timeoutlen = 300
opt.completeopt = 'menuone,noselect'
opt.termguicolors = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = false
opt.iskeyword:remove("_")

-- [[ Plugins & Theme ]]
require("custom.lazy")
require("nord").set()
require('colorizer').setup()
require('neodev').setup()
vim.api.nvim_set_hl(0, 'Normal', { bg = '#2E3440' })

-- [[ Plugin Specific Globals ]]
vim.g.user_emmet_leader_key = ','
vim.g.user_emmet_mode = 'n'
vim.g.vimtex_view_method = 'zathura'
vim.g.vimtex_compiler_method = 'pdflatex'
vim.g.Tex_GotoError = 0
vim.filetype.add({ extension = { templ = "templ" } })

-- [[ General Keymaps ]]
local k = vim.keymap
k.set('n', '<Space>', '<Nop>', { silent = true })
k.set("n", "<A-s>", "<cmd>wa<CR>", { desc = "Save all" })
k.set('n', '<A-c>', '<Cmd>bw<CR>', { desc = "Close buffer" })
k.set("n", "<A-n>", ":Neotree toggle<CR>", { silent = true })
k.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Blackhole Register Remaps (Prevent overwriting clipboard)
local bh_keys = { "d", "D", "c", "C", "x", "s" }
for _, key in ipairs(bh_keys) do
  k.set({ "n", "v" }, key, '"_' .. key)
end
k.set({ "n", "v" }, "<C-D>", "d", { desc = "Actual delete (non-blackhole)" })

-- Movement & Navigation
k.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
k.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
k.set("n", "<C-h>", "<cmd>TmuxNavigateLeft<CR>")
k.set("n", "<C-j>", "<cmd>TmuxNavigateDown<CR>")
k.set("n", "<C-k>", "<cmd>TmuxNavigateUp<CR>")
k.set("n", "<C-l>", "<cmd>TmuxNavigateRight<CR>")

-- [[ Which-Key Configuration (NEW SPEC v3) ]]
local wk = require("which-key")
wk.add({
  { "<leader>c", group = "[C]ode" },
  { "<leader>d", group = "[D]ocument" },
  { "<leader>g", group = "[G]it" },
  { "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
  { "<leader>r", group = "[R]ename" },
  { "<leader>s", group = "[S]earch" },
  { "<leader>t", group = "[T]oggle" },
  { "<leader>w", group = "[W]orkspace" },
})

-- [[ Plugin-Specific Keymaps ]]
k.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = "Undo Tree" })
k.set('n', '<leader>m', "<CMD>TSJToggle<CR>", { desc = "Line splitting toggle" })
k.set("n", "<leader>nt", ":VimwikiTable 1 2<CR>", { desc = "Vimwiki Table" })

-- Leap.nvim
k.set({ 'n', 'x', 'o' }, '<leader>l', '<Plug>(leap-forward)')
k.set({ 'n', 'x', 'o' }, '<leader>L', '<Plug>(leap-backward)')
k.set({ 'n', 'x', 'o' }, '<leader>gl', '<Plug>(leap-from-window)')

-- [[ Telescope Setup ]]
require("telescope").setup({
  pickers = {
    find_files = { find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" } },
  },
})
pcall(require('telescope').load_extension, 'fzf')

local builtin = require('telescope.builtin')
k.set('n', '<leader>?', builtin.oldfiles, { desc = '[?] Find recently opened files' })
k.set('n', '<leader><space>', builtin.buffers, { desc = '[ ] Find existing buffers' })
k.set('n', '<leader>ff', builtin.find_files, { desc = '[S]earch [F]iles' })
k.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
k.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })

-- [[ LSP & Mason ]]
require('mason').setup()
require('mason-lspconfig').setup()

local on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
  end
  nmap('<leader>rn', vim.lsp.buf.rename, '[R]ename')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', builtin.lsp_references, '[G]oto [R]eferences')
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
end

-- LSP Servers
local servers = {
  lua_ls = { Lua = { workspace = { checkThirdParty = false }, telemetry = { enable = false } } },
  gopls = { gopls = { completeUnimported = true, usePlaceholders = true } },
  clangd = {},
  eslint = {},
  kotlin_language_server = {},
}

local capabilities = require('cmp_nvim_lsp').default_capabilities()

for server, config in pairs(servers) do
  require('lspconfig')[server].setup {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = config,
  }
end

-- [[ Autocommands ]]
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  group = highlight_group,
  callback = function() vim.highlight.on_yank() end,
})
