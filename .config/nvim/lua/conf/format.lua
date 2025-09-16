-- Check for executables
local has = {
 js = vim.fn.executable("js-beautify") > 0,
 clang = vim.fn.executable("clang-format") > 0,
 gofmt = vim.fn.executable("gofmt") > 0,
 rustfmt = vim.fn.executable("rustfmt") > 0,
 yapf = vim.fn.executable("yapf") > 0
}

-- Enable syntax highlighting
vim.cmd('syntax enable')

-- Format function
function FormatIt()
  -- Only format if there is more than 1 line in the file
  if vim.fn.line('$') > 1 then
    -- Save current view position
    local pos = vim.fn.winsaveview()

    -- Check file syntax and available formatter
    local syntax = vim.bo.filetype
    if syntax == 'javascript' or syntax == 'json' then
      if has.js then
        vim.cmd("%! js-beautify -s 2")
      end
    elseif syntax == 'html' or syntax == 'mustache' or syntax == 'svg' then
      if has.js then
        vim.cmd("%! js-beautify -s 2 --type html")
      end
    elseif syntax == 'css' then
      if has.js then
        vim.cmd("%! js-beautify -s 2 --type css")
      end
    elseif syntax == 'c' or syntax == 'cpp' then
      if has.clang then
        vim.cmd("%! clang-format --style=file")
      end
    elseif syntax == 'rust' then
      if has.rustfmt then
        MyFMT("rustfmt --emit stdout")
      end
    elseif syntax == 'go' then
      if has.gofmt then
        MyFMT("gofmt")
      end
    elseif syntax == 'python' then
      if has.yapf then
        MyFMT("yapf")
      end
    end

    -- Remove trailing spaces
    vim.cmd("%s/\\s\\+$//e")

    -- Replace tabs with spaces
    vim.cmd("%s/\\t/  /g")

    -- Restore the previous cursor position
    vim.fn.winrestview(pos)
  end
end

-- Fixes for gofmt and rustfmt
function MyFMT(exec)
  -- Get all text in the file before running the exec command
  local buffer = table.concat(vim.fn.getline(1, '$'), "\n")

  -- Execute the command
  vim.cmd("%! " .. exec)

  -- If the command exits with a non-zero status, restore the original text
  if vim.v.shell_error ~= 0 then
    vim.fn.setline(1, vim.fn.split(buffer, "\n"))
  end
end

-- Automatically format before saving the buffer
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    vim.cmd("silent! lua FormatIt()")
  end
})

