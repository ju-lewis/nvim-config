
local function haskell()
    vim.lsp.start({
        name = 'haskell-language-server',
        cmd = {'haskell-language-server-wrapper', '--lsp', },
        root_dir = vim.env.PWD,
    })
end

local function lua()
    vim.lsp.start({
        name = 'lua-language-server',
        cmd = {'lua-language-server'},
        root_dir = vim.env.PWD,
        settings = {
            Lua = {
                diagnostics = {
                    globals = {"vim"}
                }
            }
        }
    })
end

local function rust()
    vim.lsp.start({
        name = "rust-analyzer",
        cmd = {'rust-analyzer'},
        root_dir = vim.env.PWD,
    })
end


return {
    -- args is a table containing info about the FileType event
    startLsp = function(args)
        vim.print(args.match)
        if args.match == "haskell" then
            haskell()
        elseif args.match == "lua" then
            lua()
        elseif args.match == "rust" then
            rust()
        end
    end,
}


