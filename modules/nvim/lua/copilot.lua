require("copilot").setup({
	suggestion = {
		enabled = true,
		auto_trigger = true,
		keymap = {
			accept = "<C-l>",
			next = "<C-]>",
			prev = false,
			dismiss = "<C-c>",
		},
	},
	panel = { enabled = false },
})
