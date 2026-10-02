return {
	{
		"saghen/blink.cmp",
		version = "1.*",
		opts = {
			keymap = {
				preset = "default",
				["<CR>"] = { "select_and_accept", "fallback" },
			},
			completion = { documentation = { auto_show = true, auto_show_delay_ms = 300 } },
			sources = { default = { "lsp", "path", "snippets", "buffer" } },
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = { check_ts = true },
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "ruff_format" },
				sh = { "shfmt" },
				zsh = { "shfmt" },
			},
			format_on_save = { timeout_ms = 1000, lsp_format = "fallback" },
		},
		keys = {
			{
				"<leader>cf",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = { "n", "x" },
				desc = "Format buffer",
			},
		},
	},
}
