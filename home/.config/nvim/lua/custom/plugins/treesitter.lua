return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "vim", "lua", "vimdoc",
      "html", "css", "typescript", "javascript", "tsx", "python", "json", "yaml", "markdown", "markdown_inline",
      "bash", "c", "cpp", "diff", "luadoc", "query"
    },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = { "ruby" },
    },
    indent = { enable = true, disable = { "ruby" } },
  },
  config = function(_, opts)
    require('nvim-treesitter.configs').setup(opts)

    -- Some sessions can fall back to legacy python syntax groups
    -- (`pythonString`) until highlight is explicitly enabled for the buffer.
    -- Force-enable Treesitter highlight for Python buffers so docstring
    -- captures like `@string.documentation` are always available.
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'python',
      group = vim.api.nvim_create_augroup('ForcePythonTreesitterHighlight', { clear = true }),
      callback = function(args)
        pcall(vim.treesitter.start, args.buf, 'python')
      end,
    })
  end,
}
