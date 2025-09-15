-- ## Session Settings ##
--------------------------------------------------------------------------------
-- Keep track of tab pages and window sizes in the session file.
vim.o.sessionoptions = "tabpages,winsize"

-- ## Automatic Session Loading/Saving Logic ##
--------------------------------------------------------------------------------
-- Execute session logic only if Neovim was started without file arguments.
if vim.fn.argc() == 0 then

  -- Local function to clean up empty windows and save the session.
  local function clear_empty_and_save_session()
    -- Close all windows that are empty (one line, no content).
    vim.cmd("windo if (line('$') == 1 && getline(1) == '') | clo | en")

    -- Count the remaining windows using the API.
    local window_count = #vim.api.nvim_list_wins()

    -- Don't bother saving a session if only one window is left.
    if window_count > 1 then
      vim.cmd("mks! .session.vim~")
    end
  end

  -- Create an augroup for session commands.
  local session_group = vim.api.nvim_create_augroup("SessionManagement", { clear = true })

  -- Autocommand for entering Neovim (VimEnter).
  vim.api.nvim_create_autocmd("VimEnter", {
    group = session_group,
    nested = true, -- Equivalent to 'nested' in Vimscript.
    desc = "Load temporary session on startup.",
    callback = function()
      local session_file = ".session.vim~"
      -- Check if the session file exists.
      if vim.loop.fs_stat(session_file) then
        vim.cmd("source " .. session_file)
        -- Delete the session file after loading.
        pcall(vim.loop.fs_unlink, session_file)
      end
    end,
  })

  -- Autocommand for leaving Neovim (VimLeave).
  vim.api.nvim_create_autocmd("VimLeave", {
    group = session_group,
    desc = "Clear empty windows and save session on exit.",
    callback = clear_empty_and_save_session,
  })

end

