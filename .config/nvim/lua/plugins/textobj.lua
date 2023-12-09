return {
  {
    "glts/vim-textobj-comment",
    dependencies = { { "kana/vim-textobj-user", dependencies = { "kana/vim-operator-user" } } },
    init = function() vim.g.textobj_comment_no_default_key_mappings = 1 end,
    keys = {
      { "ac", "<Plug>(textobj-comment-a)", mode = { "x", "o" } },
      { "ic", "<Plug>(textobj-comment-i)", mode = { "x", "o" } },
    },
  },
  {
    "LeonB/vim-textobj-url",
    dependencies = "kana/vim-textobj-user",
    keys = {
      { "au", mode = { "x", "o" } },
      { "iu", mode = { "x", "o" } },
    },
  },
}
