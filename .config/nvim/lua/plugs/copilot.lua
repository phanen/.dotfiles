return {
  {
    'zbirenbaum/copilot.lua',
    cond = fn.argv()[1] ~= 'leetcode.nvim',
    cmd = 'Copilot',
    event = 'InsertEnter',
    dependencies = 'nvim-cmp',
    opts = {
      panel = { layout = { position = 'right', ratio = 0.4 } },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = '<a-s>',
          accept_word = '<a-f>',
          accept_line = '<a-e>',
          next = '<a-n>',
          prev = '<a-p>',
          dismiss = '<a-c>',
        },
      },
    },
  },
  {
    'robitx/gp.nvim',
    cmd = { 'GpChatNew', 'GpAgent', 'GpChatToggle', 'GpChatFinder' },
    -- stylua: ignore
    opts = {
      -- toggle_target = 'popup',
      -- openai_api_key = 'fakeapi',
      providers = {
        openai = { disable = true },
        copilot = { enable = true },
      },
    },
  },
  {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    cond = false,
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    opts = {
      -- add any opts here
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = 'make',
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'stevearc/dressing.nvim',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      --- The below dependencies are optional,
      'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
      'zbirenbaum/copilot.lua', -- for providers='copilot'
      {
        -- support for image pasting
        'HakonHarnes/img-clip.nvim',
        event = 'VeryLazy',
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { 'markdown', 'Avante' },
        },
        ft = { 'markdown', 'Avante' },
      },
    },
  },
}
