-- NOTE: Jai is in Beta currently and not officially supported by nvim-treesitter
vim.treesitter.language.register("jai", "jai")

local treesitter = require("nvim-treesitter")
-- Stolen from: https://github.com/BirdeeHub/nix-wrapper-modules/blob/main/templates/neovim/init.lua
local function treesitter_try_attach(buf, language)
  -- check if parser exists and load it
  if not vim.treesitter.language.add(language) then
    return false
  end
  -- enables syntax highlighting and other treesitter features
  vim.treesitter.start(buf, language)

  -- enables treesitter based folds
  vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  vim.wo.foldmethod = "expr"
  -- ensure folds are open to begin with
  vim.o.foldlevel = 99

  -- enables treesitter based indentation
  vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

  return true
end

local installable_parsers = treesitter.get_available()
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    local buf, filetype = args.buf, args.match
    local language = vim.treesitter.language.get_lang(filetype)
    if not language then
      return
    end

    if not treesitter_try_attach(buf,language) then
      if vim.tbl_contains(installable_parsers, language) then
        -- not already installed, so try to install them via nvim-treesitter if possible
        treesitter.install(language):await(function()
          treesitter_try_attach(buf, language)
        end)
      end
    end
  end,
})

-- Long functions
require("treesitter-context").setup {
  enable = true,
}

-- For filetypes like Vue and Svelte
require("ts_context_commentstring").setup {}
vim.g.skip_ts_context_commentstring_module = true
-- NOTE: automatically has integration with tpope/vim-commentary
