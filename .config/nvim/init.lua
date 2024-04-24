vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.clipboard = "unnamedplus"
vim.g.mapleader = ","

vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("n", "<leader>q", ":q<CR>")
vim.keymap.set("n", "<leader>/", ":nohl<CR>")

vim.wo.number = true

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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

local plugins = {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>t", builtin.find_files, {})
      vim.keymap.set("n", "<leader>r", builtin.live_grep, {})
      vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = { "lua", "vim", "vimdoc", "query", "javascript", "html", "css", "ruby" },
        sync_install = false,
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
  {
    "numToStr/Comment.nvim",
    opts = {
      toggler = { line = "<leader>d" },
      opleader = { line = "<leader>d" },
    },
    lazy = false,
  },
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls" },
        automatic_installation = true,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      lspconfig.lua_ls.setup({})

      local opts = {}
      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
      vim.keymap.set("n", "<leader>F", function()
        vim.lsp.buf.format({ async = true })
      end, opts)
    end,
  },
  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
        formatters_by_ft = {
          javascript = { { "prettierd", "prettier" } },
          html = { { "prettierd", "prettier" } },
          scss = { "stylelint" },
          lua = { "stylua" },
          -- css = { "prettierd", "stylelint" }
        },
        formatters = {
          stylua = {
            prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
          },
        },
      })
    end,
  },
  {
    "echasnovski/mini.base16",
    config = function()
      vim.cmd("highlight! link @markup.heading.1.markdown Label")
      vim.cmd("highlight! link @markup.heading.2.markdown Boolean")
      vim.cmd("highlight! link @markup.heading.3.markdown Keyword")
      vim.cmd("highlight! link @markup.heading.4.markdown String")
      vim.cmd("highlight! link @markup.heading.5.markdown Statusline")
      vim.cmd("highlight! link @markup.heading.6.markdown Statusline")

      require("mini.base16").setup({
        palette = require("mini.base16").mini_palette("#000000", "#ffffff", 75),
        use_cterm = {
          base00 = 0,  -- background
          base01 = 0,  -- linenumber background
          base02 = 8,  -- background statusline
          base03 = 10, -- linenumbers, comments
          base04 = 12, -- statusline
          base05 = 15, -- variable names, equality signs
          base06 = 5,  -- unknown?
          base07 = 5,  -- unknown?
          base08 = 12, -- map keys
          base09 = 13, -- booleans, integer literals
          base0A = 2,  -- html
          base0B = 4,  -- string literals
          base0C = 6,  -- require, curly brackets
          base0D = 13, -- function calls
          base0E = 3,  -- keywords
          base0F = 7,  -- commas, brackets
        },
      })
    end,
  },
}

require("lazy").setup(plugins, {})

-- vim.cmd('source ~/.config/nvim/noctu.vim')
