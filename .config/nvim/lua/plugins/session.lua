return {
  {
    "Shatur/neovim-session-manager",
    keys = {
      {
        "<leader>ss",
        "<cmd>SessionManager save_current_session<cr>",
        desc = "save current session",
      },
      {
        "<leader>sl",
        "<cmd>SessionManager load_session<cr>",
        desc = "load last session",
      },
      {
        "<leader>sd",
        "<cmd>SessionManager delete_session<cr>",
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
