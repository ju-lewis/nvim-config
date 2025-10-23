
_=[[

  ___           _ _      _  ___   _____ __  __    ___           __ _      
 | _ ) ___  ___| ( )___ | \| \ \ / /_ _|  \/  |  / __|___ _ _  / _(_)__ _ 
 | _ \/ _ \/ _ \ |/(_-< | .` |\ V / | || |\/| | | (__/ _ \ ' \|  _| / _` |
 |___/\___/\___/_| /__/ |_|\_| \_/ |___|_|  |_|  \___\___/_||_|_| |_\__, |
                                                                    |___/ 
]]


vim.opt.number = true
vim.opt.cursorline = true
vim.opt.relativenumber = true
vim.cmd("autocmd FileType * set formatoptions-=ro")
vim.cmd(":set nowrap")

vim.cmd(":set colorcolumn=80")

-- If we're on Windows, use powershell instead of command prompt.
if string.find(vim.loop.os_uname().sysname, "Windows") then
    vim.opt.shell = "powershell.exe"
end


-- Tab Config
vim.opt.expandtab = true
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
--vim.cmd(":colorscheme catppuccin-mocha")
vim.cmd(":colorscheme gruvbox")
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
local treesitter = require("nvim-treesitter.install")
if string.find(vim.loop.os_uname().sysname, "Windows") then
    treesitter.compilers = {"clang"}
end
require("treesitter-config")

-- Telescope keybinds
local ts = require("telescope.builtin")
require("telescope").setup({
    defaults = {
        file_ignore_patterns = {
            "node%_modules",
            "%.git",
            "build",
            "release",
            "target",
            "%.csv",
            --"%.o",
            "%.hi",
            --"cache",
            "vendored"
        }
    }
})
vim.keymap.set({"i", "n"}, "<C-P>", function () ts.find_files() end )

-- Tab Page Keybinds
vim.keymap.set({"n", "i"}, "<C-D>", function () vim.api.nvim_command(":tabnew") end) -- Open new tab
vim.keymap.set({"n", "i"}, "<C-X>", function () vim.api.nvim_command(":tabclose") end) -- Close current tab
vim.keymap.set({"n"}, "<C-L>", function () vim.api.nvim_command(":tabnext") end)
vim.keymap.set({"n"}, "<C-H>", function () vim.api.nvim_command(":tabprevious") end)


-- Lualine
local lualine = require("lualine")
lualine.setup({})


-- Colorizer
--local colorizer = require("colorizer")
--colorizer.setup()


------------------------------ LSP CONFIGURATION ------------------------------

-- My custom configs

--local lspconfig = require("lspconfig")
local pid = vim.fn.getpid()

vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
})



-- LSP setups
vim.lsp.config("rust_analyzer", {})
vim.lsp.config("hls", {})
vim.lsp.config("quick_lint_js", {})
vim.lsp.config("ts_ls", {})
vim.lsp.config("pyright", {})
vim.lsp.config("clangd", {})
vim.lsp.config("omnisharp", {
    cmd = {
        "dotnet",
        vim.fn.expand("~/.local/share/omnisharp/OmniSharp.dll"),
        "--languageserver",
        "--hostPID",
        tostring(pid),
    },
    enable_editorconfig_support = true,
    enable_roslyn_analyzers = true,
    organize_imports_on_format = true,
    enable_import_completion = true,
    --capabilities = require("cmp_nvim_lsp").default_capabilities(),
    --handlers = {
    --  ["textDocument/definition"] = require("omnisharp_extended").handler,
    --},
})

vim.lsp.enable("lua_ls")
vim.lsp.enable("rust_analyzer")
vim.lsp.enable("hls")
vim.lsp.enable("quick_lint_js")
vim.lsp.enable("ts_ls")
vim.lsp.enable("pyright")
vim.lsp.enable("clangd")
vim.lsp.enable("omnisharp")


vim.lsp.set_log_level("off")
vim.diagnostic.config({
    virtual_text = true
})

vim.keymap.set({"n"}, "<C-A>", function() vim.lsp.buf.code_action() end)
vim.keymap.set({"n"}, "<C-N>", function() vim.diagnostic.open_float() end)

--require("lsp_lines").setup({})
-------------------------------------------------------------------------------



-------------------------------- AI INTEGRATION -------------------------------

require("codecompanion").setup({
    adapters = {
        http = {
            gemini = function ()
                return require("codecompanion.adapters").extend("gemini", {
                    schema = {
                        model = {
                            default = "gemini-2.5-flash"
                            --default = "gemini-2.5-pro"
                        }
                    }
                })
            end,
        }
    },
    strategies = {
        chat = {
            adapter = "gemini"
            --adapter = "ollama",
        },
        inline = {
            adapter = "gemini",
            --adapter = "ollama",
            keymaps = {
                accept_change = {
                    modes = { n = "ga" },
                    description = "Accept the suggested change",
                },
                reject_change = {
                    modes = { n = "gr" },
                    description = "Reject the suggested change",
                },
            },
        }
    }
})

-------------------------------------------------------------------------------


