local nnoremap = require("wardrek.keymap_utils").nnoremap
local vnoremap = require("wardrek.keymap_utils").vnoremap
local inoremap = require("wardrek.keymap_utils").inoremap
local tnoremap = require("wardrek.keymap_utils").tnoremap
local xnoremap = require("wardrek.keymap_utils").xnoremap

local M = {}

-- Disable Space bar since it'll be used as the leader key
nnoremap("<space>", "<nop>")
vnoremap("<space>", "<nop>")

-- Tmux fuzzy find
nnoremap("<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- Open file tree
-- nnoremap("<leader>e", vim.cmd.Ex)
nnoremap("<leader>e", '<cmd>Neotree reveal<cr>')
nnoremap("<leader>gt", '<cmd>Neotree git_status<cr>')

-- Center buffer while navigating
nnoremap("J", "mzJ`z")
nnoremap("<C-d>", "<C-d>zz")
nnoremap("<C-u>", "<C-u>zz")
nnoremap("n", "nzzzv")
nnoremap("N", "Nzzzv")
nnoremap("G", "Gzz")
nnoremap("gg", "ggzz")

-- Paste without deleting what's in the yank
xnoremap("<leader>p", [["_dP]])

-- Copy the selection in the clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
nnoremap("<leader>Y", [["+Y]])

-- Delete without yank
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- Remap <C-c> to esc to avoid weird interaction
inoremap("<C-c>", "<Esc>")

-- <leader>s for quick find/replace for the word under the cursor
nnoremap("<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- <leader>x for quich cmod +x current file
nnoremap("<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- exit insert mode
inoremap("jk", "<Esc>")

-- exit terminal mode
tnoremap("<c-c>", "<C-\\><C-n>")

-- Exit insert mode after creating a new line above or below the current line.
nnoremap("o", "o<Esc>")
nnoremap("O", "O<Esc>")

-- Navigate the split view easier by pressing CTRL+j, CTRL+k, CTRL+h, or CTRL+l.
-- nnoremap("<c-j>", "<c-w>j")
-- nnoremap("<c-k>", "<c-w>k")
-- nnoremap("<c-h>", "<c-w>h")
-- nnoremap("<c-l>", "<c-w>l")

-- Resize split windows using arrow keys by pressing:
-- CTRL+UP, CTRL+DOWN, CTRL+LEFT, or CTRL+RIGHT.
nnoremap("<c-up>", "<c-w>+")
nnoremap("<c-down>", "<c-w>-")
nnoremap("<c-left>", "<c-w>>")
nnoremap("<c-right>", "<c-w><")

-- Goto next diagnostic of any severity
nnoremap("]d", function()
    vim.diagnostic.jump({count = 1})
    vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Goto prev diagnostic of any severity
nnoremap("[d", function()
    vim.diagnostic.jump({count = -1})
    vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Goto next error diagnostic
nnoremap("]e", function()
    vim.diagnostic.jump({count = 1, severity = vim.diagnostic.severity.ERROR})
    vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Goto previous error diagnostic
nnoremap("[e", function()
    vim.diagnostic.jump({count = -1, severity = vim.diagnostic.severity.ERROR})
    vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Goto next warning diagnostic
nnoremap("]w", function()
    vim.diagnostic.jump({count = 1, severity = vim.diagnostic.severity.WARN})
    vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Goto previous warning diagnostic
nnoremap("[w", function()
    vim.diagnostic.jump({count = -1, severity = vim.diagnostic.severity.WARN})
    vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Open diagnostic window
nnoremap("<leader>d", function()
    vim.diagnostic.open_float({
        border = "rounded",
    })
end)

-- <leader>f to format
nnoremap("<leader>f", ":Format<cr>")

-- Move selected text up/down in visual mode
vnoremap("<A-j>", ":m '>+1<CR>gv=gv")
vnoremap("<A-k>", ":m '<-2<CR>gv=gv")

-- Reselect the last visual selection
xnoremap("<", function()
    vim.cmd("normal! <")
    vim.cmd("normal! gv")
end)

xnoremap(">", function()
    vim.cmd("normal! >")
    vim.cmd("normal! gv")
end)

-- Characters/Words/Lines count
nnoremap("<leader>cc", "<cmd>!wc -m %<cr>")
nnoremap("<leader>cw", "<cmd>!wc -w %<cr>")
nnoremap("<leader>cl", "<cmd>!wc -l %<cr>")

-- Plugins remap --

-- Telescope
local telescope = require('telescope.builtin')
nnoremap('<leader>fp',
    "<cmd>lua require('telescope.builtin').find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<cr>",
    {})
nnoremap('<leader>fg', telescope.git_files, {})
nnoremap('<leader>fb', telescope.buffers, {})
nnoremap('<leader>fr', telescope.oldfiles, {})
nnoremap('<leader>fl', telescope.current_buffer_fuzzy_find, {})
nnoremap('<leader>fh', telescope.help_tags, {})

-- Treesitter
local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
-- vim way: ; goes the direcation you were moving
vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
-- Make builtin f, F, t, T also repeatable with ; and ,
vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })

-- Trouble
nnoremap('<leader>tt', "<cmd>Trouble diagnostics toggle<cr>")
nnoremap('<leader>td', "<cmd>Trouble todo toggle<cr>")

-- FIX: jumpings
-- Trouble: jumpings
vim.keymap.set("n", "]t", function()
    require("trouble").next({ skip_groups = true, jump = true })
end, {})

vim.keymap.set("n", "[t", function()
    require("trouble").prev({ skip_groups = true, jump = true })
end, {})

-- Todo-comment
nnoremap('<leader>ft', '<cmd>TodoTelescope<cr>', {})


-- Harpoon
local harpoon = require("harpoon")

-- Open harpoon ui
nnoremap('<leader>ho', function()
    harpoon.ui:toggle_quick_menu(harpoon:list())
end)

-- Add current file to harpoon
nnoremap("<leader>ha", function()
    harpoon:list():add()
end)

-- Quickly jump to harpooned files
for i = 1,9 do
    nnoremap("<leader>" .. i, function()
        harpoon:list():select(i)
    end)
end

-- Neogit
local neogit = require('neogit')
nnoremap("<leader>gs", neogit.open)
nnoremap("<leader>gc", ":Neogit commit<cr>")
nnoremap("<leader>gp", ":Neogit pull<cr>")
nnoremap("<leader>gP", ":Neogit push<cr>")
nnoremap("<leader>gb", ":Telescope git_branches<cr>")

-- Gitsigns --
M.map_gitsigns_keybinds = function(buffer_number)
    local gs = package.loaded.gitsigns
    -- Navigation
    nnoremap(']h', function()
        if vim.wo.diff then return ']h' end
        vim.schedule(function() gs.next_hunk() end)
        return '<Ignore>'
    end, { expr = true, buffer = buffer_number })

    nnoremap('[h', function()
        if vim.wo.diff then return '[h' end
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
    end, { expr = true, buffer = buffer_number })

    -- Actions --

    -- Stage hunk
    nnoremap('<leader>hs', gs.stage_hunk, { buffer = buffer_number })
    vnoremap('<leader>hs', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
        { buffer = buffer_number })
    -- Stage buffer
    nnoremap('<leader>hS', gs.stage_buffer, { buffer = buffer_number })
    -- Undo stage hunk
    nnoremap('<leader>hu', gs.undo_stage_hunk, { buffer = buffer_number })
    -- Reset hunk
    nnoremap('<leader>hr', gs.reset_hunk, { buffer = buffer_number })
    vnoremap('<leader>hr', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
        { buffer = buffer_number })
    -- Reset buffer
    nnoremap('<leader>hR', gs.reset_buffer, { buffer = buffer_number })
    -- Preview hunk
    nnoremap('<leader>hp', gs.preview_hunk, { buffer = buffer_number })
end

-- Undotree
nnoremap("<leader>u", vim.cmd.UndotreeToggle)

-- LSP Keybinds (exports a function to be used in ../../after/plugin/lsp.lua
-- b/c we need a reference to the current buffer)
M.map_lsp_keybinds = function(buffer_number)
    -- Rename variable
    nnoremap("<leader>rn", vim.lsp.buf.rename, { desc = "LSP: [R]e[n]ame", buffer = buffer_number })

    -- LSP code action
    nnoremap("<leader>ca", vim.lsp.buf.code_action, { desc = "LSP: [C]ode [A]ction", buffer = buffer_number })

    -- Goto definition
    nnoremap("gd", vim.lsp.buf.definition, { desc = "LSP: [G]oto [D]efinition", buffer = buffer_number })

    -- Telescope LSP keybinds --
    -- Goto reference
    nnoremap(
        "gr",
        require("telescope.builtin").lsp_references,
        { desc = "LSP: [G]oto [R]eferences", buffer = buffer_number }
    )

    -- Goto implementation
    nnoremap(
        "gi",
        require("telescope.builtin").lsp_implementations,
        { desc = "LSP: [G]oto [I]mplementation", buffer = buffer_number }
    )

    -- List of symbols in the current buffer
    nnoremap(
        "<leader>bs",
        require("telescope.builtin").lsp_document_symbols,
        { desc = "LSP: [B]uffer [S]ymbols", buffer = buffer_number }
    )

    -- List of symbols in the workspace
    nnoremap(
        "<leader>ps",
        require("telescope.builtin").lsp_workspace_symbols,
        { desc = "LSP: [P]roject [S]ymbols", buffer = buffer_number }
    )

    -- Hover documentation
    nnoremap("K", function()
                    vim.lsp.buf.hover({border = "rounded", max_height = 25})
                  end,
            { desc = "LSP: Hover Documentation", buffer = buffer_number })

    -- Signature documentation
    nnoremap("<leader>k", vim.lsp.buf.signature_help, { desc = "LSP: Signature Documentation", buffer = buffer_number })
    inoremap("<C-k>", vim.lsp.buf.signature_help, { desc = "LSP: Signature Documentation", buffer = buffer_number })

    -- Goto declaration
    nnoremap("gD", vim.lsp.buf.declaration, { desc = "LSP: [G]oto [D]eclaration", buffer = buffer_number })

    -- Type definition
    nnoremap("td", vim.lsp.buf.type_definition, { desc = "LSP: [T]ype [D]efinition", buffer = buffer_number })
end

return M
