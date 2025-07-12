-- ~/.config/nvim/lua/plugins/treesitter.lua

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = function()
      require("nvim-treesitter.install").update({ with_sync = true })()
    end,
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = {
          "c", "lua", "vim", "vimdoc", "query",
          "elixir", "heex", "javascript", "html", 
					"java", "python", "json", "bash"
        },
        sync_install = false,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
      })
    end
  }
}

