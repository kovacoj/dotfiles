local map = vim.keymap.set

-- Keep the visual selection active while indenting, as in the old vimrc.
map("x", ">", ">gv")
map("x", "<", "<gv")
map("x", "<Tab>", ">gv")
map("x", "<S-Tab>", "<gv")

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

-- Smart nav: move inside Neovim; at the edge of the layout, hand off to the tmux pane.
local function smart_nav(dir, tmux_dir)
	local prev_win = vim.api.nvim_get_current_win()
	vim.cmd("wincmd " .. dir)
	if vim.api.nvim_get_current_win() == prev_win and vim.env.TMUX then
		vim.fn.system("tmux select-pane -" .. tmux_dir)
	end
end
map("n", "<C-h>", function() smart_nav("h", "L") end, { desc = "Window/pane left" })
map("n", "<C-j>", function() smart_nav("j", "D") end, { desc = "Window/pane down" })
map("n", "<C-k>", function() smart_nav("k", "U") end, { desc = "Window/pane up" })
map("n", "<C-l>", function() smart_nav("l", "R") end, { desc = "Window/pane right" })
