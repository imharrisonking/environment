return {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        require("tokyonight").setup({
            style = "night",
        })
        -- Override NvChad's theme system
        vim.api.nvim_create_autocmd("User", {
            pattern = "VeryLazy",
            callback = function()
                vim.cmd([[colorscheme tokyonight]])
            end,
        })
    end,
}