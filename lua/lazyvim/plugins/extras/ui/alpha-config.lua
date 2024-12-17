return {
  {

    "goolord/alpha-nvim",
    optional = true,

    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      local logo = {
        "                                                    ",
        " ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
        " ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
        " ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
        " ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
        " ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
        " ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
        "                                                    ",
      }

      dashboard.section.header.val = logo
      -- stylua: ignore

      dashboard.section.buttons.val = {
        dashboard.button("o", " " .. " Current Dir",       "<cmd>ene|NvimTreeToggle<CR>"),
        dashboard.button("f", " " .. " Find file",         LazyVim.pick()),
        dashboard.button("g", " " .. " Find text",         LazyVim.pick("live_grep")),
        dashboard.button("r", " " .. " Recent files",      LazyVim.pick("oldfiles")),
        dashboard.button("n", " " .. " New file",          [[<cmd> ene <BAR> startinsert <cr>]]),
        dashboard.button("c", " " .. " Config",            LazyVim.pick.config_files()),
        dashboard.button("u", "󰒲 " .. " Update Plugins",    "<cmd> Lazy sync <cr>"),
        dashboard.button("q", " " .. " Quit",              "<cmd> qa <cr>"),
      }

      dashboard.opts = {
        layout = {
          { type = "padding", val = 6 },
          dashboard.section.header,
          { type = "padding", val = 4 },
          dashboard.section.buttons,
          { type = "padding", val = 2 },
          dashboard.section.footer,
        },
        opts = {
          margin = 5,
        },
      }

      return dashboard
    end,
  },
}
