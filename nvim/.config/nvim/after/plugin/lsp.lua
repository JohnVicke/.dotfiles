local Remap = require("johnvicke.keymap")
local luasnip = require("luasnip")
local saga = require("lspsaga")
local nnoremap = Remap.nnoremap
local inoremap = Remap.inoremap

local cmp = require("cmp")
local lspkind = require("lspkind")
saga.init_lsp_saga()

cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},

	mapping = cmp.mapping.preset.insert({
    ['<CR>']      = cmp.mapping.confirm({ select = true }),
		["<C-u>"]     = cmp.mapping.scroll_docs(-4),
		["<C-d>"]     = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
	}),

	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
	},
})

local function config(_config)
	return vim.tbl_deep_extend("force", {
		capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
		on_attach = function()
			nnoremap("gd", function() vim.lsp.buf.definition() end)
			nnoremap("K", "<cmd>Lspsaga hover_doc<CR>")
			nnoremap("<leader>vws", function() vim.lsp.buf.workspace_symbol() end)
			nnoremap("<leader>vd", function() vim.diagnostic.open_float() end)
			nnoremap("[g", function() vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR}) end)
		  nnoremap("]g", function() vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR}) end)
			nnoremap("<leader>ca", "<cmd>Lspsaga code_action<CR>")
			nnoremap("<leader>co", function() vim.lsp.buf.code_action({
                filter = function(code_action)
                    if not code_action or not code_action.data then
                        return false
                    end

                    local data = code_action.data.id
                    return string.sub(data, #data - 1, #data) == ":0"
                end,
                apply = true
            }) end)
			nnoremap("<leader>rr", function() vim.lsp.buf.references() end)
			nnoremap("<leader>rn",  "<cmd>Lspsaga rename<CR>")
			inoremap("<C-h>", function() vim.lsp.buf.signature_help() end)
      nnoremap("<leader>gh", "<cmd>Lspsaga lsp_finder<CR>")

		end,
	}, _config or {})
end

require("lspconfig").zls.setup(config())
require("lspconfig").tsserver.setup(config(), {filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact", "javascript.jsx" }})
require("lspconfig").ccls.setup(config())
require("lspconfig").jedi_language_server.setup(config())
require("lspconfig").svelte.setup(config())
require("lspconfig").solang.setup(config())
require("lspconfig").cssls.setup(config())
require("lspconfig").tailwindcss.setup(config())
require("lspconfig").prismals.setup(config())

require("lspconfig").gopls.setup(config({
	cmd = { "gopls", "serve" },
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
		},
	},
}))

require("lspconfig").rust_analyzer.setup(config({
	cmd = { "rustup", "run", "nightly", "rust-analyzer" },
}))


local opts = {
	highlight_hovered_item = true,
	show_guides = true,
}

require("symbols-outline").setup(opts)

local snippets_paths = function()
	local plugins = { "friendly-snippets" }
	local paths = {}
	local path
	local root_path = vim.env.HOME .. "/.vim/plugged/"
	for _, plug in ipairs(plugins) do
		path = root_path .. plug
		if vim.fn.isdirectory(path) ~= 0 then
			table.insert(paths, path)
		end
	end
	return paths
end

luasnip.filetype_extend("javascript", {"html"})
luasnip.filetype_extend("javascriptreact", {"html"})
luasnip.filetype_extend("typescriptreact", {"html"})


