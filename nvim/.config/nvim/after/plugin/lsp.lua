local Remap = require("johnvicke.keymap")
local nnoremap = Remap.nnoremap
local diagnosticls = require("diagnosticls-configs")
local lspconfig = require("lspconfig")
local format_group = vim.api.nvim_create_augroup("LspFormatGroup", {})
local format_opts = { async = false, timeout_ms = 2500 }

require("lspsaga").setup({ ui = { border = "rounded", theme = "round" } })

local function register_fmt_keymap(name, bufnr)
	nnoremap("<leader>p", function()
		vim.lsp.buf.format(vim.tbl_extend("force", format_opts, { name = name, bufnr = bufnr }))
	end, { desc = "Format current buffer [LSP]", buffer = bufnr })
end

local function register_fmt_autosave(name, bufnr)
	vim.api.nvim_clear_autocmds({ group = format_group, buffer = bufnr })
	vim.api.nvim_create_autocmd("BufWritePre", {
		group = format_group,
		buffer = bufnr,
		callback = function()
			vim.lsp.buf.format(vim.tbl_extend("force", format_opts, { name = name, bufnr = bufnr }))
		end,
		desc = "Format on save [LSP]",
	})
end

vim.diagnostic.config({
	underline = { severity_limit = "Error" },
	signs = true,
	update_in_insert = false,
})

local function on_attach(client, bufnr)
	nnoremap("gd", vim.lsp.buf.definition, { desc = "Go to definition [LSP]", buffer = bufnr })
	nnoremap("gt", vim.lsp.buf.type_definition, { desc = "Go to type definition", buffer = bufnr })
	nnoremap("gD", vim.lsp.buf.declaration, { desc = "Go to declaration [LSP]", buffer = bufnr })
	nnoremap("gi", vim.lsp.buf.implementation, { desc = "Go to implentation [LSP]", buffer = bufnr })
	nnoremap("gw", vim.lsp.buf.document_symbol, { desc = "Search document symbols [LSP]", buffer = bufnr })
	nnoremap("gW", vim.lsp.buf.workspace_symbol, { desc = "Search workspace symbols [LSP]", buffer = bufnr })
	nnoremap("gr", vim.lsp.buf.references, { desc = "Show references [LSP]", buffer = bufnr })
	nnoremap("<c-k>", vim.lsp.buf.signature_help, { desc = "Show signature help [LSP]", buffer = bufnr })

	-- LSP Saga keymaps
	nnoremap("K", "<Cmd>Lspsaga hover_doc<CR>", { desc = "Hover documentation [LSP]", buffer = bufnr })
	nnoremap("<leader>ca", "<Cmd>Lspsaga code_action<CR>", { desc = "Code action [LSP]", buffer = bufnr })
	nnoremap("<leader>rn", "<Cmd>Lspsaga rename<CR>", { desc = "Rename [LSP]", buffer = bufnr })
	nnoremap(
		"<leader>ls",
		"<Cmd>Lspsaga show_line_diagnostics<CR>",
		{ desc = "Show diagnostic at line [LSP]", buffer = bufnr }
	)
	nnoremap("[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { desc = "Go to next diagnostic [LSP]", buffer = bufnr })
	nnoremap(
		"]e",
		"<cmd>Lspsaga diagnostic_jump_next<CR>",
		{ desc = "Go to previous diagnostic [LSP]", buffer = bufnr }
	)

	if client.name == "tsserver" then
		nnoremap("<Leader>oi", "<Cmd>OrganizeImports<CR>", { desc = "Organize imports [TS]", buffer = bufnr })
	end

	if client.name == "rust_analyzer" then
		register_fmt_keymap(client.name, bufnr)
		register_fmt_autosave(client.name, bufnr)
	end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.preselectSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
	properties = {
		"documentation",
		"detail",
		"additionalTextEdits",
	},
}

local default_config = {
	on_attach = on_attach,
	capabilities = capabilities,
}

require("mason-tool-installer").setup({
	ensure_installed = {
		"eslint_d",
		"prettier",
		"stylua",
		"codelldb",
	},
})
require("mason-lspconfig").setup({
	ensure_installed = {
		"bashls",
		"cssls",
		"diagnosticls",
		"dockerls",
		"gopls",
		"html",
		"jsonls",
		"pylsp",
		"rust_analyzer",
		"sumneko_lua",
		"tailwindcss",
		"tsserver",
		"yamlls",
	},
	automatic_installation = false,
})

-- Language Servers
lspconfig.pylsp.setup(default_config)
lspconfig.bashls.setup(default_config)
lspconfig.cssls.setup(default_config)
lspconfig.dockerls.setup(default_config)
lspconfig.html.setup(default_config)
lspconfig.jsonls.setup(default_config)
lspconfig.yamlls.setup(default_config)
lspconfig.gopls.setup(default_config)
lspconfig.prismals.setup(default_config)

-- Tailwind CSS
local tw_highlight = require("tailwind-highlight")
lspconfig.tailwindcss.setup({
	on_attach = function(client, bufnr)
		tw_highlight.setup(client, bufnr, {
			single_column = false,
			mode = "background",
			debounce = 200,
		})

		on_attach(client, bufnr)
	end,
})

-- Typescript/JavaScript
local function organize_imports()
	local params = {
		command = "_typescript.organizeImports",
		arguments = { vim.api.nvim_buf_get_name(0) },
		title = "",
	}
	vim.lsp.buf.execute_command(params)
end

lspconfig.tsserver.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	commands = {
		OrganizeImports = {
			organize_imports,
			description = "Organize Imports",
		},
	},
})

-- Lua
local lua_rtp = vim.split(package.path, ";")
table.insert(lua_rtp, "lua/?.lua")
table.insert(lua_rtp, "lua/?/init.lua")

lspconfig.sumneko_lua.setup(vim.tbl_extend("force", default_config, {
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
				path = lua_rtp,
			},
			diagnostics = { globals = { "vim" } },
			workspace = { library = vim.api.nvim_get_runtime_file("", true) },
			telemetry = { enable = false },
		},
	},
}))

diagnosticls.init({
	on_attach = function(_, bufnr)
		register_fmt_keymap("diagnosticls", bufnr)
		register_fmt_autosave("diagnosticls", bufnr)
	end,
})

local web_configs = {
	linter = require("diagnosticls-configs.linters.eslint_d"),
	formatter = require("diagnosticls-configs.formatters.prettier"),
}

diagnosticls.setup({
	javascript = web_configs,
	javascriptreact = web_configs,
	typescript = web_configs,
	typescriptreact = web_configs,
	lua = {
		formatter = require("diagnosticls-configs.formatters.stylua"),
	},
})

-- Rust
require("rust-tools").setup({
	server = default_config,
})
