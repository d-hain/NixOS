vim.lsp.config("*", {
  float = {
    border = "rounded",
  },
  on_attach = function(_, bufnr)
    -- Lsp Signature
    require("lsp_signature").setup {
      hint_prefix = "",
      floating_window = false,
      bind = true,
    }

    -- Global mappings
    vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float)
    vim.keymap.set("n", "<leader>nd", function()
      vim.diagnostic.jump { count = 1 }
    end)
    vim.keymap.set("n", "<leader>pd", function()
      vim.diagnostic.jump { count = -1 }
    end)

    -- LSP Buffer mappings
    local opts = { buffer = bufnr }

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.handlers.signature_help

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
capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities({}, false))
capabilities = vim.tbl_deep_extend("force", capabilities, {
  offsetEncoding = { "utf-16" },
  -- NOTE: yanked from https://github.com/jdah/dotfiles and I have no idea what it does
  textDocument = {
    completion = {
      completionItem = {
        resolveSupport = {
          properties = { "documentation", "detail", "additionalTextEdits" },
        },
      },
    },
  },
})

vim.lsp.config("lua_ls", {
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
	    globals = { "vim" }
      }
    }
  },
})
vim.lsp.enable("lua_ls")

vim.lsp.config("rust_analyzer", {
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = true,
      check = {
        command = "clippy"
      },
    }
  },
})
vim.lsp.enable("rust_analyzer")

vim.lsp.config("clangd", {
  capabilities = capabilities,
  cmd = {
    "clangd",
    "--pch-storage=memory",
    "--completion-style=detailed",
    "--header-insertion=never",
    "--background-index",
    "--all-scopes-completion",
    "--header-insertion-decorators",
    "--function-arg-placeholders",
    "--inlay-hints",
    "--pretty",
    -- TODO: remove or adjust
    -- "-j=4",
  },
  filetypes = { "c", "cpp", "objc", "objcpp" },
  root_dir = vim.loop.cwd,
})
vim.lsp.enable("clangd")

vim.lsp.config("ols", {
  capabilities = capabilities,
  root_dir = vim.loop.cwd,
})
vim.lsp.enable("ols")

vim.lsp.config("glsl_analyzer", {
  capabilities = capabilities,
})
vim.lsp.enable("glsl_analyzer")

vim.lsp.config("superhtml", {
  capabilities = capabilities,
})
vim.lsp.enable("superhtml")

vim.lsp.config("tinymist", {
  capabilities = capabilities,
})
vim.lsp.enable("tinymist")

vim.lsp.config("hls", {
  capabilities = capabilities,
  filetypes = { "haskell", "lhaskell", "cabal" },
})
vim.lsp.enable("hls");

-- Error format for compiler message recognition
local jai_error = [[%f:%l\,%v: %t%\a\*:%m]]
vim.o.errorformat = jai_error .. "," .. vim.o.errorformat

vim.filetype.add({ extension = { jai = "jai" } })
vim.lsp.config("jails", {
  capabilities = capabilities,
  cmd = {
    "/home/dhain/Jai/Jails/bin/jails",
    "-jai_path", "/home/dhain/Jai/jai/",
  },
  root_markers = { "build.jai", "main.jai", ".git" },
  filetypes = { "jai" }
})
vim.lsp.enable("jails")
