vim.bo.include = [=[\v<((do|load)file|require)\s*\(?['"]\zs[^'"]+\ze['"]]=]
vim.bo.includeexpr = 'v:lua.u.nlua.rtp_find_required_path(v:fname)'
