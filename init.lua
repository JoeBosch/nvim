-- OPTIONS
local o = vim.o
local a = vim.api
local g = vim.g

o.tabstop = 4
o.expandtab = true
o.shiftwidth = 4
o.autoindent = true
o.smartindent = true
o.smarttab = true

o.number = true
o.relativenumber = true
o.cursorline = true
o.signcolumn = "yes"
o.scrolloff = 8
o.sidescrolloff = 8
o.showcmd = true

o.swapfile = false
o.backup = false
o.undodir = os.getenv("HOME") .. "/.config/nvim/undodir"
o.undofile = true

o.hlsearch = true
o.incsearch = true
o.ignorecase = true
o.smartcase = true

o.termguicolors = true
vim.cmd.colorscheme("habamax")
a.nvim_set_hl(0, "Normal", { bg = "none" })
a.nvim_set_hl(0, "NormalNC", { bg = "none" })
a.nvim_set_hl(0, "NormalFloat", { bg = "none" })
a.nvim_set_hl(0, "FloatBorder", { bg = "none" })

o.clipboard = "unnamedplus"
o.updatetime = 300
o.pumheight = 6

o.guifont = "Firacode Nerd Font Mono:h17"

-- KEYMAPS
local keymap = vim.keymap.set
local keymap_opts = { noremap = true, silent = true }
keymap("", "<Space>", "<Nop>", keymap_opts)
g.mapleader = " "
g.maplocalleader = " "

--Unbind Mouse
o.mouse = "a"
local mouse_actions = { '<ScrollWheelUp>', '<ScrollWheelDown>', '<C-ScrollWheelUp>', '<C-ScrollWheelDown>', '<S-ScrollWheelUp>', '<S-ScrollWheelDown>', '<A-ScrollWheelUp>', '<A-ScrollWheelDown>', '<LeftMouse>', '<RightMouse>', '<MiddleMouse>' }
for _, bind in ipairs(mouse_actions) do
    keymap({"n","v","i"}, bind, "<Nop>", { silent = true })
end

--Disable Marks
keymap({"n","v","o"}, "m", "<Nop>", keymap_opts)
keymap({"n","v","o"}, "'", "<Nop>", keymap_opts)
keymap({"n","v","o"}, "`", "<Nop>", keymap_opts)

--Staging movement maps
keymap({"n","v","o"}, "<Plug>H", "h", {})
keymap({"n","v","o"}, "<Plug>J", "j", {})
keymap({"n","v","o"}, "<Plug>K", "k", {})
keymap({"n","v","o"}, "<Plug>L", "l", {})

--New movement maps
keymap("", "h", "<Nop>", keymap_opts)
keymap({"n","v","o"}, "j", "<Plug>H", keymap_opts)
keymap({"n","v","o"}, "k", "<Plug>J", keymap_opts)
keymap({"n","v","o"}, "l", "<Plug>K", keymap_opts)
keymap({"n","v","o"}, ";", "<Plug>L", keymap_opts)

--Repeat remap
keymap("n", "'", ";", keymap_opts)
keymap("n", '"', ",", keymap_opts)
keymap("v", "'", ":normal! ;<CR>", keymap_opts)
keymap("v", '"', ":normal! ,<CR>", keymap_opts)
keymap("o", "'", ";", keymap_opts)
keymap("o", '"', ",", keymap_opts)

--File Navigation
keymap("n", "<leader>pv", vim.cmd.Ex)


--Move line
keymap("v", "K", ":m '>+1<CR>gv=gv")
keymap("v", "L", ":m '<-2<CR>gv=gv")

--Combine lines
keymap('n', 'J', function()
    local col = vim.fn.col('.')
    vim.cmd('normal! J')
    vim.fn.cursor(vim.fn.line('.'), col)
end, keymap_opts)
--Move and center
keymap('n', 'K', '<C-d>zz')
keymap('n', 'L', '<C-u>zz')
keymap('n', 'n', 'nzzzv')
keymap('n', 'N', 'Nzzzv')

