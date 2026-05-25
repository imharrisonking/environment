return {
  'vimpostor/vim-tpipeline',
  enabled = true,
  config = function()
    -- Enable true colors for proper color translation
    vim.opt.termguicolors = true

    -- Disable auto-embedding so we can manually configure tmux positioning
    vim.g.tpipeline_autoembed = 0
    vim.g.tpipeline_restore = 0
    vim.g.tpipeline_clearstl = 1
    
    -- Force statusline to stay hidden in all modes including command mode
    vim.g.tpipeline_preservebg = 1
    
    -- Ensure statusline is always hidden
    vim.api.nvim_create_autocmd({ "ModeChanged", "CmdlineEnter", "CmdlineLeave" }, {
      callback = function()
        vim.opt.laststatus = 0
      end,
    })

    -- Let tpipeline automatically use your existing lualine statusline
    -- No need to redefine - it should detect and use lualine automatically
  end,
}
