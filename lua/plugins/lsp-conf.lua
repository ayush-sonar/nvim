-- Enhanced lsp-conf.lua with better Python detection
return {
    {"williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end
    },
    {"williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {"lua_ls", "pyright", "ts_ls"}
            })
        end
    },
    {"neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            -- Function to find Python executable in common venv locations
            local function get_python_path()
                -- Check for virtual environments in order of preference
                local venv_paths = {
                    vim.fn.getcwd() .. "/venv/bin/python",
                    vim.fn.getcwd() .. "/.venv/bin/python", 
                    vim.fn.getcwd() .. "/env/bin/python",
                }
                
                for _, path in ipairs(venv_paths) do
                    if vim.fn.executable(path) == 1 then
                        return path
                    end
                end
                
                -- Fallback to system python
                return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
            end

            -- Lua LSP
            lspconfig.lua_ls.setup({
                capabilities = capabilities
            })

            -- TypeScript LSP
            lspconfig.ts_ls.setup({
                capabilities = capabilities
            })

            -- Python LSP (Pyright)
            lspconfig.pyright.setup({
                capabilities = capabilities,
                settings = {
                    python = {
                        analysis = {
                            autoSearchPaths = true,
                            diagnosticMode = "workspace",
                            useLibraryCodeForTypes = true,
                            typeCheckingMode = "basic"
                        },
                        -- Let Pyright find the Python path automatically
                        -- It's very good at detecting venvs in standard locations
                        pythonPath = get_python_path()
                    }
                },
                -- This runs when Pyright starts and shows which Python it's using
                on_attach = function(client, bufnr)
                    local python_path = get_python_path()
                    print("Pyright using Python: " .. python_path)
                end
            })

            -- LSP Keymaps
            vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {})
            vim.keymap.set("n", "go", vim.lsp.buf.type_definition, {})
            vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
            vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, {})
            vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, {})
            vim.keymap.set({"n", "x"}, "<F3>", function()
                vim.lsp.buf.format({async = true})
            end, {})
            vim.keymap.set("n", "<F4>", vim.lsp.buf.code_action, {})
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
            vim.keymap.set("n", "<leader>d", ":Telescope diagnostics<CR>", {})
            vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next)

            -- Auto-completion settings
            vim.opt.completeopt = {'menu', 'menuone', 'noselect'}
        end
    }
}
