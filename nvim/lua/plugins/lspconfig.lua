return {
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      {
        "williamboman/mason.nvim",
        opts = {
          PATH = "prepend", -- Prioriza binarios del sistema
          registries = {
            "github:mason-org/mason-registry",
          }
        },
      },
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("mason").setup()
      local mason_lspconfig = require("mason-lspconfig")
      local lspconfig = require("lspconfig")

      mason_lspconfig.setup({
        ensure_installed = {
          "jdtls",        -- Java
          "tsserver",     -- TypeScript/JavaScript
          "clangd",       -- C/C++
          "rust_analyzer",-- Rust
          "bashls",       -- Bash
          "lua_ls",       -- Lua
          "jsonls",       -- JSON
          "sqlls",        -- SQL
        },
        automatic_installation = true,
      })

      mason_lspconfig.setup_handlers({
        function(server_name)
          lspconfig[server_name].setup({})
        end,
        ["tsserver"] = function()
          lspconfig.tsserver.setup({
            settings = {
              completions = {
                completeFunctionCalls = true
              }
            }
          })
        end,
      })
    end,
  }
}
