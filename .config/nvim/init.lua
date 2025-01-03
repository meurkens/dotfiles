vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.clipboard = "unnamedplus"
vim.o.termguicolors = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.signcolumn = "yes"
vim.o.updatetime = 250
vim.o.scrolloff = 5

vim.g.mapleader = ","
vim.g.maplocalleader = ","

vim.wo.number = true

vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("n", "<leader>q", ":q<CR>")
vim.keymap.set("n", "<leader>/", ":nohl<CR>")
vim.keymap.set("n", "<leader>cc", ":e ~/.config/nvim/init.lua<CR>")
vim.keymap.set("n", "<leader>cp", ":e ~/.config/nvim/lua/plugins.lua<CR>")

vim.api.nvim_create_user_command('RenameFile', function(args)
  local current_file = vim.fn.expand('%:p')
  local current_dir = vim.fn.expand('%:h')
  local new_name = args.args
  local new_path = current_dir .. '/' .. new_name
  vim.cmd('silent! !mv ' .. current_file .. ' ' .. new_path)
  vim.cmd('edit ' .. new_path)
  vim.cmd('silent! bwipeout #')
end, { nargs = 1 })

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

require("lazy").setup("plugins", {})
