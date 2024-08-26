return {

  { "nvimdev/dashboard-nvim", enabled = false },
  { "echasnovski/mini.starter", enabled = false },
  -- Dashboard. This runs when neovim starts, and is what displays
  -- the "LAZYVIM" banner.
  {
    "doodleEsc/alpha-nvim",
    event = "VimEnter",
    dev = true,
    enabled = true,
    init = false,
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

  --     dashboard.section.buttons.val = {
  --       dashboard.button("o", "  Open CWD", "<cmd>doautocmd User DeferStart|ene|OpenTree<CR>"),
  --       dashboard.button("p", "  Recent Projects", "<cmd>doautocmd User DeferStart|Telescope projects<CR>"),
  --       dashboard.button("r", "  Recent File", "<cmd>doautocmd User DeferStart|Telescope oldfiles<CR>"),
  --       dashboard.button("e", "  New file", "<cmd>doautocmd User DeferStart|ene<CR>"),
  --       dashboard.button("f", "  Find File", "<cmd>doautocmd User DeferStart|Telescope find_files<CR>"),
  --       dashboard.button("b", "  File Browser", "<cmd>doautocmd User DeferStart|Telescope file_browser<CR>"),
  --       dashboard.button("s", "  Configuration", "<cmd>doautocmd User DeferStart|e $MYVIMRC|OpenTree<CR>"),
  --       dashboard.button("u", "  Update Plugins", "<cmd>doautocmd User DeferStart|Lazy sync<CR>"),
  --       dashboard.button("q", "  Quit", "<cmd>doautocmd User DeferStart|qa<cr>"),
  --     }


      dashboard.section.buttons.val = {
        dashboard.button("o", " " .. " Open Current Dir",  "<cmd>ene|NvimTreeToggle<CR>"),
        dashboard.button("f", " " .. " Find file",         LazyVim.pick()),
        dashboard.button("n", " " .. " New file",          [[<cmd> ene <BAR> startinsert <cr>]]),
        dashboard.button("r", " " .. " Recent files",      LazyVim.pick("oldfiles")),
        dashboard.button("g", " " .. " Find text",         LazyVim.pick("live_grep")),
        dashboard.button("c", " " .. " Config",            LazyVim.pick.config_files()),
        dashboard.button("s", " " .. " Restore Session",   function() require("persistence").load() end),
        dashboard.button("x", " " .. " Lazy Extras",       "<cmd> LazyExtras <cr>"),
        dashboard.button("l", "󰒲 " .. " Lazy",              "<cmd> Lazy <cr>"),
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
    config = function(_, dashboard)
      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          once = true,
          pattern = "AlphaReady",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      require("alpha").setup(dashboard.opts)

      vim.api.nvim_create_autocmd("User", {
        once = true,
        pattern = "LazyVimStarted",
        callback = function()
          local datetime = os.date(" %Y-%m-%d") .. "  -  "
          local author = "󰊠 " .. os.getenv("USER") .. "  -  "
          local version = vim.version()
          local nvim_version_info = " v" .. version.major .. "." .. version.minor .. "." .. version.patch .. "  -  "

          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          local plugin_info = "a " .. stats.loaded .. "/" .. stats.count .. " plugins" .. "  -  "
          local load_cost = "t " .. ms .. "ms"

          local footer = author .. datetime .. nvim_version_info .. plugin_info .. load_cost
          dashboard.section.footer.val = footer
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },
}
