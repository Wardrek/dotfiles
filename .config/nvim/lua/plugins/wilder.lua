return {
    "gelguy/wilder.nvim",
    keys = {
        ":",
        "/",
        "?",
    },
    config = function()
        local wilder = require("wilder")

        -- Enable wilder when pressing :, / or ?
        wilder.setup({
            modes = { ":", "/", "?" },
            next_key = '<Tab>',
            previous_key = '<S-Tab>',
            accept_key = '<c-space>',
            reject_key = '<c-e>',
        })

        -- Enable fuzzy matching for commands and buffers
        wilder.set_option("pipeline", {
            wilder.branch(
                wilder.cmdline_pipeline({
                    fuzzy = 1,
                }),
                wilder.vim_search_pipeline({
                    fuzzy = 1,
                })
            ),
        })

        wilder.set_option(
            "renderer",
            wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
                highlighter = wilder.basic_highlighter(),
                pumblend = 40,
                min_width = "20%",
                max_width = "50%",
                min_height = "0%",
                max_height = "50%",
                border = "rounded",
                left = { " ", wilder.popupmenu_devicons() },
            }))
        )
    end,
}
