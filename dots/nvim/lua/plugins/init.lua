return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "nix",
        "bash",
        "python",
        "c",
        "cpp",
        "html",
        "css",
        "javascript",
        "typescript",
        "json",
        "yaml",
        "markdown",
        "markdown_inline",
        "qmljs",
      },
    },
  },

  -- hide nix/clangd caches in the file tree
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      filters = { custom = { "^%.direnv$", "^%.cache$" } },
    },
  },

  -- debugger (gdb via DAP), see configs/dap.lua
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
    },
    config = function()
      require "configs.dap"
    end,
    keys = {
      -- stylua: ignore start
      { "<F5>",       function() require("dap").continue() end,          desc = "dap launch / continue" },
      { "<F9>",       function() require("dap").toggle_breakpoint() end, desc = "dap toggle breakpoint" },
      { "<F10>",      function() require("dap").step_over() end,         desc = "dap step over" },
      { "<F11>",      function() require("dap").step_into() end,         desc = "dap step into" },
      { "<F12>",      function() require("dap").step_out() end,          desc = "dap step out" },
      { "<leader>dc", function() require("dap").continue() end,          desc = "dap launch / continue" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "dap toggle breakpoint" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input "condition: ") end, desc = "dap conditional breakpoint" },
      { "<leader>do", function() require("dap").step_over() end,         desc = "dap step over" },
      { "<leader>di", function() require("dap").step_into() end,         desc = "dap step into" },
      { "<leader>dO", function() require("dap").step_out() end,          desc = "dap step out" },
      { "<leader>dx", function() require("dap").terminate() end,         desc = "dap terminate" },
      { "<leader>dr", function() require("dap").repl.toggle() end,       desc = "dap toggle repl" },
      { "<leader>du", function() require("dapui").toggle() end,          desc = "dap toggle ui" },
      { "<leader>dK", function() require("dapui").eval() end,            desc = "dap eval under cursor", mode = { "n", "v" } },
      -- stylua: ignore end
    },
  },
}
