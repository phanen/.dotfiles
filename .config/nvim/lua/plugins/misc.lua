return {
  {
    "voldikss/vim-browser-search",
    event = "VeryLazy",
    config = function()
      vim.cmd [[
        vmap <silent> <Leader>s <Plug>SearchVisual
      ]]
    end
    -- keys = {
    --   "<leader>s", mode = { "x" },
    -- }

  },
}
