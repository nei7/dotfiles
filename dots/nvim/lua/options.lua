require "nvchad.options"

-- add yours here!

local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!

-- command-line autocompletion: show the popup while typing, don't preselect
o.wildmode = "noselect:lastused,full"
o.wildoptions = "pum,fuzzy"

vim.api.nvim_create_autocmd("CmdlineChanged", {
  pattern = { ":", "/", "?" },
  callback = function()
    vim.fn.wildtrigger()
  end,
})
