-- src: https://martinlwx.github.io/en/config-neovim-from-scratch/
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
require('options')

vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46_cache/"

require('plugins')
require('keymaps')
require('colorscheme')
require('lsp')

for _, v in ipairs(vim.fn.readdir(vim.g.base46_cache)) do
    dofile(vim.g.base46_cache .. v)
end
