return {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function()
        local notify = require("notify")

        local filtered_message = { "No information available" }

        -- Override notify function to filter out messages
        ---@diagnostic disable-next-line: duplicate-set-field
        vim.notify = function(message, level, opts)
            local merged_opts = vim.tbl_extend("force", {
                on_open = function(win)
                    local buf = vim.api.nvim_win_get_buf(win)
                    vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
                end,
            }, opts or {})

            for _, msg in ipairs(filtered_message) do
                if message == msg then
                    return
                end
            end
            return notify(message, level, merged_opts)
        end

        ---@diagnostic disable-next-line: missing-fields
        require("notify").setup({
            background_colour = "#000000",
        })

        -- Update colors to use gruvbox colors
        vim.cmd([[
        highlight NotifyERRORBorder guifg=#cc241d
        highlight NotifyERRORIcon guifg=#cc241d
        highlight NotifyERRORTitle  guifg=#cc241d
        highlight NotifyINFOBorder guifg=#8ec07c
        highlight NotifyINFOIcon guifg=#8ec07c
        highlight NotifyINFOTitle guifg=#8ec07c
        highlight NotifyWARNBorder guifg=#fabd2f
        highlight NotifyWARNIcon guifg=#fabd2f
        highlight NotifyWARNTitle guifg=#fabd2f
        ]])
    end,
}
