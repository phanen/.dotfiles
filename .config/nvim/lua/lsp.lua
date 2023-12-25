local lsp = vim.lsp
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local bufnr = ev.buf
    local n = function(lhs, rhs, desc)
      if desc then desc = "lsp: " .. desc end
      map("n", lhs, rhs, { buffer = bufnr, desc = desc })
    end
    n("K", lsp.buf.hover, "hover")
    n("gD", lsp.buf.declaration, "declaration")
    n("gd", lsp.buf.definition, "definition")
    n("gI", lsp.buf.implementation, "implementation")
    n("gr", function() lsp.buf.references { includeDeclaration = false } end, "references")
    n("<leader>rn", lsp.buf.rename, "rename")
    n("<leader>D", lsp.buf.type_definition, "type definition")
    n("<leader>ca", lsp.buf.code_action)
    n("gq", function() lsp.buf.format { async = true } end, "format buffer")
    n("gs", vim.lsp.buf.signature_help, "signature_help")
  end,
})
