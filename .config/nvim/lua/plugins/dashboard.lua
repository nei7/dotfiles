return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  config = function()
    local api = vim.api
    local keymap = vim.keymap
    local dashboard = require("dashboard")

    local conf = {}
    conf.header = {
      "                                                       ",
      "                                                       ",
      "                                                       ",
      " ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
      " ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
      " ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
      " ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
      " ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
      " ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
      "                                                       ",
      "                                                       ",
      "                                                       ",
      "                                                       ",
    }

    conf.center = {
      {
        icon = "󰈞  ",
        desc = "Find  File                              ",
        action = "Telescope find_files",
        key = "<Leader> f f",
      },
      {
        icon = "󰈢  ",
        desc = "Recently opened files                   ",
        action = "SessionRestore",
        key = "<Leader> w r",
      },
      {
        icon = "󰈬  ",
        desc = "Project grep                            ",
        action = "Telescope live_grep",
        key = "<Leader> f g",
      },
      {
        icon = "  ",
        desc = "New file                                ",
        action = "enew",
        key = "e",
      },
      {
        icon = "󰗼  ",
        desc = "Quit Nvim                               ",
        -- desc = "Quit Nvim                               ",
        action = "qa",
        key = "q",
      },
    }
    dashboard.setup({ theme = "doom", shortcut_type = "number", config = conf })

    api.nvim_create_autocmd("FileType", {
      pattern = "dashboard",
      group = api.nvim_create_augroup("dashboard_enter", { clear = true }),
      callback = function()
        keymap.set("n", "q", ":qa<CR>", { buffer = true, silent = true })
        keymap.set("n", "e", ":enew<CR>", { buffer = true, silent = true })
      end,
    })
  end,
  dependencies = { { "nvim-tree/nvim-web-devicons" } },
}
