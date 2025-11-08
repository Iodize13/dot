vim.opt.completeopt = {'menu', 'menuone', 'noselect'}
vim.opt.mouse = 'a'                 -- allow the mouse to be used in nvim

-- Tab
vim.opt.shiftwidth = 4              -- insert 4 spaces on a tab

-- UI config
vim.opt.number = true               -- show absolute number
vim.opt.relativenumber = true       -- add numbers to each line on the left side
vim.opt.cursorline = true           -- highlight cursor line underneath the cursor horizontally
vim.opt.splitbelow = true           -- open new vertical split bottom
vim.opt.splitright = true           -- open new horizontal splits right
-- vim.opt.termguicolors = true        -- enable 24-bit RGB color in the TUI
vim.opt.showmode = false            -- we are experienced, wo don't need the "-- INSERT --" mode hint

-- Searching
vim.opt.incsearch = true            -- search as characters are entered
vim.opt.hlsearch = false            -- do not highlight matches
vim.opt.ignorecase = true           -- ignore case in searches by default
vim.opt.smartcase = true            -- but make it case sensitive if an uppercase is entered

vim.opt.guicursor = 'n-v-c-sm-i-ci-ve:block'
vim.opt.makeprg="g++ -Wall -Wconversion -Wshadow -Wfatal-errors -DLOCAL -g -std=c++20 -fsanitize=undefined,address -I/home/ionize13/github.com/competitive-programming/.template -Winvalid-pch -Wl,-z,stack-size=0x100000000 %:r.cpp"
vim.opt.laststatus = 0;

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "note.md",
    command = ":norm Go",
})
