local n = function(...) map('n', ...) end
-- use some vscode builtin
local vc = function(cmd) return "<cmd>lua require('vscode-neovim').call('" .. cmd .. "')<cr>" end
-- x('<leader>cf', cmd('editor.action.formatSelection'))
-- n('<leader>cf', cmd('prettier.forceFormatDocument'))
n('_', vc('editor.action.showDefinitionPreviewHover'))
n('<leader>cp', vc('editor.action.peekDefinition'))
n('<leader>ch', vc('editor.showCallHierarchy'))
n('<leader>ci', vc('editor.action.peekImplementation'), { desc = 'Peek implementation' })
n('<c-l>', vc('workbench.action.quickOpen'))
-- not work
n('<c-n>', vc('workbench.action.findInFiles'))
n('gh[', vc('workbench.action.editor.previousChange'))
n('gh]', vc('workbench.action.editor.nextChange'))
n('gha', vc('git.stage'), { desc = 'Stage change' })
n('<leader>gs', vc('git.openChange'), { desc = 'Open git changes' })
n('ghb', vc('gitlens.toggleFileBlame'), { desc = 'Toggle file blame' })
n('ghr', vc('git.clean'), { desc = 'Git discard changes' })
n('<leader>gc', vc('git.commit'), { desc = 'Git commit' })
n('<leader>gg', vc('workbench.view.scm'), { desc = 'Show source control' })
