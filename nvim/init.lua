-- Líneas numeradas
vim.opt.number = true             -- número de línea absoluto
vim.opt.relativenumber = true     -- número relativo (opcional)

-- Mostrar caracteres invisibles como tabs y EOL
vim.opt.list = true
vim.opt.listchars = {
  tab = "»·",        -- muestra los tabs como »·
  trail = "·",       -- espacios al final de línea
  extends = "⟩",     -- texto que se desborda a la derecha
  precedes = "⟨",    -- texto que se desborda a la izquierda
  eol = "↲",         -- retorno de carro
}

-- Tabulación real (carácter de tab, no espacios)
vim.opt.tabstop = 4       -- tab = 4 espacios visuales
vim.opt.shiftwidth = 4    -- indentado al hacer >> o <<
vim.opt.softtabstop = 4   -- comportamiento del tabulador
vim.opt.expandtab = false -- usar tabs reales, no espacios

require("config.lazy")
require("config.overlength")
require("keymaps.telescope")
require("keymaps.neotree")

