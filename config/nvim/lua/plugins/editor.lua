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
		"nvim-telescope/telescope.nvim",
		version = "*",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		config = function()
			local telescope = require("telescope")
			telescope.setup({ defaults = { borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" } } })
			telescope.load_extension("fzf")
		end,
		keys = {
			{ "/", function() require("telescope.builtin").current_buffer_fuzzy_find() end, desc = "Fuzzy find in buffer" },
			{ "<leader>/", "/", desc = "Exact search in buffer" },
			{ "<leader>ff", "<cmd>Telescope find_files hidden=true<CR>", desc = "Find files" },
			{ "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Find text" },
			{ "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Find buffers" },
			{ "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Find help" },
			{ "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Recent files" },
		},
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
