local reqcall = require("utils").reqcall

return {
  "anuvyklack/hydra.nvim",
  keys = {
    { "<leader>bb", desc = "hydra: buffer" },
    { "<leader>dh", desc = "hydra: debug" },
    { "<c-w><c-r>", desc = "hydra: window" },
  },
  -- event = 'CursorHold',
  -- 'chentoast/marks.nvim'
  config = function()
    local Hydra = require "hydra"
    local cmd = require("hydra.keymap-util").cmd
    local pcmd = require("hydra.keymap-util").pcmd
    local hint_opts = { position = "bottom", type = "window" }

    local splits = reqcall "smart-splits"
    -- local fold_cycle = reqcall('fold-cycle')
    local dap = reqcall "dap"

    local base_config = function(opts)
      return vim.tbl_extend("force", {
        invoke_on_body = true,
        hint = hint_opts,
        on_enter = function() vim.cmd "silent! BeaconOff" end,
        on_exit = function() vim.cmd "silent! BeaconOn" end,
      }, opts or {})
    end

    local telescope_hint = [[
                 _f_: files       _m_: marks
   🭇🬭🬭🬭🬭🬭🬭🬭🬭🬼    _o_: old files   _g_: live grep
  🭉🭁🭠🭘    🭣🭕🭌🬾   _p_: projects    _/_: search in file
  🭅█ ▁     █🭐
  ██🬿      🭊██   _r_: resume      _u_: undotree
 🭋█🬝🮄🮄🮄🮄🮄🮄🮄🮄🬆█🭀  _h_: vim help    _c_: execute command
 🭤🭒🬺🬹🬱🬭🬭🬭🬭🬵🬹🬹🭝🭙  _k_: keymaps     _;_: commands history
                 _O_: options     _?_: search history
 ^
                 _<Enter>_: Telescope           _<Esc>_
]]

    Hydra {
      name = "Telescope",
      mode = "n",
      -- color = 'teal',
      hint = telescope_hint,
      config = base_config(),
      -- config = {
      --   color = 'teal',
      --   invoke_on_body = true,
      --   hint = {
      --     position = 'middle',
      --     border = 'rounded',
      --   },
      -- },
      body = "<Leader>F",
      heads = {
        { "f", cmd "Telescope find_files" },
        { "g", cmd "Telescope live_grep" },
        { "o", cmd "Telescope oldfiles", { desc = "recently opened files" } },
        { "h", cmd "Telescope help_tags", { desc = "vim help" } },
        { "m", cmd "MarksListBuf", { desc = "marks" } },
        { "k", cmd "Telescope keymaps" },
        { "O", cmd "Telescope vim_options" },
        { "r", cmd "Telescope resume" },
        { "p", cmd "Telescope projects", { desc = "projects" } },
        { "/", cmd "Telescope current_buffer_fuzzy_find", { desc = "search in file" } },
        { "?", cmd "Telescope search_history", { desc = "search history" } },
        { ";", cmd "Telescope command_history", { desc = "command-line history" } },
        { "c", cmd "Telescope commands", { desc = "execute command" } },
        { "u", cmd "silent! %foldopen! | UndotreeToggle", { desc = "undotree" } },
        { "<Enter>", cmd "Telescope", { exit = true, desc = "list all pickers" } },
        { "<Esc>", nil, { exit = true, nowait = true } },
      },
    }

    -- Hydra({
    --   name = 'Folds',
    --   mode = 'n',
    --   body = '<leader>z',
    --   color = 'teal',
    --   config = base_config(),
    --   heads = {
    --     { 'j',     'zj',                 { desc = 'next fold' } },
    --     { 'k',     'zk',                 { desc = 'previous fold' } },
    --     { 'l',     fold_cycle.open_all,  { desc = 'open folds underneath' } },
    --     { 'h',     fold_cycle.close_all, { desc = 'close folds underneath' } },
    --     { '<Esc>', nil,                  { exit = true, desc = 'Quit' } },
    --   },
    -- })

    -- local splits = reqcall('smart-splits')
    -- local fold_cycle = reqcall('fold-cycle')

    Hydra {
      name = "Buffer management",
      mode = "n",
      body = "<leader>bb",
      color = "teal",
      config = base_config(),
      heads = {
        { "f", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" } },
        { "j", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" } },
        { "h", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" } },
        { "k", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" } },
        { "p", "<Cmd>BufferLineTogglePin<CR>", { desc = "Pin buffer" } },
        { "c", "<Cmd>BufferLinePick<CR>", { desc = "Pick buffer" } },
        { "d", "<Cmd>Bdelete!<CR>", { desc = "delete buffer" } },
        { "D", "<Cmd>BufferLinePickClose<CR>", { desc = "Pick close", exit = true } },
        { "<Esc>", nil, { exit = true, desc = "Quit" } },
      },
    }

    -- Hydra({
    --   name = 'Side scroll',
    --   mode = 'n',
    --   body = 'z',
    --   config = base_config({ invoke_on_body = false }),
    --   heads = {
    --     { 'h', '5zh' },
    --     { 'l', '5zl', { desc = '←/→' } },
    --     { 'H', 'zH' },
    --     { 'L', 'zL',  { desc = 'half screen ←/→' } },
    --   },
    -- })

    local dap_hint = [[
 _n_: step over   _s_: Continue/Start   _b_: Breakpoint     _K_: Eval
 _i_: step into   _x_: Quit             ^ ^                 ^ ^
 _o_: step out    _X_: Stop             ^ ^
 _c_: to cursor   _C_: Close UI
 ^
 ^ ^              _q_: exit
]]

    Hydra {
      hint = dap_hint,
      config = {
        color = "pink",
        invoke_on_body = true,
        hint = hint_opts,
      },
      name = "dap",
      mode = { "n", "x" },
      body = "<leader>dh",
      heads = {
        { "n", dap.step_over, { silent = true } },
        { "i", dap.step_into, { silent = true } },
        { "o", dap.step_out, { silent = true } },
        { "c", dap.run_to_cursor, { silent = true } },
        { "s", dap.continue, { silent = true } },
        { "x", function() dap.disconnect { terminateDebuggee = false } end, { exit = true, silent = true } },
        { "X", dap.close, { silent = true } },
        {
          "C",
          ":lua require('dapui').close()<cr>:DapVirtualTextForceRefresh<CR>",
          { silent = true },
        },
        { "b", dap.toggle_breakpoint, { silent = true } },
        { "K", ":lua require('dap.ui.widgets').hover()<CR>", { silent = true } },
        { "q", nil, { exit = true, nowait = true } },
      },
    }

    --   local window_hint = [[
    --  ^^^^^^^^^^^^     Move      ^^    Size   ^^   ^^     Split
    --  ^^^^^^^^^^^^-------------  ^^-----------^^   ^^---------------
    --  ^ ^ _k_ ^ ^  ^ ^ _K_ ^ ^   ^   _<C-k>_   ^   _s_: horizontally
    --  _h_ ^ ^ _l_  _H_ ^ ^ _L_   _<C-h>_ _<C-l>_   _v_: vertically
    --  ^ ^ _j_ ^ ^  ^ ^ _J_ ^ ^   ^   _<C-j>_   ^   _q_, _c_: close
    --  focus^^^^^^  window^^^^^^  ^_=_: equalize^   _o_: remain only
    --  ^ ^ ^ ^ ^ ^  ^ ^ ^ ^ ^ ^   ^^ ^          ^
    -- ]]
    --
    --   Hydra({
    --     name = 'Windows',
    --     hint = window_hint,
    --     config = base_config({ invoke_on_body = false }),
    --     mode = 'n',
    --     body = '<c-w>',
    --     heads = {
    --       --- Move
    --       { 'h',     '<c-w>h' },
    --       { 'j',     '<c-w>j' },
    --       { 'k',     pcmd('wincmd k', 'E11', 'close') },
    --       { 'l',     '<c-w>l' },
    --
    --       { 'o',     '<c-w>o',                              { exit = true, desc = 'remain only' } },
    --       { '<C-o>', '<c-w>o',                              { exit = true, desc = false } },
    --       -- Resize
    --       { '<C-h>', function() splits.resize_left(2) end },
    --       { '<C-j>', function() splits.resize_down(2) end },
    --       { '<C-k>', function() splits.resize_up(2) end },
    --       { '<C-l>', function() splits.resize_right(2) end },
    --       { '=',     '<c-w>=',                              { desc = 'equalize' } },
    --       -- Split
    --       { 's',     pcmd('split', 'E36') },
    --       { '<C-s>', pcmd('split', 'E36'),                  { desc = false } },
    --       { 'v',     pcmd('vsplit', 'E36') },
    --       { '<C-v>', pcmd('vsplit', 'E36'),                 { desc = false } },
    --       -- Size
    --       { 'H',     function() splits.swap_buf_left() end },
    --       { 'J',     function() splits.swap_buf_down() end },
    --       { 'K',     function() splits.swap_buf_up() end },
    --       { 'L',     function() splits.swap_buf_right() end },
    --       { 'c',     pcmd('close', 'E444'),                 { exit = true, desc = 'exit' } },
    --       { 'q',     pcmd('close', 'E444'),                 { desc = 'close window' } },
    --       { '<C-c>', pcmd('close', 'E444'),                 { desc = false } },
    --       { '<C-q>', pcmd('close', 'E444'),                 { desc = false } },
    --       { '<Esc>', nil,                                   { exit = true } },
    --     },
    --   })
  end,
}
