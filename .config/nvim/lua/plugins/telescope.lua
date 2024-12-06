return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
            cond = vim.fn.executable("cmake") == 1,
        },
    },
    config = function()
        require("telescope").setup({
            defaults = {
                file_ignore_patterns = {
                    ".git/",
                    ".cache",
                    "%.o",
                    "%.a",
                    "%.out",
                    "%.class",
                    "%.pdf",
                    "%.mkv",
                    "%.mp4",
                    "%.zip",
                    "%.png",
                    "%.jpg",
                    "%.nc",
                    "%.swp",
                    "%.godot/",
                    "%.godot",
                    "%.tscn",
                    "%.wav",
                    "%.ttf",
                    "%.svg",
                },
                hidden = true,
            },
        })

        -- Enable telescope fzf native, if installed
        pcall(require("telescope").load_extension, "fzf")
    end,
}

