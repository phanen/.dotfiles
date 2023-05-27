return {
    {
        "SmiteshP/nvim-navbuddy",
        lazy = false,
        dependencies = {
            "SmiteshP/nvim-navic",
            "MunifTanjim/nui.nvim",
        },
        config = function()
            require('nvim-navbuddy').setup {
                lsp = { auto_attach = true },
                -- icons = require('lspkind').symbol_map,
                icons = {
                    Text = "󰉿",
                    Method = "󰆧",
                    Function = "󰊕",
                    Constructor = "",
                    Field = "󰜢",
                    Variable = "󰀫",
                    Class = "󰠱",
                    Interface = "",
                    Module = "",
                    Property = "󰜢",
                    Unit = "󰑭",
                    Value = "󰎠",
                    Enum = "",
                    Keyword = "󰌋",
                    Snippet = "",
                    Color = "󰏘",
                    File = "󰈙",
                    Reference = "󰈇",
                    Folder = "󰉋",
                    EnumMember = "",
                    Constant = "󰏿",
                    Struct = "󰙅",
                    Event = "",
                    Operator = "󰆕",
                    TypeParameter = "",

        -- File          = " ",
        -- Module        = " ",
        -- Namespace     = " ",
        -- Package       = " ",
        -- Class         = " ",
        -- Method        = " ",
        -- Property      = " ",
        -- Field         = " ",
        -- Constructor   = " ",
        -- Enum          = "練",
        -- Interface     = "練",
        -- Function      = " ",
        -- Variable      = " ",
        -- Constant      = " ",
        -- String        = " ",
        -- Number        = " ",
        -- Boolean       = "◩ ",
        -- Array         = " ",
        -- Object        = " ",
        -- Key           = " ",
        -- Null          = "ﳠ ",
        -- EnumMember    = " ",
        -- Struct        = " ",
        -- Event         = " ",
        -- Operator      = " ",
        -- TypeParameter = " ",
                },
            }
        end,
    },

    {
        -- outline
        'stevearc/aerial.nvim',
        lazy = false,
        config = true,
        opts = {
            keymaps = {
                ["<C-n>"] = "actions.down_and_scroll",
                ["<C-p>"] = "actions.up_and_scroll",
                ["<C-j>"] = "",
                ["<C-k>"] = "",
                ["g?"] = "actions.show_help",
            },
        }
    },


}
