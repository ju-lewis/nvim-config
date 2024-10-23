
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

local function ts()

    local startcmd = "typescript-language-server"

    if string.find(vim.loop.os_uname().sysname, "Windows") then
        -- If platform is windows, add `.cmd`
        startcmd = startcmd .. ".cmd"
    end

    vim.lsp.start({
        name = "typescript-language-server",
        cmd = {startcmd, "--stdio"},
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
        elseif args.match == "typescript" or args.match == "typescriptreact" or args.match == "typescript.tsx" then
            ts()
        end
    end,
}


