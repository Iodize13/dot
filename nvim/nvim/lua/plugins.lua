local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
"git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.supermaven_enabled = true

function ToggleSupermaven()
    local blink = require("blink.cmp")
    local current_sources = blink.config.sources.default
    local has_supermaven = false

    for _, source in ipairs(current_sources) do
        if source == "supermaven" then
            has_supermaven = true
            break
        end
    end

    if has_supermaven then
        blink.config.sources.default = { "lsp", "path", "snippets", "buffer" }
        vim.g.supermaven_enabled = false
        vim.notify("Supermaven disabled", vim.log.levels.INFO)
    else
        blink.config.sources.default = { "lsp", "path", "supermaven", "snippets", "buffer" }
        vim.g.supermaven_enabled = true
        vim.notify("Supermaven enabled", vim.log.levels.INFO)
    end
end

vim.api.nvim_create_user_command("SupermavenToggle", ToggleSupermaven, { desc = "Toggle Supermaven completion" })

package.loaded['cmp'] = { register_source = function() end }

require("lazy").setup({
    {
        "supermaven-inc/supermaven-nvim",
        opts = {
            disable_inline_completion = true,
            disable_keymaps = true,
            ignore_filetypes = { "markdown" },
        },
    },
    {
        "huijiro/blink-cmp-supermaven",
        lazy = true,
    },
    {
        "saghen/blink.cmp",
        -- optional: provides snippets for the snippet source
	dependencies = { "rafamadriz/friendly-snippets" },

        -- Use a release tag to download pre-built binaries
        version = "*",
        -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
        -- build = 'cargo build --release',
        -- If you use Nix, you can build from source using the latest nightly rust with:
        -- build = 'nix run .#build-plugin',

        opts = {
            -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
            -- 'super-tab' for mappings similar to VSCode (tab to accept)
            -- 'enter' for enter to accept
            -- 'none' for no mappings
            --
            -- All presets have the following mappings:
            -- C-space: Open menu or open docs if already open
            -- C-n/C-p or Up/Down: Select next/previous item
            -- C-e: Hide menu
            -- C-k: Toggle signature help (if signature.enabled = true)
            --
            -- See :h blink-cmp-config-keymap for defining your own keymap
            keymap = {
                -- Each keymap may be a list of commands and/or functions
                preset = "super-tab",
                -- Select completions
                ["<Up>"] = { "select_prev", "fallback" },
                ["<Down>"] = { "select_next", "fallback" },
                -- ["<Tab>"] = { "select_next", "fallback" },
                -- ["<S-Tab>"] = { "select_prev", "fallback" },
                -- Scroll documentation
                ["<C-b>"] = { "scroll_documentation_up", "fallback" },
                ["<C-f>"] = { "scroll_documentation_down", "fallback" },
                -- Show/hide signature
                ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
            },

            enabled = function()
                return not vim.tbl_contains({ "org" }, vim.bo.filetype)
            end,

            appearance = {
                -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = "mono",
            },

            -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
            -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
            -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
            --
            -- See the fuzzy documentation for more information
            fuzzy = { implementation = "prefer_rust_with_warning" },
            completion = {
                -- The keyword should only match against the text before
                keyword = { range = "prefix" },
                menu = {
                    -- Use treesitter to highlight the label text for the given list of sources
                    draw = {
                        treesitter = { "lsp" },
                    },
                },
                -- Show completions after typing a trigger character, defined by the source
                trigger = { show_on_trigger_character = true },
                documentation = {
                    -- Show documentation automatically
                    auto_show = true,
                },
            },

            -- Signature help when tying
            signature = { enabled = true },
            sources = {
                default = { "lsp", 'path', "snippets", 'buffer' },
                providers = {
                    supermaven = {
                        name = 'supermaven',
                        module = "blink-cmp-supermaven",
                        async = true,
                    }
                }
            },
        },
        opts_extend = { "sources.default" },
    },
    { "rolv-apneseth/tfm.nvim" },
    { "mason-org/mason.nvim", opts = {} },
    { "nvim-lua/plenary.nvim", lazy = true },
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        opts = {},
    },
    { "motosir/skel-nvim" },
    {
        "folke/trouble.nvim",
        opts = {}, -- for default options, refer to the configuration section for custom setup.
        cmd = "Trouble",
    },
    { "nvim-telescope/telescope.nvim" },
    { "mhartington/formatter.nvim" },
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" }
    },
    { "windwp/nvim-ts-autotag" },
    { "nvim-treesitter/nvim-treesitter",
	branch = 'master',
    	lazy = false,
	build = ":TSUpdate"
    },
    {
	'derektata/lorem.nvim',
	config = function()
	    require("lorem").opts {
		sentence_length = "mixed", -- using a default configuration
		comma_chance = 0.3, -- 30% chance to insert a comma
		max_commas = 2, -- maximum 2 commas per sentence
		debounce_ms = 200, -- default debounce time in milliseconds
	    }
	end
    },
    {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
	dependencies = {
	    "nvim-tree/nvim-web-devicons",
	},
	config = function()
	    require("nvim-tree").setup {}
	end,
    }, {
	"xiyaowong/transparent.nvim", lazy = false,
    }, {
	"akinsho/toggleterm.nvim", version = "*", config = true
    },
    { 'akinsho/git-conflict.nvim', version = "*", config = true },
    { 'lewis6991/gitsigns.nvim' },
    { 
	'nvim-lualine/lualine.nvim',
	dependencies = { 'nvim-tree/nvim-web-devicons' }
    },
    -- { 'shaunsingh/nord.nvim'},
    { "ellisonleao/gruvbox.nvim", priority = 1000 , config = true, opts = ...},
    { "echasnovski/mini.align", version = false, opts = {} },
    {
	'nvim-orgmode/orgmode',
	ft = 'org',
	config = function() require('orgmode').setup({}) end,
    },
    {
	'nvim-orgmode/org-bullets.nvim',
	ft = 'org',
	opts = {
	    concealcursor = false, -- เห็น * จริงเมื่อ cursor อยู่บรรทัดนั้น
	    symbols = {
		list = '•',
		headlines = { '◉', '○', '✸', '✿' },
	    },
	},
    },
})

