return {
	{
		"mason-org/mason-lspconfig.nvim",
		lazy = false,
		dependencies = {
			{ "mason-org/mason.nvim", opts = { ui = { border = "rounded" } } },
			"neovim/nvim-lspconfig",
			"saghen/blink.cmp",
		},
		init = function()
			vim.lsp.config("lua_ls", {
				settings = { Lua = { diagnostics = { globals = { "vim" } } } },
			})
		end,
		opts = {
			ensure_installed = { "bashls", "clangd", "lua_ls", "pyright", "ruff" },
			automatic_enable = { "bashls", "clangd", "lua_ls", "pyright", "ruff" },
		},
		config = function(_, opts)
			require("mason-lspconfig").setup(opts)

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(event)
					local function lsp_map(lhs, rhs, desc)
						vim.keymap.set("n", lhs, rhs, { buffer = event.buf, desc = desc })
					end

					lsp_map("gd", vim.lsp.buf.definition, "Go to definition")
					lsp_map("gr", vim.lsp.buf.references, "Go to references")
					lsp_map("K", vim.lsp.buf.hover, "Show documentation")
					lsp_map("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
					lsp_map("<leader>ca", vim.lsp.buf.code_action, "Code action")
					lsp_map("<leader>cd", vim.diagnostic.open_float, "Show diagnostic")
					lsp_map("[d", function()
						vim.diagnostic.jump({ count = -1 })
					end, "Previous diagnostic")
					lsp_map("]d", function()
						vim.diagnostic.jump({ count = 1 })
					end, "Next diagnostic")
				end,
			})
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason-org/mason.nvim" },
		opts = { ensure_installed = { "ruff", "shfmt", "stylua" } },
	},
}
