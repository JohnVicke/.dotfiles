local color_scheme = "gruvbox"
-- local color_scheme = "poimandres"

function PoimandresSetup ()
    local hl = function(thing, opts)
        vim.api.nvim_set_hl(0, thing, opts)
    end

    hl("SignColumn", {
        bg = "none",
    })

    hl("ColorColumn", {
        ctermbg = 0,
        bg = "#555555",
    })

    hl("CursorLineNR", {
        bg = "None"
    })

    hl("LineNr", {
        fg = "#5eacd3"
    })

    hl("netrwDir", {
        fg = "#5eacd3"
    })

end


function GruvBoxSetup()
    vim.g.gruvbox_contrast_dark = 'soft'
    vim.g.tokyonight_transparent_sidebr = true
    vim.g.tokyonight_transparent = true
    vim.g.gruvbox_invert_selection = '0'
    vim.opt.background = 'dark'

    local hl = function(thing, opts)
        vim.api.nvim_set_hl(0, thing, opts)
    end

    hl("LineNr", {
        fg = "#5eacd3"
    })

    hl("netrwDir", {
        fg = "#5eacd3"
    })

end

vim.g.johnvicke_colorscheme = color_scheme
vim.cmd("colorscheme " .. vim.g.johnvicke_colorscheme)

GruvBoxSetup()

if color_scheme == "poimandres" then
    PoimandresSetup()
end

