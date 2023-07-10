return {
  "Pocco81/auto-save.nvim",
  config = true,
  event = { "TextChanged"},
}
-- au TextChanged,TextChangedI <buffer> if &readonly == 0 && filereadable(bufname('%')) | silent write | endif
