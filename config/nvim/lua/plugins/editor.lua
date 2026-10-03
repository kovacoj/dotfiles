return {
	{
		"stevearc/oil.nvim",
		lazy = false,
		opts = {
			view_options = { show_hidden = true },
			float = { border = "rounded" },
			keymaps = {
				["h"] = "actions.parent",
				["l"] = "actions.select",
			},
		},
		keys = {
			{ "-", "<cmd>Oil<CR>", desc = "Browse parent directory" },
			{ "<leader>e", "<cmd>Oil --float<CR>", desc = "Browse files" },
		},
	},
	{
		"ibhagwan/fzf-lua",
		config = function()
			local fzf = require("fzf-lua")
			fzf.setup({ vim.env.TMUX and "fzf-tmux" or "fzf-native" })
			fzf.register_ui_select()

			local map = vim.keymap.set
			map("n", "/", fzf.blines, { desc = "Fuzzy find in buffer" })
			map("n", "<leader>/", "/", { desc = "Exact search in buffer" })
			map("n", "<leader>ff", fzf.files, { desc = "Find files" })
			map("n", "<leader>fg", fzf.live_grep, { desc = "Find text" })
			map("n", "<leader>fb", fzf.buffers, { desc = "Find buffers" })
			map("n", "<leader>fh", fzf.helptags, { desc = "Find help" })
			map("n", "<leader>fr", fzf.oldfiles, { desc = "Recent files" })
			map("n", "<leader>fz", fzf.zoxide, { desc = "Zoxide directories" })
			map("n", "<leader>gs", fzf.git_status, { desc = "Git status" })
			map("n", "<leader>gc", fzf.git_commits, { desc = "Git commits" })
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local treesitter = require("nvim-treesitter")
			local parsers = { "bash", "json", "lua", "markdown", "markdown_inline", "python", "query", "vim", "vimdoc" }
			treesitter.setup()
			treesitter.install(parsers)
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "bash", "json", "lua", "markdown", "python", "vim" },
				callback = function()
					vim.treesitter.start()
				end,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nvim-treesitter-textobjects").setup({ move = { set_jumps = true } })
			local move = require("nvim-treesitter-textobjects.move")
			local map = vim.keymap.set
			map({ "n", "x", "o" }, "]f", function() move.goto_next_start("@function.outer", "textobjects") end, { desc = "Next function" })
			map({ "n", "x", "o" }, "[f", function() move.goto_previous_start("@function.outer", "textobjects") end, { desc = "Previous function" })
			map({ "n", "x", "o" }, "]F", function() move.goto_next_end("@function.outer", "textobjects") end, { desc = "Next function end" })
			map({ "n", "x", "o" }, "[F", function() move.goto_previous_end("@function.outer", "textobjects") end, { desc = "Previous function end" })
			map({ "n", "x", "o" }, "]c", function() move.goto_next_start("@class.outer", "textobjects") end, { desc = "Next class" })
			map({ "n", "x", "o" }, "[c", function() move.goto_previous_start("@class.outer", "textobjects") end, { desc = "Previous class" })
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		lazy = false,
		opts = {
			signcolumn = false,
			numhl = true,
		},
		keys = {
			{ "]h", function() require("gitsigns").nav_hunk("next") end, desc = "Next Git hunk" },
			{ "[h", function() require("gitsigns").nav_hunk("prev") end, desc = "Previous Git hunk" },
			{ "<leader>hp", function() require("gitsigns").preview_hunk() end, desc = "Preview Git hunk" },
			{ "<leader>hs", function() require("gitsigns").stage_hunk() end, desc = "Stage Git hunk" },
			{ "<leader>hr", function() require("gitsigns").reset_hunk() end, desc = "Reset Git hunk" },
		},
	},
	{
		"echasnovski/mini.surround",
		version = "*",
		opts = {},
	},
	{
		"numToStr/Comment.nvim",
		opts = { ignore = "^%s*$" },
	},
}
