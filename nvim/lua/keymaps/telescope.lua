-- Eliminar todo el contenido y dejar solo:
vim.keymap.set("n", "<C-p>", "<cmd>Telescope find_files<cr>", { desc = "Buscar archivos" })
vim.keymap.set("n", "<C-g>", "<cmd>Telescope live_grep<cr>", { desc = "Buscar texto (live grep)" })
vim.keymap.set("n", "<C-b>", "<cmd>Telescope buffers<cr>", { desc = "Buscar buffers" })
vim.keymap.set("n", "<C-h>", "<cmd>Telescope help_tags<cr>", { desc = "Buscar ayuda" })
