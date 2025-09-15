-- %f: Full file path
-- %r: Read-only flag
-- %w: Preview window flag
-- %m: Modified flag
-- %=: Separator to right-align the following items
-- %{mode()}: Current editor mode
-- %l:%c: Line and column number
-- %y: Filetype
-- %{&...}: File encoding and format
vim.o.statusline = "%f%r%w%m%=%{mode()} %l:%c %y %{&fileencoding?&fileencoding:&encoding}[%{&fileformat}]"

