-- Set leader key to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Square cursor
vim.opt.guicursor = ""

-- Enable relative line number
vim.opt.nu = true
vim.opt.relativenumber = true

-- Enable highlight of CursorLineNr
vim.opt.cursorline = true

-- Set tabs to 4 spaces
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

-- Enable auto indent and set it to 4 spaces
vim.opt.smartindent = true
vim.opt.shiftwidth = 4

-- Disable text wrap
vim.opt.wrap = false

-- Enable persistent undo history
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Set better splitting
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Better search options
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Enable 24-bit color
vim.opt.termguicolors = true

-- Always keep 8 lines above/below cursor unless at start/end of file
vim.opt.scrolloff = 8

-- Decrease uptade time
vim.opt.updatetime = 50
