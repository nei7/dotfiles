-- Debugging with gdb's built-in DAP server (gdb >= 14, `gdb -i dap`).
-- gdb comes from the project's nix shell (flake.nix), so start nvim from a
-- directory where direnv has loaded it.
local dap = require "dap"
local dapui = require "dapui"

dap.adapters.gdb = {
  type = "executable",
  command = "gdb",
  args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
}

-- Mirrors .vscode/launch.json: build the open file, then debug bin/<name>.
-- LeakSanitizer does not work under gdb, hence detect_leaks=0.
dap.configurations.cpp = {
  {
    name = "debug current file (bin/<name>)",
    type = "gdb",
    request = "launch",
    program = function()
      if vim.fn.exepath "gdb" == "" then
        vim.notify("gdb not found: start nvim inside the nix shell (direnv)", vim.log.levels.ERROR)
        return dap.ABORT
      end
      if not require("configs.cpp").build(nil, { sync = true }) then
        return dap.ABORT
      end
      return vim.fn.getcwd() .. "/bin/" .. vim.fn.expand "%:t:r"
    end,
    cwd = "${workspaceFolder}",
    stopAtBeginningOfMainSubprogram = false,
    env = {
      ASAN_OPTIONS = "detect_leaks=0:detect_stack_use_after_return=1",
      UBSAN_OPTIONS = "print_stacktrace=1",
    },
  },
}
dap.configurations.c = dap.configurations.cpp

dapui.setup()

dap.listeners.after.event_initialized["dapui"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui"] = function()
  dapui.close()
end

-- Highlights from base46 (integrations = { "dap" } in chadrc.lua); compile the
-- cache once if this integration was added after the last compile.
if not pcall(dofile, vim.g.base46_cache .. "dap") then
  require("base46").load_all_highlights()
  pcall(dofile, vim.g.base46_cache .. "dap")
end

-- Sign text must be 1 cell wide: BMP private-use nerd glyphs (U+Fxxx) have
-- width 0 in nvim and the sign silently fails to place, so breakpoints
-- would never reach gdb. These are plain Unicode.
vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint" })
vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DapBreakpointCondition" })
vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DapBreakPointRejected" })
vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DapStopped", linehl = "DapStoppedLine" })
