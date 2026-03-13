print("CONFIG IS LOADED?!")

vim.loader.enable()

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Cursor is always thick
vim.opt.guicursor = ""

-- Display eol, tabs and trailing spaces
-- Tabs: ▸
vim.opt.listchars = { eol = "↲", tab = "  ", trail = "·" }
vim.opt.list = true

-- Always display sign column
vim.opt.signcolumn = "yes"

-- Ignore case for searching with /
vim.opt.ignorecase = true

-- 100 character line
vim.opt.colorcolumn = "120"

-- Line Numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- Indenting and Wrap
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false

-- Undo Tree instead of Backups
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.updatetime = 50

-------------
-- Keymaps --
-------------

-- Yank to system clipboard
vim.keymap.set("v", "<leader>y", '"+y')

-- Redo remap
vim.keymap.set("n", "U", "<C-r>")

-- Save
vim.keymap.set("n", "<C-s>", "<cmd>w<CR>")
vim.keymap.set("i", "<C-s>", "<Esc><cmd>w<CR>a")

-- Netrw
-- Open in cwd
vim.keymap.set("n", "<leader>pv", function()
  vim.cmd("Ex " .. vim.fn.getcwd())
end)
-- Open in current file's location
vim.keymap.set("n", "<leader>pw", ":Explore<CR>")

-- Window movement without C-w
vim.keymap.set("n", "<C-S-h>", "<C-w>h")
vim.keymap.set("n", "<C-S-j>", "<C-w>j")
vim.keymap.set("n", "<C-S-k>", "<C-w>k")
vim.keymap.set("n", "<C-S-l>", "<C-w>l")

-- Window resizing
vim.keymap.set("n", "<C-A-z>", "<c-w>5<")
vim.keymap.set("n", "<C-A-i>", "<C-W>-")
vim.keymap.set("n", "<C-A-u>", "<C-W>+")
vim.keymap.set("n", "<C-A-o>", "<c-w>5>")

-- Moving Selections/Lines
vim.keymap.set("v", "<A-S-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<A-S-k>", ":m '<-2<cr>gv=gv")
vim.keymap.set("n", "<A-S-j>", ":m .+1<cr>==")
vim.keymap.set("n", "<A-S-k>", ":m .-2<CR>==")
vim.keymap.set("i", "<A-S-j>", "<Esc>:m .+1<CR>==gi")
vim.keymap.set("i", "<A-S-k>", "<Esc>:m .-2<CR>==gi")

-- Half page jump and searching -> center cursor
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Undo highlight search done by using '*'
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Align equal signs
vim.keymap.set("v", "<C-0>", "<Esc>:'<,'> ! column -t -s= -o= | sed 's/=/ = /g'<CR>")

-- Exit Terminal Mode using Esc
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

-------------
-- Plugins --
-------------

-- TODO: Colorscheme

vim.lsp.config("*", {
  on_attach = function(_, bufnr) 
    vim.filetype.add({ extension = { jai = "jai" } })

    -- TODO: move to jails config?
    -- Error format for compiler message recognition
    local jai_error = [[%f:%l\,%v: %t%\a\*:%m]]
    vim.o.errorformat = jai_error .. "," .. vim.o.errorformat

    -- Global mappings
    vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float)
    vim.keymap.set("n", "<leader>nd", vim.diagnostic.goto_next)
    vim.keymap.set("n", "<leader>pd", vim.diagnostic.goto_prev)

    -- LSP Buffer mappings
    local opts = { buffer = bufnr }

    vim.lsp.handlers["textDocument/signature_help"] = vim.lsp.with(
      vim.lsp.handlers.signature_help, {
	border = "rounded",
	close_events = { "CursorMoved", "BufHidden", "InsertCharPre" }
      }
    )

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set({ "n", "i" }, "<C-n>", function()
      require("lsp_signature").toggle_float_win()
    end, opts)
    vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>rn", function()
      vim.lsp.buf.rename()
    end, opts)
    vim.keymap.set({ "n", "v" }, "<leader>f", function()
      vim.lsp.buf.format { async = true }
    end, opts)

    local trouble = require("trouble")

    vim.keymap.set("n", "<leader>da", function() trouble.open("document_diagnostics") end, opts)
    vim.keymap.set("n", "<leader>rr", function() trouble.open("lsp_references") end, opts)
  end
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
-- TODO: cmp nvim
-- capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
capabilities.offsetEncoding = { "utf-16" }
-- NOTE: yanked from https://github.com/jdah/dotfiles and I have no idea what it does
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = { "documentation", "detail", "additionalTextEdits" },
}

vim.lsp.config.lua_ls = {
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
	globals = { "vim" }
      }
    }
  },
}
vim.lsp.enable("lua_ls")
