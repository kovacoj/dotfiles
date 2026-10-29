return {
	{
		"saghen/blink.cmp",
		version = "1.*",
		opts = {
			keymap = {
				preset = "default",
				["<CR>"] = { "select_and_accept", "fallback" },
			},
			completion = {
				documentation = { auto_show = true, auto_show_delay_ms = 200 },
				list = { max_items = 25 },
				keyword = { range = "full" },
			},
			signature = { enabled = true },
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
				providers = {
					buffer = {
						min_keyword_length = 3,
						max_items = 5,
						score_offset = -3,
					},
				},
			},
			fuzzy = {
				implementation = "prefer_rust",
				max_typos = function(keyword)
					return math.floor(#keyword / 3)
				end,
				sorts = { "score", "sort_text" },
			},
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
