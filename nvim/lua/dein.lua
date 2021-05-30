vim.cmd 'set nocompatible'

local dein_dir = vim.env.HOME .. '/.cache/dein'
local dein_repo_dir = dein_dir .. '/repos/github.com/Shougo/dein.vim'

vim.o.runtimepath = dein_repo_dir .. ',' .. vim.o.runtimepath

local dein_toml_dir = vim.env.HOME .. '/.config/nvim/dein'
local toml_base = dein_toml_dir .. '/base.toml'
local toml_lazy = dein_toml_dir .. '/lazy.toml'
local toml_ftplugin = dein_toml_dir .. '/ftplugin.toml'

if vim.call('dein#load_state', dein_dir) == 1 then
    vim.call('dein#begin', dein_dir, {vim.fn.expand('<sfile>'), toml_base, toml_lazy, toml_ftplugin})
    vim.call('dein#load_toml', toml_base, {lazy = 0})
    vim.call('dein#load_toml', toml_lazy, {lazy = 1})
    vim.call('dein#load_toml', toml_ftplugin)
    vim.call('dein#end')
    vim.call('dein#save_state')
end

if vim.call('dein#check_install') == 1 then
    vim.call('dein#install')
    vim.call('dein#remote_plugins')
end

