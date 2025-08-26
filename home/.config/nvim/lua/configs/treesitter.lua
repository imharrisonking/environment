return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "vim", "lua", "vimdoc",
      "html", "css", "typescript", "javascript", "tsx", "python", "json", "yaml", "markdown", "markdown_inline"
    },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = true,
    }
  },
}