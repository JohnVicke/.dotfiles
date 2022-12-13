local M = {}

function fix_current_file()
	return function()
		local filetype = vim.bo.filetype

		vim.cmd("silent! %!eslint_d --fix %")
	end
end

function fix_all()
	return function()
		vim.cmd("silent! %!eslint_d --fix .")
	end
end

M.fix_current_file = fix_current_file()
M.fix_all = fix_all()

return M
