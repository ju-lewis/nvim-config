-- Line Config
vim.opt.number = true
vim.opt.relativenumber = true
vim.cmd("autocmd FileType * set formatoptions-=ro")
vim.cmd(":set nowrap")

-- Tab Config
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smarttab = true

-- Text Config
vim.cmd(":syntax on")

-- Basic Binds
vim.keymap.set({"i", "n"}, "<C-Y>", function () vim.cmd(":edit $MYVIMRC") end)
vim.keymap.set({"t"}, "<Esc>", "<C-\\><C-N>")

-- lazy.nvim Bootstrapping
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins")

-- Colorscheme
vim.cmd(":colorscheme catppuccin-macchiato")

-- Snippet 
local ls = require("luasnip")
-- Shift-Tab to open snippet menu
vim.keymap.set({"i"}, "<S-Tab>", function() ls.expand() end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-J>", function() ls.jump( 1) end, {silent = true}) -- Go down 1
vim.keymap.set({"i", "s"}, "<C-K>", function() ls.jump(-1) end, {silent = true}) -- Go up 1

vim.keymap.set({"i", "s"}, "<C-E>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, {silent = true})

-- Treesitter
require("treesitter-config")

-- LSP Config
local lsp_zero = require('lsp-zero')
lsp_zero.on_attach(function(client, bufnr)
	lsp_zero.default_keymaps({buffer = bufnr})
end)

require("mason").setup({})
require("mason-lspconfig").setup({
	ensure_installed = {'rust_analyzer', 'lua_ls', 'pyright'},
	handlers = {
		lsp_zero.default_setup,
	}
})


-- Telescope keybinds
local ts = require("telescope.builtin")
vim.keymap.set({"i", "n"}, "<C-Z>", function () ts.find_files() end )

-- Tab Page Keybinds
vim.keymap.set({"n", "i"}, "<C-D>", function () vim.api.nvim_command(":tabnew") end) -- Open new tab
vim.keymap.set({"n", "i"}, "<C-X>", function () vim.api.nvim_command(":tabclose") end) -- Close current tab
vim.keymap.set({"n"}, "<C-L>", function () vim.api.nvim_command("+tabnext") end)
vim.keymap.set({"n"}, "<C-H>", function () vim.api.nvim_command("-tabnext") end)


-- Lualine
local lualine = require("lualine")
lualine.setup({})
