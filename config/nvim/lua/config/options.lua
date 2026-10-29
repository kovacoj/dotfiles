vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

opt.autoread = true
opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.breakindent = true
opt.cmdheight = 0
opt.ignorecase = true
opt.smartcase = true
opt.signcolumn = "auto"
opt.numberwidth = 1
opt.showmode = false
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.timeoutlen = 400
opt.undofile = true
opt.updatetime = 250
opt.wildignorecase = true
opt.wildmode = "longest:full,full"
opt.wildoptions = "pum"

opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4

-- No diagnostic glyphs in the sign column; counts live in the statusline instead.
vim.diagnostic.config({ signs = false })

-- settings.json files (Windows Terminal, VS Code) allow // comments.
vim.filetype.add({ filename = { ["settings.json"] = "jsonc" } })

-- OSC 52 writes work through tmux, but terminal clipboard reads may be blocked.
local powershell = vim.fn.exepath("powershell.exe")
if powershell == "" then
	powershell = "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe"
end
local windows_clipboard = vim.fn.executable(powershell) == 1
if windows_clipboard or vim.env.SSH_TTY or vim.env.TMUX then
	local osc52 = require("vim.ui.clipboard.osc52")
	local function paste_windows()
		local result = vim.system({
			powershell,
			"-NoProfile",
			"-NonInteractive",
			"-Command",
			"[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false); "
				.. "$text = Get-Clipboard -Raw; if ($null -ne $text) { [Console]::Write($text) }",
		}, { text = true }):wait()
		if result.code ~= 0 then
			error("Windows clipboard read failed: " .. (result.stderr or ""))
		end
		return { vim.split(result.stdout or "", "\n", { plain = true }), "v" }
	end
	vim.g.clipboard = {
		name = windows_clipboard and "OSC 52 / Windows clipboard" or "OSC 52",
		copy = {
			["+"] = osc52.copy("+"),
			["*"] = osc52.copy("*"),
		},
		paste = {
			["+"] = windows_clipboard and paste_windows or osc52.paste("+"),
			["*"] = windows_clipboard and paste_windows or osc52.paste("*"),
		},
		cache_enabled = 0,
	}
end
