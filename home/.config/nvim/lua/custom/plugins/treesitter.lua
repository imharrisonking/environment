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

    -- Workaround for Neovim 0.12 markdown injection instability where
    -- get_node_text() can receive a nil node during injections parsing
    -- (shows up as: attempt to call method 'range' (a nil value)).
    --
    -- Keep injections enabled (so fenced code blocks can be highlighted),
    -- but guard get_node_text against invalid nodes on 0.12.x.
    local v = vim.version()
    if v.major == 0 and v.minor == 12 then
      local ts = vim.treesitter
      if ts and not ts._safe_get_node_text_wrapped and type(ts.get_node_text) == 'function' then
        local orig_get_node_text = ts.get_node_text
        ts.get_node_text = function(node, source, opts)
          -- Some 0.12 paths hand quantified captures as a node list (table)
          -- into get_node_text(), but core expects a TSNode. Normalize by
          -- taking the first element when this happens.
          if type(node) == 'table' and type(node.range) ~= 'function' then
            node = node[1]
          end

          local ok, result = pcall(orig_get_node_text, node, source, opts)
          if ok then
            return result
          end
          if type(result) == 'string' and result:find("attempt to call method 'range'", 1, true) then
            return ''
          end
          error(result)
        end
        ts._safe_get_node_text_wrapped = true
      end
    end

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

    -- Ensure markdown buffers always get treesitter highlighting/injections.
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'markdown',
      group = vim.api.nvim_create_augroup('ForceMarkdownTreesitterHighlight', { clear = true }),
      callback = function(args)
        pcall(vim.treesitter.start, args.buf, 'markdown')
      end,
    })
  end,
}
