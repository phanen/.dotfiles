local treesitter_setup = function()
  require('nvim-next.integrations').treesitter_textobjects()
  require('nvim-treesitter.configs').setup {
    ensure_installed = {
      'bash',
      'c',
      'cpp',
      'css',
      'fish',
      'go',
      'html',
      'java',
      'javascript',
      'lua',
      'markdown',
      'markdown_inline',
      'python',
      'query',
      'rust',
      'typescript',
      'vimdoc',
    },
    highlight = {
      enable = true,
      disable = function(_, bufnr) return vim.api.nvim_buf_line_count(bufnr) > 10000 end,
    },
    indent = { enable = true, disable = { 'python' } },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<cr>',
        node_incremental = '<cr>',
        node_decremental = '<s-cr>',
      },
    },
    textobjects = {
      select = {
        enable = true,
        disable = function(_, bufnr) return vim.api.nvim_buf_line_count(bufnr) > 10000 end,
        lookahead = true, -- automatically jump forward to textobj, similar to targets.vim
        set_jumps = true, -- whether to set jumps in the jumplist
        keymaps = {
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',

          ['ar'] = '@return.outer',
          ['ir'] = '@return.outer',
          ['as'] = '@class.outer',
          ['is'] = '@class.inner',
          ['aj'] = '@conditional.outer',
          ['ij'] = '@conditional.inner',
          ['ak'] = '@loop.outer',
          ['ik'] = '@loop.inner',
        },
      },
      swap = {
        enable = true,
        swap_next = { ['<leader>sj'] = '@parameter.inner' },
        swap_previous = { ['<leader>sk'] = '@parameter.inner' },
      },
    },
    nvim_next = {
      enable = true,
      textobjects = {
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            [']a'] = '@parameter.outer',
            [']f'] = '@function.outer',
            [']r'] = '@function.outer',
            [']s'] = '@class.outer',
            [']j'] = '@conditional.outer',
            [']k'] = '@loop.outer',
          },
          goto_next_end = {
            [']A'] = '@parameter.outer',
            [']F'] = '@function.outer',
            [']R'] = '@function.outer',
            [']S'] = '@class.outer',
            [']J'] = '@conditional.outer',
            [']K'] = '@loop.outer',
          },
          goto_previous_start = {
            ['[a'] = '@parameter.outer',
            ['[f'] = '@function.outer',
            ['[r'] = '@function.outer',
            ['[s'] = '@class.outer',
            ['[j'] = '@conditional.outer',
            ['[k'] = '@loop.outer',
          },
          goto_previous_end = {
            ['[A'] = '@parameter.outer',
            ['[F'] = '@function.outer',
            ['[R'] = '@function.outer',
            ['[S'] = '@class.outer',
            ['[J'] = '@conditional.outer',
            ['[K'] = '@loop.outer',
          },
        },
      },
    },
  }

  -- FIXME: cannot jump to last function name
  local goto_function = function(direction)
    local ts = vim.treesitter
    local queries = require('nvim-treesitter.query')
    -- local filetype = vim.api.nvim_buf_get_option(0, 'ft')
    -- FIXME: correct bufnr
    local filetype = vim.bo.ft
    local lang = require('nvim-treesitter.parsers').ft_to_lang(filetype)
    -- 定义Treesitter查询
    local go_query = [[
    (function_declaration
        name: (identifier) @function_name)
    (method_declaration
        name: (field_identifier) @function_name)
    ]]
    local query = [[
    (function_declaration
        name: (identifier) @function_name)
    ]]

    -- 获取当前buffer的Treesitter语法树
    local parser = ts.get_parser(0, lang)
    local tree = parser:parse()[1]
    local root = tree:root()

    -- 获取查询对象
    if lang == 'go' then query = go_query end
    local query_obj = vim.treesitter.query.parse(lang, query)

    -- 执行查询
    local matches = {}
    for pattern, match, metadata in query_obj:iter_matches(root, 0) do
      for id, node in pairs(match) do
        local name = query_obj.captures[id]
        if name == 'function_name' then table.insert(matches, node) end
      end
    end

    -- 如果找到匹配项，则移动光标到函数名处
    if #matches > 0 then
      local closest_function = nil
      local closest_distance = nil
      local row, col = unpack(vim.api.nvim_win_get_cursor(0))

      for _, function_name_node in ipairs(matches) do
        local start_row, start_col, _, _ = function_name_node:range()
        local distance = math.abs(start_row - row)

        if
          distance ~= 1
          and direction == 'prev'
          and (start_row < row or (start_row == row and start_col < col))
        then
          if closest_distance == nil or distance < closest_distance then
            closest_distance = distance
            closest_function = function_name_node
          end
        elseif
          distance ~= 1
          and direction == 'next'
          and (start_row > row or (start_row == row and start_col > col))
        then
          if closest_distance == nil or distance < closest_distance then
            closest_distance = distance
            closest_function = function_name_node
          end
        end
      end

      if closest_function then
        local start_row, start_col, _, _ = closest_function:range()
        vim.api.nvim_win_set_cursor(0, { start_row + 1, start_col })
      end
    end
  end

  -- local function goto_prev_function() goto_function('prev') end
  -- local function goto_next_function() goto_function('next') end
  -- n('[f', goto_prev_function)
  -- n(']f', goto_next_function)
end

return {
  -- TODO: upstream is still working
  {
    'windwp/nvim-ts-autotag',
    -- event = 'InsertEnter',
    Filetype = { 'markdown', 'xml', 'html' },
    opts = {
      opts = {
        enable_close = true, -- Auto close tags
        enable_rename = true, -- Auto rename pairs of tags
        enable_close_on_slash = false, -- Auto close on trailing </
      },
    },
    -- per_filetype = {
    --   ['html'] = { enable_close = false },
    -- },
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = function() require('nvim-treesitter.install').update { with_sync = true } end,
    event = { 'BufReadPre', 'BufNewFile' },
    -- event = { 'Filetype' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = vim.schedule_wrap(treesitter_setup),
    -- config = treesitter_setup,
  },
  {
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter' },
    cmd = { 'TSJToggle' },
    opts = { use_default_keymaps = false, notify = false },
  },
  {
    'ghostbuster91/nvim-next',
    keys = { '[d', ']d', ']q', '[q' },
    config = function()
      local next = require 'nvim-next'
      local b = require 'nvim-next.builtins'
      local i = require 'nvim-next.integrations'
      next.setup { default_mappings = { repeat_style = 'original' }, items = { b.f, b.t } }
      local diag = i.diagnostic()
      local nqf = i.quickfix()
      n('[d', diag.goto_prev())
      n(']d', diag.goto_next())
      n('[q', nqf.cprevious)
      n(']q', nqf.cnext)
    end,
  },
}
