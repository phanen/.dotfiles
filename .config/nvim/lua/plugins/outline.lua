return {
    {
        "SmiteshP/nvim-navbuddy",
        lazy = false,
        dependencies = {
            "SmiteshP/nvim-navic",
            "MunifTanjim/nui.nvim"
        },
        opts = { lsp = { auto_attach = true } }
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
