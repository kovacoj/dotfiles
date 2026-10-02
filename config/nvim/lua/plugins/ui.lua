local function git_diff()
	local status = vim.b.gitsigns_status_dict
	if status then
		return { added = status.added, modified = status.changed, removed = status.removed }
	end
end

return {
	{
		"scottmckendry/cyberdream.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			transparent = true,
			colors = {
				fg = "#e5e7eb",
				grey = "#8b7aa8",
				green = "#afff5f",
				cyan = "#5fd7ff",
				blue = "#5fd7ff",
				yellow = "#ffd75f",
				orange = "#ffaf5f",
				magenta = "#ff5fd2",
				pink = "#ff5fd2",
				purple = "#c084fc",
				red = "#ff5f87",
			},
			highlights = {
				TelescopeBorder = { fg = "#e5e7eb" },
				TelescopePromptBorder = { fg = "#e5e7eb" },
				TelescopeResultsBorder = { fg = "#e5e7eb" },
				TelescopePreviewBorder = { fg = "#e5e7eb" },
				TelescopeSelection = { bg = "#515c7e" },
				TelescopeMatching = { fg = "#ff5fd2" },
				TelescopePromptPrefix = { fg = "#5fd7ff" },
			},
		},
		config = function(_, opts)
			require("cyberdream").setup(opts)
			vim.cmd.colorscheme("cyberdream")
			vim.api.nvim_set_hl(0, "Visual", { bg = "#515c7e" })
			vim.api.nvim_set_hl(0, "VisualNOS", { bg = "#515c7e" })
			vim.api.nvim_set_hl(0, "LineNr", { fg = "#a0a8b7", bg = "NONE" })
			vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#5ef1ff", bg = "NONE", bold = true })
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		opts = {
			options = {
				theme = {
					normal = {
						a = { fg = "#5fd7ff", bg = "NONE", gui = "bold" },
						b = { fg = "#afff5f", bg = "NONE" },
						c = { fg = "#e5e7eb", bg = "NONE" },
					},
					insert = { a = { fg = "#afff5f", bg = "NONE", gui = "bold" } },
					visual = { a = { fg = "#ffd75f", bg = "NONE", gui = "bold" } },
					replace = { a = { fg = "#ff5f87", bg = "NONE", gui = "bold" } },
					command = { a = { fg = "#ff5fd2", bg = "NONE", gui = "bold" } },
					inactive = { c = { fg = "#8b7aa8", bg = "NONE" } },
				},
				component_separators = " │ ",
				section_separators = "",
				globalstatus = true,
			},
			sections = {
				lualine_a = {
					{
						"mode",
						fmt = function(mode)
							return "-- " .. mode .. " --"
						end,
					},
				},
				lualine_b = {},
				lualine_c = {
					{
						"filename",
						path = 1,
						symbols = { modified = " [+]", readonly = " [RO]", unnamed = "[No Name]" },
						color = function()
							return { fg = vim.bo.modified and "#ffaf5f" or "#e5e7eb" }
						end,
					},
				},
				lualine_x = {
					{ "searchcount", color = { fg = "#c084fc" } },
					{
						"diff",
						source = git_diff,
						symbols = { added = "+", modified = "~", removed = "-" },
					},
				},
				lualine_y = {},
				lualine_z = {},
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { { "filename", path = 1 } },
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
			extensions = { "oil", "lazy", "mason" },
		},
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
		config = function(_, opts)
			local wk = require("which-key")
			wk.setup(opts)
			wk.add({
				{ "<leader>c", group = "Code" },
				{ "<leader>f", group = "Find" },
				{ "<leader>h", group = "Hunk" },
			})
		end,
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer keymaps",
			},
		},
	},
}
