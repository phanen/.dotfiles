return {
  {
    'Shatur/neovim-session-manager',
    cond = false,
    keys = {
      { '<leader>ss', '<cmd>SessionManager save_current_session<cr>' },
      { '<leader>sl', '<cmd>SessionManager load_session<cr>' },
      { '<leader>sd', '<cmd>SessionManager delete_session<cr>' },
    },
    opts = function()
      return {
        autoload_mode = require('session_manager.config').AutoloadMode.Disabled,
        autosave_last_session = false,
      }
    end,
  },
  {
    'tpope/vim-projectionist',
    cond = false,
    lazy = true,
    -- event = "VeryLazy",
    init = function(self)
      ---@diagnostic disable-next-line: undefined-field
      local cwd = uv.cwd()
      if fn.filereadable(cwd .. '/.projections.json') == 1 then
        require('lazy').load({ plugins = { 'vim-projectionist' } })
      end
      local go_main_template = 'package main'
      vim.g.projectionist_heuristics = {
        ['go.mod'] = {
          ['README.md'] = { type = 'doc' },
          ['go.mod'] = { type = 'dep' },
          ['*.go&!*_test.go'] = {
            alternate = '{}_test.go',
            -- related = "{}_test.go",
            type = 'source',
            template = [[package {file|dirname|basename}]],
          },
          ['*_test.go'] = {
            alternate = '{}.go',
            -- related = "{}.go",
            type = 'test',
            template = [[package {file|dirname|basename}_test]],
          },
          ['cmd/*/main.go'] = {
            type = 'main', -- argument will replace the glob
            template = go_main_template,
            dispatch = 'go run {file|dirname}',
            start = 'go run {file|dirname}',
            make = 'go build {file|dirname}',
          },
          ['main.go'] = {
            -- If this option is provided for a literal filename rather than a glob,
            -- it is used as the default destination of the navigation command when no argument is given.
            type = 'main',
            template = go_main_template,
            dispatch = 'go run {file|dirname}',
            start = 'go run {file|dirname}',
            make = 'go build {file|dirname}',
          },
        },
        ['build.zig'] = {
          ['README.md'] = { type = 'doc' },
          ['build.zig'] = {
            type = 'build',
            alternate = 'build.zig.zon',
          },
          ['build.zig.zon'] = {
            type = 'dep',
            alternate = 'build.zig',
          },
          ['src/main.zig'] = {
            type = 'main',
            template = [[pub fn main() !void {|open}{|close}]],
          },
        },
      }

      -- autocmd("User", {
      -- 	pattern = "ProjectionistDetect",
      -- 	callback = function(ev)
      -- 		vim.notify("[Projections] detect!", vim.log.levels.INFO)
      -- 		vim.print(vim.g.projectionist_file)
      -- 	end,
      -- })

      -- autocmd("User", {
      -- 	pattern = "ProjectionistActivate",
      -- 	callback = function(ev)
      -- 		-- property can be defined
      -- 		-- [root, property_value]
      -- 		fn["projectionist#query"]("property")
      -- 	end,
      -- })
    end,
    ft = { 'go', 'zig' },
    keys = {
      { '<leader>aa', '<cmd>A<cr>' },
      { '<leader>av', '<cmd>AV<cr>' },
    },
  },
}
