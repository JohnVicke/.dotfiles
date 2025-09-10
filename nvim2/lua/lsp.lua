local config = require("lsp-config")

vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('my.lsp', {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

		if client:supports_method("textDocument/rename") then
			nnoremap("cr", vim.lsp.buf.rename)
		end
				
		if client:supports_method("textDocument/formatting") then
			nnoremap("<leader>lf", vim.lsp.buf.format({ bufnr = bufnr, id = client.id, timeout_ms = 1000 }))
		end

		if client:supports_method('textDocument/completion') then
			local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
			client.server_capabilities.completionProvider.triggerCharacters = chars
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end

	end,
})

vim.lsp.enable(
	{
		"lua_ls",
		"ts_ls"
	}
)
