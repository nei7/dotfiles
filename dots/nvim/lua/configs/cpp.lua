-- C++ workflow for Makefile-driven single-file projects (playground/cpp):
--   make <name>           build the current file, errors go to quickfix
--   make run-<name>       build and run in the NvChad terminal
-- The target is the bare file name (01_basics/01_types.cpp -> 01_types),
-- exactly like the tasks in .vscode/tasks.json.
local M = {}

local function target()
  return vim.fn.expand "%:t:r"
end

local function has_makefile()
  return vim.uv.fs_stat(vim.fn.getcwd() .. "/Makefile") ~= nil
end

local function fill_quickfix(cmd, res)
  local out = (res.stdout or "") .. (res.stderr or "")
  local lines = vim.split(out, "\n", { trimempty = true })
  vim.fn.setqflist({}, " ", { title = table.concat(cmd, " "), lines = lines, efm = vim.o.errorformat })
  local valid = vim.tbl_filter(function(i)
    return i.valid == 1
  end, vim.fn.getqflist())
  if #valid > 0 then
    vim.cmd "copen"
    vim.cmd "wincmd p"
  else
    vim.cmd "cclose"
  end
end

-- Builds the current file. Async by default; with opts.sync it blocks and
-- returns true/false (used by nvim-dap before launching gdb).
function M.build(args, opts)
  opts = opts or {}
  if not has_makefile() then
    vim.notify("no Makefile in " .. vim.fn.getcwd(), vim.log.levels.WARN)
    return false
  end
  vim.cmd "silent! wall"

  local cmd = { "make", target() }
  vim.list_extend(cmd, args or {})

  local function done(res)
    fill_quickfix(cmd, res)
    if res.code == 0 then
      vim.notify("built bin/" .. target(), vim.log.levels.INFO)
    else
      vim.notify(table.concat(cmd, " ") .. " failed", vim.log.levels.ERROR)
    end
    return res.code == 0
  end

  if opts.sync then
    return done(vim.system(cmd, { text = true }):wait())
  end
  vim.system(cmd, { text = true }, function(res)
    vim.schedule(function()
      done(res)
    end)
  end)
end

-- Runs `make run-<name>` in a horizontal NvChad terminal that is reused
-- between runs (the same window, previous output cleared).
function M.run(args)
  if not has_makefile() then
    vim.notify("no Makefile in " .. vim.fn.getcwd(), vim.log.levels.WARN)
    return
  end
  vim.cmd "silent! wall"
  local cmd = "make run-" .. target() .. (args and (" " .. args) or "")
  require("nvchad.term").runner { pos = "sp", id = "cpprun", cmd = cmd }
end

-- clangd needs compile_commands.json; the Makefile creates it on the first
-- build, so do that once per session when it is missing.
local ensured = false
local function ensure_compile_commands()
  if ensured or not has_makefile() then
    return
  end
  ensured = true
  if vim.uv.fs_stat(vim.fn.getcwd() .. "/compile_commands.json") then
    return
  end
  vim.system({ "make", "-n", "compile_commands.json" }, {}, function(res)
    if res.code == 0 then
      vim.system { "make", "compile_commands.json" }
    end
  end)
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  group = vim.api.nvim_create_augroup("cpp_workflow", { clear = true }),
  callback = function(ev)
    -- match .clang-format (IndentWidth: 4, ColumnLimit: 100)
    vim.bo[ev.buf].shiftwidth = 4
    vim.bo[ev.buf].tabstop = 4
    vim.bo[ev.buf].softtabstop = 4
    vim.wo.colorcolumn = "100"

    ensure_compile_commands()

    local function map(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc })
    end
    map("<leader>cc", function()
      M.build()
    end, "C++ build current file")
    map("<leader>cr", function()
      M.run()
    end, "C++ build and run current file")
    map("<leader>cs", function()
      M.run "SAN=0"
    end, "C++ run current file without sanitizers")
    map("<leader>ci", function()
      local enabled = vim.lsp.inlay_hint.is_enabled { bufnr = ev.buf }
      vim.lsp.inlay_hint.enable(not enabled, { bufnr = ev.buf })
    end, "C++ toggle inlay hints")
  end,
})

return M
