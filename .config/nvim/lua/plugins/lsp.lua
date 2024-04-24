return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost" },
    cmd = { "LspInfo", "LspInstall", "LspUninstall", "Mason" },
    dependencies = {
        -- Plugin and UI to automatically install LSPs to stdpath
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        -- Autocompletion plugins
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        -- Snippet plugins
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "rafamadriz/friendly-snippets",
        "onsails/lspkind.nvim",
        -- Progress/Status update for LSP
        "j-hui/fidget.nvim",
        -- Install neodev for better nvim configuration and plugin authoring via lsp configurations
        "folke/neodev.nvim",
    },
    config = function()
        local cmp = require('cmp')
        local luasnip = require("luasnip")
        local lspkind = require("lspkind")
        local map_lsp_keybinds = require("wardrek.keymaps").map_lsp_keybinds -- Has to load keymaps before pluginslsp

        -- Load snippets
        require("luasnip.loaders.from_vscode").lazy_load()
        require("luasnip").filetype_extend("python", { "pydoc" })
        require("luasnip").filetype_extend("lua", { "luadoc" })

        -- Use neodev to configure lua_ls in nvim directories - must load before lspconfig
        require("neodev").setup()

        require("fidget").setup({
            notification = {
                redirect =  -- Conditionally redirect notifications to another backend
                    function(msg, level, opts)
                        if opts and opts.on_open then
                            return require("fidget.integration.nvim-notify").delegate(msg, level, opts)
                        end
                    end,
                window = {
                    winblend = 0,
                    border = 'rounded',
                    relative = "editor",
                },
            },
        })

        -- Configure mason so it can manage 3rd party LSP servers
        require("mason").setup({
            ui = {
                border = "rounded",
            },
        })

        -- Configure mason to auto install servers
        require("mason-lspconfig").setup({
            automatic_installation = { exclude = { "ocamllsp", "gleam" } },
        })

        local has_words_before = function()
            unpack = unpack or table.unpack
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end

        cmp.setup({
            -- No preselection
            preselect = 'None',

            -- Add borders to floating windows
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },

            completion = {
                completeopt = 'menu,menuone,noinsert,noselect'
            },

            mapping = {
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    elseif has_words_before() then
                        cmp.complete()
                    else
                        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
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
                ['<CR>'] = cmp.mapping.confirm({ select = false }),
                ['<C-e>'] = cmp.mapping.abort(),
            },

            snippet = {
                expand = function(args)
                    local ls = require("luasnip")
                    if not ls then
                        return
                    end
                    ls.lsp_expand(args.body)
                end,
            },

            sources = cmp.config.sources({
                { name = 'nvim_lsp' },                    -- lsp
                { name = 'buffer',  max_item_count = 5 }, -- Text within current buffer
                { name = 'luasnip', max_item_count = 3 }, -- Snippets
                { name = 'path',    max_item_count = 3 }, -- File system paths
            }),

            -- Enable pictogram icons for lsp/autocompletion
            ---@diagnostic disable-next-line: missing-fields
            formatting = {
                expandable_indicator = true,
                format = lspkind.cmp_format({
                    mode = "symbol_text",
                    maxwidth = 50,
                    ellipsis_char = "...",
                }),
            },
            experimental = {
                ghost_text = false,
            },
        })

        -- LSP servers to install
        local servers = {
            bashls = {},
            lua_ls = {
                settings = {
                    Lua = {
                        workspace = { checkThirdParty = false },
                        telemetry = { enabled = false },
                    },
                },
            },
            marksman = {},
            pylsp = {
                settings = {
                    pylsp = {
                        plugins = {
                            pycodestyle = {
                                ignore = {},
                                maxLineLength = 160,
                            },
                        },
                    },
                },
            },
            hydra_lsp = {},
            gdscript = {
                filetypes = { "gd", "gdscript", "gdscript3" },
            },
        }

        -- Default handlers for LSP
        local default_handlers = {
            ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
            ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
        }

        -- nvim-cmp supports additional completion capabilities
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        local default_capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

        local on_attach = function(_client, buffer_number)
            -- Pass the current buffer to map lsp keybinds
            map_lsp_keybinds(buffer_number)

            -- Create a command `:Format` local to the LSP buffer
            vim.api.nvim_buf_create_user_command(buffer_number, "Format", function(_)
                vim.lsp.buf.format({
                    filter = function(format_client)
                        -- Use Prettier to format TS/JS if it's available
                        return format_client.name ~= "tsserver" or not null_ls.is_registered("prettier")
                    end,
                })
            end, { desc = "LSP: Format current buffer with LSP" })
        end

        -- Iterate over our servers and set them up
        for name, config in pairs(servers) do
            require("lspconfig")[name].setup({
                capabilities = default_capabilities,
                filetypes = config.filetypes,
                handlers = vim.tbl_deep_extend("force", {}, default_handlers, config.handlers or {}),
                on_attach = on_attach,
                settings = config.settings,
            })
        end

        vim.diagnostic.config({
            -- update_in_insert = true,
            virtual_text = true,
            underline = false,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}
