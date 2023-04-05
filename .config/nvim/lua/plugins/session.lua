return {
  {
    "Shatur/neovim-session-manager",
    keys = {
      {
        "<leader>ss",
        "<cmd>SessionManager save_current_session<CR>",
        desc = "save current session",
      },
      {
        "<leader>sl",
        "<cmd>SessionManager load_last_session<CR>",
        desc = "load last session",
      },
      {
        "<leader>sc",
        "<cmd>SessionManager load_session<CR>",
        desc = "load session"
      },
      {
        "<leader>sd",
        "<cmd>SessionManager delete_session<CR>",
        desc = "delete session"
      },
    },
    opts = function()
      return {
        autoload_mode = require("session_manager.config").AutoloadMode.Disabled,
        autosave_last_session = false,
      }
    end,
  },
}
