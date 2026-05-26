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

    local function reset_tmux_status_background()
      if not vim.env.TMUX or vim.fn.executable('tmux') ~= 1 then
        return
      end

      local tmux = vim.fn.system
      tmux({ 'tmux', 'set-option', '-g', 'status-style', 'bg=default' })
      tmux({ 'tmux', 'set-option', '-g', 'status-left-style', 'bg=default' })
      tmux({ 'tmux', 'set-option', '-g', 'status-right-style', 'bg=default' })
      tmux({ 'tmux', 'set-option', '-g', 'window-status-style', 'bg=default' })
      tmux({ 'tmux', 'refresh-client', '-S' })
    end
    
    -- Ensure statusline stays hidden without mode-changed redraw churn.
    vim.api.nvim_create_autocmd({ "CmdlineEnter", "CmdlineLeave", "WinEnter", "BufEnter" }, {
      callback = function()
        vim.opt.laststatus = 0
      end,
    })

    -- tmux can inherit a different status bg when hopping sessions.
    -- Re-assert default background whenever focus/session context changes.
    vim.api.nvim_create_autocmd({ 'VimEnter', 'FocusGained' }, {
      callback = reset_tmux_status_background,
    })

    vim.api.nvim_create_user_command('TpipelineResetBg', reset_tmux_status_background, {
      desc = 'Reset tmux statusline background to default',
    })

    -- Let tpipeline automatically use your existing lualine statusline
    -- No need to redefine - it should detect and use lualine automatically
  end,
}
