-- Managed by chezmoi. Neovim 0.11+ built-in LSP for typos-lsp (Homebrew).

local vimrc = vim.fn.expand("~/.vimrc")
if vim.fn.filereadable(vimrc) == 1 then
	vim.cmd.source(vimrc)
end

vim.lsp.config("typos_lsp", {
	cmd = { "typos-lsp" },
	cmd_env = { RUST_LOG = "error" },
	init_options = {
		config = vim.fn.expand("~/.typos.toml"),
		diagnosticSeverity = "Info",
	},
})

vim.lsp.enable("typos_lsp")

-- Insert mode: jump to start / end of line (C-a / C-e: Zed terminal + Ghostty cmd-arrows).
-- Cmd+up / cmd+down: Zed keymap + Ghostty send Esc+gg / Esc+G (no Lua here; works in normal + insert).
-- Re-add <Home>/<End> imaps if you want Fn+arrows or a real Home/End key in other terminals.
vim.keymap.set("i", "<C-a>", "<C-o>0", { desc = "Beginning of line (C-a, Zed/Ghostty cmd-arrows)" })
vim.keymap.set("i", "<C-e>", "<C-o>$", { desc = "End of line (C-e, Zed/Ghostty cmd-arrows)" })
