-- lua/config/overlength.lua
vim.o.colorcolumn = "80"

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    vim.cmd [[ match OverLength /\%81v.*/ ]]
  end,
})

vim.api.nvim_set_hl(0, "OverLength", {
  fg = "#ffffff",
  bg = "#ff0000",
  underline = true,
})

