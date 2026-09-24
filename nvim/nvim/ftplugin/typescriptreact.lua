-- Tab
vim.opt.shiftwidth = 2              -- insert 4 spaces on a tab

-- Fold
vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr = "v:lua.vim.lsp.foldexpr()"
