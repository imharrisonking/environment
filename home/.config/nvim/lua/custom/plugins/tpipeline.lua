return {
  'vimpostor/vim-tpipeline',
  enabled = true,
  config = function()
    -- Enable true colors for proper color translation
    vim.opt.termguicolors = true

    -- Disable auto-embedding so we can manually configure tmux positioning
    vim.g.tpipeline_autoembed = 0
    vim.g.tpipeline_restore = 1
    vim.g.tpipeline_clearstl = 1

    -- Let tpipeline automatically use your existing lualine statusline
    -- No need to redefine - it should detect and use lualine automatically
  end,
}
