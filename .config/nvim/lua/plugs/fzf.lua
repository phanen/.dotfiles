-- https://github.com/ibhagwan/fzf-lua/issues/1485

local function starts_with_pattern(line) return line:match '^.-:%d+:%d+:' ~= nil end

local function parse_line(line)
  local file_path, line_nr, col_nr, text = line:match '^(.-):(%d+):(%d+):(.*)$'
  return file_path, tonumber(line_nr), tonumber(col_nr), text
end

---@alias trouble.LangRegions table<string, number[][][]>

local TSInjector = {}

TSInjector.cache = {} ---@type table<number, table<string,{parser: vim.treesitter.LanguageTree, highlighter:vim.treesitter.highlighter, enabled:boolean}>>
local ns = api.nvim_create_namespace 'egrepify.highlighter'

local TSHighlighter = vim.treesitter.highlighter

local function wrap(name)
  return function(_, win, buf, ...)
    if not TSInjector.cache[buf] then return false end
    for _, hl in pairs(TSInjector.cache[buf] or {}) do
      if hl.enabled then
        TSHighlighter.active[buf] = hl.highlighter
        TSHighlighter[name](_, win, buf, ...)
      end
    end
    TSHighlighter.active[buf] = nil
  end
end

TSInjector.did_setup = false
function TSInjector.setup()
  if TSInjector.did_setup then return end
  TSInjector.did_setup = true

  api.nvim_set_decoration_provider(ns, {
    on_win = wrap '_on_win',
    on_line = wrap '_on_line',
  })

  api.nvim_create_autocmd('BufWipeout', {
    group = api.nvim_create_augroup('egrepify.treesitter.hl', { clear = true }),
    callback = function(ev) TSInjector.cache[ev.buf] = nil end,
  })
end

---@param buf number
---@param regions trouble.LangRegions
function TSInjector.attach(buf, regions)
  TSInjector.setup()
  TSInjector.cache[buf] = TSInjector.cache[buf] or {}
  for lang in pairs(TSInjector.cache[buf]) do
    TSInjector.cache[buf][lang].enabled = regions[lang] ~= nil
  end

  for lang in pairs(regions) do
    TSInjector._attach_lang(buf, lang, regions[lang])
  end
end

---@param buf number
---@param lang? string
function TSInjector._attach_lang(buf, lang, regions)
  lang = lang or 'markdown'
  lang = lang == 'markdown' and 'markdown_inline' or lang

  TSInjector.cache[buf] = TSInjector.cache[buf] or {}

  if not TSInjector.cache[buf][lang] then
    local ok, parser = pcall(vim.treesitter.languagetree.new, buf, lang)
    if not ok then return end
    ---@diagnostic disable-next-line: invisible
    parser:set_included_regions(regions)
    TSInjector.cache[buf][lang] = {
      parser = parser,
      highlighter = TSHighlighter.new(parser),
    }
  end
  TSInjector.cache[buf][lang].enabled = true
  local parser = TSInjector.cache[buf][lang].parser

  ---@diagnostic disable-next-line: invisible
  parser:set_included_regions(regions)
end

api.nvim_create_autocmd('FileType', {
  pattern = 'fzf',
  callback = function(args)
    api.nvim_buf_attach(args.buf, false, {
      on_lines = function()
        local lines = api.nvim_buf_get_lines(args.buf, 0, -1, false)
        local regions = {}
        for i = 1, #lines do
          local line_idx = i - 1
          local line = lines[i]
          if starts_with_pattern(line) then
            local path, _, _, text = parse_line(line)
            local ft = vim.filetype.match { filename = path }

            if ft and regions[ft] == nil then regions[ft] = {} end
            if not ft then return end

            if text ~= '' then
              local first_pos = string.find(line, text, 1, true)
              if first_pos == nil then return end
              first_pos = first_pos - 1
              table.insert(regions[ft], { { line_idx, first_pos, line_idx, line:len() } })
              TSInjector.attach(args.buf, regions)
            end
          end
        end
      end,
    })
  end,
})

return {
  { 'phanen/fzf-lua-overlay', main = 'flo', opts = {} },
  {
    'ibhagwan/fzf-lua',
    -- branch = 'dev',
    cmd = 'FzfLua',
    dependencies = 'nvim-treesitter', -- must be setup for preview
    config = function()
      local a = require('flo.actions')
      local f = require('fzf-lua')
      g.fzf_lua_file_actions = {
        ['enter'] = f.actions.file_edit, -- 'default' cannot be overrided by `complete_path`
        ['ctrl-t'] = f.actions.file_tabedit,
        ['ctrl-s'] = f.actions.file_sel_to_qf,
        ['alt-v'] = { fn = f.actions.file_vsplit },
        ['alt-s'] = { fn = f.actions.file_split },
        -- https://github.com/ibhagwan/fzf-lua/issues/1241
        ['alt-q'] = { fn = f.actions.file_sel_to_qf, prefix = 'select-all' },
        ['alt-n'] = a.file_create_open,
        ['ctrl-x'] = { fn = a.file_delete, reload = true },
        ['ctrl-r'] = { fn = a.file_rename, reload = true },
        ['ctrl-y'] = a.yank,
      }
      f.setup {
        'default-title',
        previewers = {
          builtin = {
            extensions = {
              ['png'] = { 'ueberzug' },
              ['jpeg'] = { 'ueberzug' },
              ['gif'] = { 'ueberzug' },
            },
            ueberzug_scaler = 'cover',
          },
          man = { -- use man-db
            cmd = 'man %s | col -bx',
          },
        },
        winopts = { -- 'keep'
          height = 0.7,
          width = 0.9,
          border = g.border,
          backdrop = 100,
          preview = { delay = 50, border = 'noborder' },
        },
        -- easy to see count (but not spinner)
        fzf_opts = { ['--info'] = 'inline' },
        keymap = {
          builtin = {
            ['<a-esc>'] = 'abort',
            ['<esc>'] = 'hide',
            ['<a-;>'] = 'toggle-preview',
            ['<c-d>'] = 'preview-page-down',
            ['<c-u>'] = 'preview-page-up',
            ['<c-l>'] = 'toggle-fullscreen',
          },
          fzf = { -- don't override it anyway
            ['ctrl-q'] = 'toggle-all',
          },
        },
        files = { git_icons = false, no_header_i = true },
        oldfiles = { include_current_session = true },
        grep = { multiprocess = false, file_icons = false, git_icons = false, no_header_i = true }, -- live_grep_glob_st
        lsp = {
          async_or_timeout = 5000,
          jump_to_single_result = true,
          includeDeclaration = false,
          ignore_current_line = true,
          unique_line_items = true,
          code_actions = {
            previewer = fn.executable('delta') == 1 and 'codeaction_native' or 'codeaction',
          },
        },
        git = {
          status = {
            actions = {
              ['ctrl-s'] = { fn = f.actions.git_stage_unstage, reload = true },
              ['ctrl-x'] = { fn = f.actions.git_reset, reload = true },
            },
          },
          bcommits = {
            actions = { ['ctrl-o'] = function(s) vim.cmd.DiffviewOpen(s[1]:match('[^ ]+')) end },
          },
        },
        helptags = { winopts = { preview = { hidden = 'hidden' } } },
        commands = { sort_lastused = true, include_builtin = true, actions = { enter = a.ex_run } },
        spell_suggest = { winopts = { border = 'none', backdrop = false } },
        complete_path = { file_icons = true, previewer = 'builtin' },
        actions = { files = g.fzf_lua_file_actions },
        filetypes = { file_icons = 'mini', color_icons = true },
      }
    end,
  },
}
