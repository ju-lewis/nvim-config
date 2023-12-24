-- Line Config
vim.opt.number = true
vim.opt.relativenumber = true
vim.cmd([[autocmd FileType * set formatoptions-=ro]])

-- Tab Config
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smarttab = true

-- Text Config
vim.cmd[[:syntax on]]


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
vim.cmd[[colorscheme tokyonight]]

-- Snippet 

ls = require("luasnip")
-- Shift-Tab to open snippet menu
vim.keymap.set({"i"}, "<S-Tab>", function() ls.expand() end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-J>", function() ls.jump( 1) end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-K>", function() ls.jump(-1) end, {silent = true})

vim.keymap.set({"i", "s"}, "<C-E>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, {silent = true})

require("luasnip.loaders.from_vscode").lazy_load()
