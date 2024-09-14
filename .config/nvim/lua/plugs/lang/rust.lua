return {
  -- rust
  {
    'saecki/crates.nvim',
    event = { 'BufRead Cargo.toml' },
    config = function()
      require('crates').setup()
      local crates = require 'crates'
      local n = map.n[0]
      n('+ct', crates.toggle)
      n('+cr', crates.reload)
      n('+cv', crates.show_versions_popup)
      n('+cf', crates.show_features_popup)
      n('+cd', crates.show_dependencies_popup)
      n('+cu', crates.update_crate)
      n('+ca', crates.update_all_crates)
      n('+cU', crates.upgrade_crate)
      n('+cA', crates.upgrade_all_crates)
      n('+cx', crates.expand_plain_crate_to_inline_table)
      n('+cX', crates.extract_crate_into_table)
      n('+cH', crates.open_homepage)
      n('+cR', crates.open_repository)
      n('+cD', crates.open_documentation)
      n('+cC', crates.open_crates_io)
    end,
  },

  {
    'mrcjkb/rustaceanvim',
    ft = { 'rust' },
    config = function()
      vim.g.rustaceanvim = function()
        return {
          tools = { float_win_config = { border = g.border } },
          dap = {
            adapter = {
              type = 'server',
              port = '${port}',
              host = '127.0.0.1',
              executable = {
                command = 'codelldb',
                args = {
                  '--port',
                  '${port}',
                  '--settings',
                  vim.json.encode { showDisassembly = 'never' },
                },
              },
            },
          },
        }
      end
    end,
  },
}
