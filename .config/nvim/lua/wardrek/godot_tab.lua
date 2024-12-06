-- Change expandtab to false in gdscript files
vim.api.nvim_create_autocmd('BufEnter', {
    group = vim.api.nvim_create_augroup("godot_tab", { clear = true}),
    pattern = '*.gd',
    desc = "Change expandtab to false in gdscript files",
    callback = function()
        vim.opt_local.expandtab = false
    end,
})

