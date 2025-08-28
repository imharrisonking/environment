return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "vim", "lua", "vimdoc",
      "html", "css", "typescript", "javascript", "tsx", "python", "json", "yaml", "markdown", "markdown_inline",
      "bash", "c", "diff", "luadoc", "query"
    },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = { "ruby" },
    },
    indent = { enable = true, disable = { "ruby" } },
  },
}