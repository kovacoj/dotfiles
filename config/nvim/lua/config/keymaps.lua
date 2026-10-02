local map = vim.keymap.set

-- Keep the visual selection active while indenting, as in the old vimrc.
map("x", ">", ">gv")
map("x", "<", "<gv")
map("x", "<Tab>", ">gv")
map("x", "<S-Tab>", "<gv")

-- Move lines/selections up/down like Alt+arrows in VS Code.
map("n", "<A-j>", "<cmd>m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<CR>==", { desc = "Move line up" })
map("x", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("x", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Prepare a whole-file substitution, leaving the replacement ready to type.
map("n", "<leader>r", [[:let @/=expand('<cword>')<CR>:%s///g<Left><Left>]], { desc = "Replace word in file" })
map("x", "<leader>r", [[y:%s/\V<C-r>"//g<Left><Left>]], { desc = "Replace selection in file" })

map("n", "<Esc>", "<cmd>nohlsearch<CR>")
map("n", "<C-_>", function()
	require("Comment.api").toggle.linewise.current()
end, { desc = "Toggle comment" })
map("x", "<C-_>", function()
	vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "nx", false)
	require("Comment.api").toggle.linewise(vim.fn.visualmode())
end, { desc = "Toggle comment selection" })
map("n", "<leader>w", "<cmd>write<CR>", { desc = "Write file" })
map("n", "<leader>q", "<cmd>quit<CR>", { desc = "Quit window" })

-- These match the Ctrl+h/j/k/l pane movement already used by tmux.
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })
