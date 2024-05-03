return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    event = "VeryLazy",
    config = function()
        local harpoon = require("harpoon")

        local function truncate_branch_name(branch)
            if not branch or branch == "" then
                return ""
            end

            -- Match the branch name to the specified format
            local _, _, ticket_number = string.find(branch, "skdillon/sko%-(%d+)%-")

            -- If the branch name matches the format, display sko-{ticket_number}, otherwise display the full branch name
            if ticket_number then
                return "sko-" .. ticket_number
            else
                return branch
            end
        end

        local function harpoon_component()
            local harpoon_entries = harpoon:list()
            local root_dir = harpoon_entries.config:get_root_dir()
            local current_file_path = vim.api.nvim_buf_get_name(0)

            local total_marks = harpoon_entries:length()

            if total_marks == 0 then
                return ""
            end

            local current_mark = "-"

            for i =1, total_marks do
                local harpoon_entry = harpoon_entries:get(i)
                local harpoon_path = harpoon_entry.value

                local full_path = nil
                if string.sub(harpoon_path, 1, 1) ~= "/" then
                    full_path = root_dir .. "/" .. harpoon_path
                else
                    full_path = harpoon_path
                end
                if full_path == current_file_path then
                    current_mark = tostring(i)
                end
            end

            return string.format("󱡅 %s/%d", current_mark, total_marks)
        end

        require("lualine").setup({
            options = {
                theme = 'gruvbox-material',
                component_separators = {''},
                -- globalstatus = true,
                section_separators = { left = '', right = ''},
            },
            sections = {
                lualine_a = {'mode'},
                lualine_b = {
                    {
                        "branch",
                        icon = "",
                        fmt = truncate_branch_name
                    },
                    "diff",
                },
                lualine_c = {
                    {
                        'filename',
                        path = 1,
                    },
                    harpoon_component,
                },
                lualine_x = {'diagnostics'},
                lualine_y = {'%l:%c', '%p%% / %L'},
                lualine_z = {"os.date('%H:%M', os.time())"}
            },
            inactive_sections = {
                lualine_c = { '%f %y %m' },
                lualine_x = {},
            },

        })
    end,
}
