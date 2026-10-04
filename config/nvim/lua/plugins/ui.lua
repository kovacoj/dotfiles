local dotfiles_theme = vim.env.DOTFILES_THEME or "system-fun"
local use_catppuccin = dotfiles_theme == "catppuccin-latte" or dotfiles_theme == "catppuccin-mocha"
local catppuccin_flavour = dotfiles_theme == "catppuccin-latte" and "latte" or "mocha"

local neon = {
	variant = "default",
	fg = "#e5e7eb",
	muted = "#8b7aa8",
	green = "#afff5f",
	cyan = "#5fd7ff",
	yellow = "#ffd75f",
	orange = "#ffaf5f",
	magenta = "#ff5fd2",
	purple = "#c084fc",
	red = "#ff5f87",
	select = "#515c7e",
	linenr = "#a0a8b7",
}

local function setup_cyberdream(p)
	require("cyberdream").setup({
		transparent = true,
		colors = {
			fg = p.fg, grey = p.muted, green = p.green, cyan = p.cyan, blue = p.cyan,
			yellow = p.yellow, orange = p.orange, magenta = p.magenta, pink = p.magenta,
			purple = p.purple, red = p.red,
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
	})
	vim.cmd.colorscheme("cyberdream")
	vim.api.nvim_set_hl(0, "Visual", { bg = p.select })
	vim.api.nvim_set_hl(0, "VisualNOS", { bg = p.select })
	vim.api.nvim_set_hl(0, "LineNr", { fg = p.linenr, bg = "NONE" })
	vim.api.nvim_set_hl(0, "CursorLineNr", { fg = p.cyan, bg = "NONE", bold = true })
end

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
		enabled = use_catppuccin,
		config = function()
			require("catppuccin").setup({
				flavour = catppuccin_flavour,
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
			vim.o.background = catppuccin_flavour == "latte" and "light" or "dark"
			vim.cmd.colorscheme("catppuccin")
		end,
	},
	{
		"scottmckendry/cyberdream.nvim",
		lazy = false,
		priority = 1000,
		enabled = not use_catppuccin,
		config = function()
			setup_cyberdream(neon)
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		opts = {
			options = {
				theme = use_catppuccin and "catppuccin" or {
					normal = {
						a = { fg = neon.cyan, bg = "NONE", gui = "bold" },
						b = { fg = neon.green, bg = "NONE" },
						c = { fg = neon.fg, bg = "NONE" },
					},
					insert = { a = { fg = neon.green, bg = "NONE", gui = "bold" } },
					visual = { a = { fg = neon.yellow, bg = "NONE", gui = "bold" } },
					replace = { a = { fg = neon.red, bg = "NONE", gui = "bold" } },
					command = { a = { fg = neon.magenta, bg = "NONE", gui = "bold" } },
					inactive = { c = { fg = neon.muted, bg = "NONE" } },
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
		opts = {
			triggers = { { "<leader>", mode = "n" } },
		},
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
