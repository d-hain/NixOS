require("plugins.colorscheme")
require("plugins.lualine")

require("plugins.treesitter")
require("plugins.blink")
require("plugins.lsp")

require("plugins.vim-illuminate")
require("nvim-surround")
require("plugins.harpoon")
require("plugins.telescope")
require("plugins.todo-comments")

-- Jai.vim
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "jai" },
  callback = function()
    vim.b.jai_indent_options = { case_labels = 0 }
  end,
})

-- Vim Fugitive
vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
vim.keymap.set("n", "<leader>gb", ":Git blame<CR>")

-- Undotree
vim.keymap.set("n", "<leader>u", ":UndotreeToggle<CR>")
