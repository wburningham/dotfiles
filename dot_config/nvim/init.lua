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