require("skel-nvim").setup{
    templates_dir = vim.fn.expand("$HOME") .. "/github.com/competitive-programming/.template",
    mappings = {
        ['*.cpp'] = "cftemplate.cpp",
    },

}

require('formatter').setup({
  logging = false,
  filetype = {
    javascript = {
	require("formatter.defaults.prettierd")
    },
    typescript = {
	require("formatter.defaults.prettierd")
    },
    javascriptreact = {
	require("formatter.defaults.prettierd")
    },
    typescriptreact = {
	require("formatter.defaults.prettierd")
    },
  }
})

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
augroup("__formatter__", { clear = true })
autocmd("BufWritePost", {
	group = "__formatter__",
	command = ":FormatWrite",
})


require('nvim-ts-autotag').setup({
  opts = {
    -- Defaults
    enable_close = true, -- Auto close tags
    enable_rename = true, -- Auto rename pairs of tags
    enable_close_on_slash = false -- Auto close on trailing </
  },
})

require("toggleterm").setup{}

require('lualine').setup {
  options = {
    theme = 'nord',
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
  },
  inactive_sections = {
    lualine_c = {'filename'},
  },
}

-- Define custom highlight groups for git-conflict
vim.api.nvim_set_hl(0, 'GitConflictIncoming', { bg = '#90EE90', fg = '#000000' })  -- Light green background, black foreground
vim.api.nvim_set_hl(0, 'GitConflictCurrent', { bg = '#9370DB', fg = '#000000' })   -- Purple background, black foreground

require('git-conflict').setup {
  highlights = {
    incoming = 'GitConflictIncoming',
    current = 'GitConflictCurrent',
  }
}

vim.api.nvim_set_hl(0, 'GitSignsCurrentLineBlame', { fg = '#928374', italic = true })

require('gitsigns').setup {
  current_line_blame = true,
  current_line_blame_opts = {
    delay = 300,
  },
  on_attach = function(bufnr)
    local gitsigns = require('gitsigns')
    local function map(mode, l, r, desc)
      vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
    end

    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(gitsigns.next_hunk)
      return '<Ignore>'
    end, 'Next hunk')

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(gitsigns.prev_hunk)
      return '<Ignore>'
    end, 'Prev hunk')

    map('n', '<leader>gb', gitsigns.toggle_current_line_blame, 'Toggle line blame')
    map('n', '<leader>gB', function() gitsigns.blame_line({ full = true }) end, 'Blame line (full)')
    map('n', '<leader>gp', gitsigns.preview_hunk, 'Preview hunk')
    map('n', '<leader>gr', gitsigns.reset_hunk, 'Reset hunk')
    map('n', '<leader>gs', gitsigns.stage_hunk, 'Stage hunk')
  end,
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'org',
  callback = function()
    local org = require('orgmode')

    local function is_list_item(line)
      return line:match('^%s+[-+*]%s')   -- list ที่มี indent (รวม * ที่ indent)
	or line:match('^[-+]%s')         -- list ระดับบนสุด
	or line:match('^%s*%d+[.)]%s')   -- ordered list
    end

    -- Ctrl+Enter / Alt+Enter: item หรือ heading ใหม่ ระดับเดียวกัน
    local function same_level()
      org.action('org_mappings.meta_return')
    end

    -- (Alt/Ctrl)+Shift+Enter: TODO heading ระดับเดียวกัน
    -- ถ้าอยู่บน list item จะได้ checkbox แทน
    local function same_level_todo()
      local line = vim.api.nvim_get_current_line()
      if is_list_item(line) then
	org.action('org_mappings.meta_return')
	vim.schedule(function()
	  local new = vim.api.nvim_get_current_line()
	  if not new:match('%[.%]') then
	    local row = vim.api.nvim_win_get_cursor(0)[1]
	    vim.api.nvim_set_current_line(new .. '[ ] ')
	    vim.api.nvim_win_set_cursor(0, { row, #new + 4 })
	  end
	end)
      else
	org.action('org_mappings.insert_todo_heading')
      end
    end

    local opts = { buffer = true }
    vim.keymap.set({ 'i', 'n' }, '<C-CR>', same_level, opts)
    vim.keymap.set({ 'i', 'n' }, '<M-CR>', same_level, opts)
    vim.keymap.set({ 'i', 'n' }, '<C-S-CR>', same_level_todo, opts)
    vim.keymap.set({ 'i', 'n' }, '<M-S-CR>', same_level_todo, opts)
  end,
})
