-- ~/.config/nvim/lua/keymaps/neo-tree.lua

vim.keymap.set("n", "<A-t>", "<cmd>Neotree toggle<CR>", {
  desc = "Alternar Neo-tree",
  noremap = true,
  silent = true,
})

