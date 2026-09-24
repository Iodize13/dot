-- src: https://martinlwx.github.io/en/config-neovim-from-scratch/
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
require('plugins')
require('keymaps')
require('options')
require('colorscheme')
require('lsp')
vim.api.nvim_create_user_command("RecentNotes", function()
    -- Read your recently visited projects from a file (e.g., a history file you maintain)
    -- Or, dynamically find note.md files in a known directory
    
    -- Example hardcoded list (you'll generate this programmatically)
    local note_paths = {
        "/home/user/projectA/note.md",
        "/home/user/projectB/note.md",
        "/tmp/proj-note", -- Your tracking file
    }
    local qf_data = {}
    for _, path in ipairs(note_paths) do
        -- Only add if the file exists
        if vim.fn.filereadable(path) == 1 then
            table.insert(qf_data, {
                filename = path,
                text = "Project Note: " .. vim.fn.fnamemodify(path, ":h:t") -- Shows parent folder name
            })
        end
    end
    if #qf_data > 0 then
        -- Set the quickfix list and open the window
        vim.fn.setqflist(qf_data, 'r')
        vim.cmd("copen 10") -- Open Quickfix window with a height of 10
    else
        print("No recent notes found.")
    end
end, {})
