-- check if vscode
local is_vscode = vim.g.vscode ~= nil

-- background color (Only for terminal nvim)
if not is_vscode then
    vim.cmd [[
        highlight Normal guibg=NONE ctermbg=NONE
        highlight NormalNC guibg=NONE ctermbg=NONE
    ]]
end

-- tab size
vim.o.tabstop = 1 
vim.o.expandtab = true
vim.o.softtabstop = 4 
vim.o.shiftwidth = 4 

-- line numbers
vim.o.number = true
vim.o.relativenumber = true

-- leader
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- plugin loader setup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- no -- MODE --
vim.o.showmode = false

-- plugins
require("lazy").setup({
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {
            vscode = is_vscode,
        },
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
            { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
        },
    },

    {
        "mg979/vim-visual-multi",
        -- enabled = not is_vscode, -- Don't load in VS Code
        branch = "master",
    },

    {
        "nvim-lualine/lualine.nvim",
        enabled = not is_vscode, -- Don't load in VS Code
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup {
                options = {
                    theme = {
                        normal = {
                            a = { fg = "#ffffff", bg = "#222222", gui = "bold" },
                            b = { fg = "#ffffff", bg = "#3c3c3c" },
                            c = { fg = "#ffffff", bg = "#3c3c3c" },
                        },
                        insert = { a = { fg = "#ffffff", bg = "#93d690", gui = "bold" } },
                        visual = { a = { fg = "#ffffff", bg = "#c0b3f6", gui = "bold" } },
                        replace = { a = { fg = "#ffffff", bg = "#d75f5f", gui = "bold" } },
                        command = { a = { fg = "#ffffff", bg = "#af87af", gui = "bold" } },
                        inactive = { a = { fg = "#ffffff", bg = "#2e2e2e" }, b = { fg = "#ffffff", bg = "#2e2e2e" }, c = { fg = "#ffffff", bg = "#2e2e2e" } },
                    },
                },
                sections = {
                    lualine_a = {"mode"},
                    lualine_b = {},
                    lualine_c = {"filename"},
                    lualine_x = {"filetype"},
                    lualine_y = {},
                    lualine_z = {"location"},
                },
            }
        end,
    },

    {
        "numToStr/Comment.nvim",
        enabled = not is_vscode, -- Don't load in VS Code
        opts = {},
        keys = {
            { "<C-/>", function() require("Comment.api").toggle.linewise.current() end, mode = "n" },
            { 
                "<C-/>", 
                function()
                    local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
                    vim.api.nvim_feedkeys(esc, "nx", false)
                    require("Comment.api").toggle.linewise(vim.fn.visualmode())
                end, 
                mode = "v" 
            },
        },
    },
})

-- KEYMAPS

-- yank paste and delete semantics
vim.keymap.set({ "n", "v" }, "y", '"+y')
vim.keymap.set("n", "yy", '"+yy')
vim.keymap.set({ "n", "v" }, "p", '"+p')
vim.keymap.set("n", "P", '"+P')
vim.keymap.set({ "n", "v" }, "d", '"_d')
vim.keymap.set("n", "dd", '"_dd')

vim.api.nvim_set_hl(0, "FlashMatch", { fg = "#000000", bg = "#ffffff", bold = true })
vim.api.nvim_set_hl(0, "FlashLabel", { fg = "#000000", bg = "#ff3333", bold = true })

-- sudo save with w!!
vim.keymap.set("c", "w!!", "w !run0 tee %", { noremap = true })
