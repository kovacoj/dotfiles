local flavour = vim.env.CATPPUCCIN_FLAVOUR or "mocha"

local function git_diff()
	local status = vim.b.gitsigns_status_dict
	if status then
		return { added = status.added, modified = status.changed, removed = status.removed }
	end
end

return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = flavour,
				background = { light = "latte", dark = "mocha" },
				transparent_background = false,
				float = { transparent = false },
				dim_inactive = { enabled = false },
				integrations = {
					treesitter = true,
					gitsigns = true,
					mason = true,
					which_key = true,
					fzf = true,
				},
			})
			vim.opt.winblend = 0
			vim.opt.pumblend = 0
			vim.o.background = flavour == "latte" and "light" or "dark"
			vim.cmd.colorscheme("catppuccin")
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		opts = {
			options = {
				theme = "catppuccin",
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
					},
				},
				lualine_x = {
					"diagnostics",
					"searchcount",
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
