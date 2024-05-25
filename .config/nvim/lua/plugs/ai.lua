return {
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    cond = false,
    branch = 'canary',
    cmd = { 'CopilotChatDocs', 'CopilotChatCommit' },
    keys = {
      {
        '<c-g><c-l>',
        function()
          local actions = require('CopilotChat.actions')
          require('CopilotChat.integrations.fzflua').pick(actions.prompt_actions())
        end,
        mode = { 'n', 'x' },
      },
      { '<c-g>k', '<cmd>CopilotChatToggle<cr>' },
    },
    dependencies = {
      { 'zbirenbaum/copilot.lua' },
      { 'nvim-lua/plenary.nvim' },
    },
    config = function()
      local cc = require('CopilotChat')
      local prompts = require('CopilotChat.prompts')
      local select = require('CopilotChat.select')
      cc.setup {
        debug = false, -- Enable debug logging
        proxy = nil, -- [protocol://]host[:port] Use this proxy
        allow_insecure = false, -- Allow insecure server connections
        system_prompt = prompts.COPILOT_INSTRUCTIONS, -- System prompt to use
        model = 'gpt-4', -- GPT model to use, 'gpt-3.5-turbo' or 'gpt-4'
        temperature = 0.1, -- GPT temperature
        question_header = '## User ', -- Header to use for user questions
        answer_header = '## Copilot ', -- Header to use for AI answers
        error_header = '## Error ', -- Header to use for errors
        separator = '---', -- Separator to use in chat
        show_folds = true, -- Shows folds for sections in chat
        show_help = true, -- Shows help message as virtual lines when waiting for user input
        auto_follow_cursor = true, -- Auto-follow cursor in chat
        auto_insert_mode = false, -- Automatically enter insert mode when opening window and if auto follow cursor is enabled on new prompt
        clear_chat_on_new_prompt = false, -- Clears chat on every new prompt

        context = nil, -- Default context to use, 'buffers', 'buffer' or none (can be specified manually in prompt via @).
        history_path = fn.stdpath('data') .. '/copilotchat_history', -- Default path to stored history
        callback = nil, -- Callback to use when ask response is received

        -- default selection (visual or line)
        selection = function(source) return select.visual(source) or select.line(source) end,

        -- default prompts
        prompts = {
          Explain = {
            prompt = '/COPILOT_EXPLAIN Write an explanation for the code above as paragraphs of text.',
          },
          Tests = {
            prompt = '/COPILOT_TESTS Write a set of detailed unit test functions for the code above.',
          },
          Fix = {
            prompt = '/COPILOT_FIX There is a problem in this code. Rewrite the code to show it with the bug fixed.',
          },
          Optimize = {
            prompt = '/COPILOT_REFACTOR Optimize the selected code to improve performance and readablilty.',
          },
          Docs = {
            prompt = '/COPILOT_REFACTOR Write documentation for the selected code. The reply should be a codeblock containing the original code with the documentation added as comments. Use the most appropriate documentation style for the programming language used (e.g. JSDoc for JavaScript, docstrings for Python etc.',
          },
          FixDiagnostic = {
            prompt = 'Please assist with the following diagnostic issue in file:',
            selection = select.diagnostics,
          },
          Commit = {
            prompt = 'Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.',
            selection = select.gitdiff,
          },
          CommitStaged = {
            prompt = 'Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.',
            selection = function(source) return select.gitdiff(source, true) end,
          },
        },
        -- default window options
        window = {
          layout = 'float', -- 'vertical', 'horizontal', 'float'
          -- Options below only apply to floating windows
          relative = 'editor', -- 'editor', 'win', 'cursor', 'mouse'
          border = 'single', -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
          width = 0.8, -- fractional width of parent
          height = 0.6, -- fractional height of parent
          row = nil, -- row position of the window, default is centered
          col = nil, -- column position of the window, default is centered
          title = 'Copilot Chat', -- title of chat window
          footer = nil, -- footer of chat window
          zindex = 1, -- determines if window is on top or below other floating windows
        },
        -- default mappings
        mappings = {
          complete = { detail = 'Use @<Tab> or /<Tab> for options.', insert = '<Tab>' },
          close = { normal = 'q', insert = '<C-c>' },
          reset = { normal = '<C-l>', insert = '<C-l>' },
          submit_prompt = { normal = '<CR>', insert = '<C-m>' },
          accept_diff = { normal = '<C-y>', insert = '<C-y>' },
          yank_diff = { normal = 'gy' },
          show_diff = { normal = 'gd' },
          show_system_prompt = { normal = 'gp' },
          show_user_selection = { normal = 'gs' },
        },
      }
    end,
  },
  {
    'github/copilot.vim',
    event = 'VeryLazy',
    -- cond = fn.argv()[1] ~= 'leetcode.nvim',
    cond = false,
    init = function() vim.g.copilot_no_tab_map = true end,
    config = function()
      vim.g.copilot_filetypes = { registers = 0, markdown = 1 }
      map(
        'i',
        '<a-e>',
        'copilot#Accept("<cr>")',
        { silent = true, script = true, expr = true, replace_keycodes = false }
      )
      map('i', '<a-d>', '<cmd>Copilot<cr>')
    end,
  },
  -- 没 api key, gpt 都不能用
  -- https://github.com/Robitx/gp.nvim/pull/93
  {
    'robitx/gp.nvim',
    cond = false,
    branch = 'copilot',
    cmd = {
      'GpChatNew',
      'GpAgent',
      'GpChatToggle',
      'GpChatFinder',
    },
    -- stylua: ignore
    keys = {
      { '<c-g>c', ':GpChatNew popup<cr>', mode = { 'n', 'x' } },
      { '<c-g>k', ':GpChatToggle <cr>',   mode = { 'n', 'x' } },
      { '<c-g>f', ':GpChatFinder<cr>',    mode = { 'n', 'x' } },
      { '<c-g>p', ':GpChatPaste<cr>',     mode = { 'n', 'x' } },
    },
    opts = {
      toggle_target = 'popup',
      providers = {
        openai = {
          endpoint = 'https://api.openai.com/v1/chat/completions',
          -- secret = os.getenv("OPENAI_API_KEY"),
        },
        copilot = {
          endpoint = 'https://api.githubcopilot.com/chat/completions',
          secret = {
            'bash',
            '-c',
            "cat ~/.config/github-copilot/hosts.json | sed -e 's/.*oauth_token...//;s/\".*//'",
          },
        },
      },
    },
  },
  {
    'jackMort/ChatGPT.nvim',
    cond = env.OPENAI_API_KEY ~= nil,
    cmd = 'ChatGPT',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
    },
    opts = {},
  },
  {
    'monkoose/neocodeium',
    cond = false,
    event = 'VeryLazy',
    opts = {},
    keys = {
        -- stylua: ignore start
        { mode = "i", "<A-g>", function() require("neocodeium").accept() end },
        { mode = "i", "<A-w>", function() require("neocodeium").accept_word() end },
        { mode = "i", "<A-a>", function() require("neocodeium").accept_line() end },
        { mode = "i", "<A-n>", function() require("neocodeium").cycle_or_complete() end },
        { mode = "i", "<A-N>", function() require("neocodeium").cycle_or_complete(-1) end },
        { mode = "i", "<A-c>", function() require("neocodeium").clear() end },
      -- stylua: ignore end
    },
  },
}
