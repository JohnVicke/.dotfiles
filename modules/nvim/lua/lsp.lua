local function select_preferred_client(bufnr, method)
	local filetype = vim.bo[bufnr].filetype
	local js_ts_filetypes = {
		"javascript", "javascriptreact", "typescript", "typescriptreact",
		"json", "jsonc"
	}

	local clients = vim.lsp.get_clients({ bufnr = bufnr })

	-- For JS/TS files, use priority system
	if vim.tbl_contains(js_ts_filetypes, filetype) then
		local priority = { "biome", "null-ls", "prettier", "eslint", "ts_ls" }

		for _, preferred in ipairs(priority) do
			for _, client in ipairs(clients) do
				if client.name == preferred and client.supports_method(method) then
					return client
				end
			end
		end
	end

	-- For other languages, return first client that supports the method
	for _, client in ipairs(clients) do
		if client.supports_method(method) then
			return client
		end
	end

	return nil
end

local function smart_format(bufnr)
	vim.lsp.buf.format({
		bufnr = bufnr,
		async = true,
		timeout_ms = 2000,
		filter = function(client)
			local preferred = select_preferred_client(bufnr, "textDocument/formatting")
			local should_use = preferred and client.id == preferred.id

			if should_use then
				vim.notify("💅 Formatting with " .. client.name, vim.log.levels.INFO)
			end

			return should_use
		end,
	})
end


local function fzf_code_actions(bufnr, range, context)
	local params = vim.lsp.util.make_range_params()
	params.context = context or {
		diagnostics = vim.lsp.diagnostic.get_line_diagnostics(bufnr)
	}
	require("fzf-lua").lsp_code_actions({
		bufnr = bufnr,
		range = range,
		params = params,
		previewer = function(action)
			if action and action.edit then
				return true
			else
				return false
			end
		end,
		winopts = {
			height = 15,
			width = 0.7,
			row = 0.3,
			col = 0.5,
			border = "single",
			preview = {
				border = "single",
				hidden = "hidden",
			},
		},
	})
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("my.lsp", {}),
	callback = function(args)
		local bufnr = args.buf
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

		local nmap = function(keys, func)
			vim.keymap.set("n", keys, func, { buffer = bufnr })
		end

		if client:supports_method("textDocument/rename") then
			nmap("cr", vim.lsp.buf.rename)
		end

		if client:supports_method("textDocument/formatting") then
			nmap("<leader>lf", function()
				smart_format(bufnr)
			end)
		end

		nmap("K", vim.lsp.buf.hover)
		nmap("<C-k>", vim.lsp.buf.signature_help)
		nmap("gd", vim.lsp.buf.definition)

		nmap("<leader>oi", function()
			vim.lsp.buf.code_action({
				apply = true,
				context = {
					only = { "source.organizeImports" },
					diagnostics = {},
				},
			})
		end)

		nmap("<leader>cu", function()
			vim.lsp.buf.code_action({
				apply = true,
				context = {
					only = { "source.removeUnused" },
					diagnostics = {},
				},
			})
		end)

		local ok, fzf = pcall(require, "fzf-lua")
		if ok then
			nmap("<leader>ca", function()
				fzf_code_actions(bufnr)
			end)
			nmap("<leader>cA", function()
				fzf_code_actions(bufnr, nil, { diagnostics = {} })
			end)
			nmap("gr", function()
				fzf.lsp_references({ bufnr = bufnr })
			end)
			nmap("gI", function()
				fzf.lsp_implementations({ bufnr = bufnr })
			end)
			nmap("<leader>ds", function()
				fzf.lsp_document_symbols({ bufnr = bufnr })
			end)
			nmap("<leader>ws", fzf.lsp_workspace_symbols)
		end
	end,
})

-- Configure Zig LSP
vim.lsp.config("zig", {
	cmd = { "zls" },
	filetypes = { "zig" },
	root_markers = { "build.zig", ".git" },
})

vim.lsp.enable({
	"lua_ls",
	"ts_ls",
	"biome",
	"gopls",
	"eslint",
	"astro",
	"zig"
})

local mappings = {
	-- key,	severity,
	{ "d", nil },
	{ "w", vim.diagnostic.severity.WARN },
	{ "e", vim.diagnostic.severity.ERROR },
	{ "h", vim.diagnostic.severity.HINT },
	{ "i", vim.diagnostic.severity.INFO },
}

for dir, count in pairs({ ["]"] = 1, ["["] = -1 }) do
	for _, map in ipairs(mappings) do
		local key, severity = map[1], map[2]
		local full_key = dir .. key
		nnoremap(full_key, function()
			vim.diagnostic.jump({ count = count, severity = severity })
		end)
	end
end

nnoremap("<leader>ld", vim.diagnostic.open_float)
