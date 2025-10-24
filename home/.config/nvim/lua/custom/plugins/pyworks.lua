-- Custom jupytext integration using CLI (more reliable than the nvim plugin)
vim.api.nvim_create_autocmd({"BufReadPost"}, {
  pattern = "*.ipynb",
  callback = function()
    -- Use vim.schedule to avoid blocking
    vim.schedule(function()
      local file = vim.fn.expand("%:p")  -- Use full path
      local cmd = string.format("jupytext --to=py --output=- %s", vim.fn.shellescape(file))
      
      -- Run jupytext and get output
      local result = vim.fn.system(cmd)
      
      if vim.v.shell_error == 0 and result and result ~= "" then
        -- Clear buffer and set content
        local lines = vim.split(result, "\n", { plain = true })
        vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
        -- Set filetype to python for syntax highlighting
        vim.bo.filetype = "python"
        -- Mark buffer as not modified
        vim.bo.modified = false
        -- Make buffer read-only to prevent accidental changes
        vim.bo.readonly = true
        vim.notify("Jupyter notebook converted to Python format", vim.log.levels.INFO)
      else
        vim.notify("Failed to convert notebook: " .. (result or "unknown error"), vim.log.levels.ERROR)
      end
    end)
  end,
})

return {
  -- Molten for code execution
  {
    "benlubas/molten-nvim",
    build = ":UpdateRemotePlugins",
    config = function()
      vim.g.molten_auto_open_output = false
      vim.g.molten_wrap_output = true
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true
      
      -- Keymaps for molten
      vim.keymap.set("n", "<localleader>mi", ":MoltenInit<CR>", { desc = "Initialize molten" })
      vim.keymap.set("n", "<localleader>ro", ":MoltenEvaluateOperator<CR>", { desc = "Evaluate operator" })
      vim.keymap.set("n", "<localleader>rl", ":MoltenEvaluateLine<CR>", { desc = "Evaluate line" })
      vim.keymap.set("v", "<localleader>r", ":<C-u>MoltenEvaluateVisual<CR>gv", { desc = "Evaluate visual" })
      vim.keymap.set("n", "<localleader>rr", ":MoltenReevaluateCell<CR>", { desc = "Re-evaluate cell" })
    end,
    ft = { "python", "ipynb" },
  },
  
  -- Image display
  {
    "3rd/image.nvim",
    config = function()
      require("image").setup({
        backend = "kitty",
        integrations = {
          markdown = {
            enabled = true,
            clear_in_insert_mode = false,
            download_remote_images = true,
            only_render_image_at_cursor = false,
            filetypes = { "markdown", "vimwiki" },
          },
          neorg = {
            enabled = true,
            clear_in_insert_mode = false,
            download_remote_images = true,
            only_render_image_at_cursor = false,
            filetypes = { "norg" },
          },
          html = {
            enabled = false,
          },
          css = {
            enabled = false,
          },
        },
        max_width = nil,
        max_height = nil,
        max_height_window_percentage = 50,
        max_width_window_percentage = nil,
        window_overlap_clear_enabled = false,
        window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
        editor_only_render_when_focused = false,
        tmux_show_only_in_active_window = false,
        hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
      })
    end,
    ft = { "markdown", "vimwiki", "python", "ipynb" },
  },
}