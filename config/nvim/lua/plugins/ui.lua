local p = require("config.palette")

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
			variant = p.variant,
			colors = {
				fg = p.fg,
				grey = p.muted,
				green = p.green,
				cyan = p.cyan,
				blue = p.cyan,
				yellow = p.yellow,
				orange = p.orange,
				magenta = p.magenta,
				pink = p.magenta,
				purple = p.purple,
				red = p.red,
			},
			highlights = {
				FloatBorder = { fg = p.fg },
				["@property.json"] = { fg = p.green },
				["@string.json"] = { fg = p.yellow },
				["@number.json"] = { fg = p.orange },
				["@boolean.json"] = { fg = p.purple },
				["@property.yaml"] = { fg = p.cyan },
				["@string.yaml"] = { fg = p.yellow },
				["@number.yaml"] = { fg = p.orange },
				["@boolean.yaml"] = { fg = p.purple },
				["@comment.yaml"] = { fg = p.muted },
			},
		},
		config = function(_, opts)
			require("cyberdream").setup(opts)
			vim.cmd.colorscheme("cyberdream")
			vim.api.nvim_set_hl(0, "Visual", { bg = p.select })
			vim.api.nvim_set_hl(0, "VisualNOS", { bg = p.select })
			vim.api.nvim_set_hl(0, "LineNr", { fg = p.linenr, bg = "NONE" })
			vim.api.nvim_set_hl(0, "CursorLineNr", { fg = p.cyan, bg = "NONE", bold = true })
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		opts = {
			options = {
				theme = {
					normal = {
						a = { fg = p.cyan, bg = "NONE", gui = "bold" },
						b = { fg = p.green, bg = "NONE" },
						c = { fg = p.fg, bg = "NONE" },
					},
					insert = { a = { fg = p.green, bg = "NONE", gui = "bold" } },
					visual = { a = { fg = p.yellow, bg = "NONE", gui = "bold" } },
					replace = { a = { fg = p.red, bg = "NONE", gui = "bold" } },
					command = { a = { fg = p.magenta, bg = "NONE", gui = "bold" } },
					inactive = { c = { fg = p.muted, bg = "NONE" } },
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
							return { fg = vim.bo.modified and p.orange or p.fg }
						end,
					},
				},
				lualine_x = {
					{ "diagnostics", symbols = { error = "E ", warn = "W ", info = "I ", hint = "H " } },
					{ "searchcount", color = { fg = p.purple } },
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
				{ "<leader>g", group = "Git pickers" },
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