--Indent paragraph
keymap('n', '=ap', function()
    local row, col = unpack(a.nvim_win_get_cursor(0))
    local line = a.nvim_buf_get_lines(0,row-1,row,false)[1]
    local first_nonblank = line:find('%S') or 1
    local rel_col = col - (first_nonblank - 1)
    vim.cmd('normal! =ap')
    local new_line = a.nvim_buf_get_lines(0,row - 1, row, false)[1]
    local new_first_nonblank = new_line:find('%S') or 1
    local new_col = math.min(new_first_nonblank + rel_col - 1, #new_line)
    a.nvim_win_set_cursor(0, {row, new_col})
end, keymap_opts)

--Replace without copy
keymap('x', '<leader>p', [["_dP]])

--Copy to clipboard
keymap({'n','v'},"<leader>y", [["+y]])
keymap({'n','v'},"<leader>Y", [["+Y]])

--Delete without copy
keymap({'n','v'},"<leader>d", "\"_d")

keymap('n', 'Q', '<Nop>')

--Move to next and prev on list
keymap('n', '<C-k>', '<cmd>cnext<CR>zz')
keymap('n', '<C-l>', '<cmd>cprev<CR>zz')
keymap('n', '<leader>k', '<cmd>lnext<CR>zz')
keymap('n', '<leader>l', '<cmd>lprev<CR>zz')

--Search and replace current word
keymap('n', '<leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

--Remove highlights
keymap('n', '<leader>q', ':nohlsearch<CR>', keymap_opts)
keymap('n', '<leader>w', ':w<CR>', keymap_opts)
keymap('n', '<leader>uu', ':undo<CR>', keymap_opts)


-- Plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    "nvim-lua/plenary.nvim",
    "neovim/nvim-lspconfig",
    "mason-org/mason.nvim",
    "mason-org/mason-lspconfig.nvim",
    { "saghen/blink.cmp", version = "1.*" },
    { "nvim-treesitter/nvim-treesitter", lazy = false, build = ":TSUpdate" },
    "nvim-tree/nvim-web-devicons",
    "otavioschwanck/arrow.nvim",
    "folke/snacks.nvim",
    "mikavilpas/yazi.nvim"
})

require("blink.cmp").setup({
    keymap = {
        preset = 'none',
        ['<Tab>'] = { 'select_next', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'fallback' },
        ['<CR>'] = { 'accept', 'fallback' },
        ['<S-CR>'] = { 'hide', 'fallback' },
        ['<C-Tab'] = { 'show_documentation', 'hide_documentation', 'fallback' }
    },
})

require("mason").setup()
local lspconfig = require("lspconfig")
require("mason-lspconfig").setup({
    ensure_installed = { "basedpyright", "ruff" },
    handlers = {
        ["basedpyright"] = function()
            lspconfig.basedpyright.setup({
                capabilities = require("blink.cmp").get_lsp_capabilities(),
                settings = {
                    basedpyright = {
                        analysis = {
                            extraPaths = {
                                "./deployable/monolith/src/.venv3/lib/python3.7/site-packages",
                                "./identity2/rpc",
                                "./toolbox2/executor",
                                "./platform/protcol",
                            },
                            typeCheckingMode = "basic",
                            useLibraryCodeForTypes = true,
                            autoImportCompletions = true,
                            reportUnusedVariable = "none",
                            reportUnusedImport = "none",
                            reportDuplicateImport = "none",
                            reportUnusedClass = "none",
                            reportUnusedFunction = "none",
                            reportUnusedCoroutine = "none",
                        }
                    }
                }
            })
        end,

        ["ruff"] = function()
            lspconfig.ruff.setup({
                capabilities = require("blink.cmp").get_lsp_capabilities(),
                init_options = {
                    settings = {
                        lineLength = 120,
                        configurationPreference = "filesystemFirst",
                        organizeImports = true,
                        fixAll = true,
                    }
                },
                on_attach = function(client, bufnr)
                    client.server_capabilities.hoverProvider = false
                end,
            })
        end,
    }
})

require("nvim-treesitter.configs").setup({
    indent = { enable = true },
    highlight = { enable = true, additional_vim_regex_highlighting = false },
})

require("arrow").setup({
    leader_key = 'm',
    buffer_leader_key = ',',
    show_icons = true,
    seperate_by_branch = true,
    hide_handbook = true,
    hide_buffer_handbook = true,
})

require("snacks").setup({
    picker = {
        enabled = true,
        win = {
            input = {
                keys = {
                    ['<Esc>'] = { 'cancel', mode = { 'n','i' }},
                    ['<CR>'] = { 'confirm', mode = { 'n','i' }},
                    ['<Tab>'] = {'list_down', mode = { 'n','i' }},
                    ['<S-Tab>'] = {'list_up', mode = { 'n','i' }},
                }
            }
        },
    }
})

local exclude_tests = true

keymap('n', '<leader>ft', function ()
    exclude_tests = not exclude_tests
    vim.notify(exclude_tests and "Excluding tests" or "Including all files", vim.log.levels.INFO)
end)
keymap('n', '<leader>ff', function() require("snacks.picker").smart({ 
    ignore_patterns = function()
        if exclude_tests then
            return {
                ".*test.*",
            }
        else
            return {}
        end
    end
}) end)
keymap('n', '<leader>fz', function() require("snacks.picker").grep({ file_ignore_patterns = cur_patterns }) end)
keymap('n', '<leader>gd', function() require("snacks.picker").lsp_definitions({ file_ignore_patterns = cur_patterns }) end)
keymap('n', '<leader>gr', function() require("snacks.picker").lsp_references({ file_ignore_patterns = cur_patterns }) end)
keymap('n', '<leader>e', function() require("snacks.picker").diagnostics() end)

vim.diagnostic.config({
    underline = false,
})

require("yazi").setup({
    open_for_directories = true,
    keymaps = false,
})
