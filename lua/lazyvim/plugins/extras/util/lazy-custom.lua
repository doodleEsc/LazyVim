--- Add the startup section
---@return snacks.dashboard.Section
local function dashboardStartup()
  local stats = Snacks.dashboard.lazy_stats
  stats = stats and stats.startuptime > 0 and stats or require("lazy.stats").stats()
  local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)

  local datetime = os.date(" %Y-%m-%d") .. "  -  "
  local version = vim.version()
  local nvim_version_info = " v" .. version.major .. "." .. version.minor .. "." .. version.patch .. "  -  "
  local plugin_info = "󰚥 " .. stats.loaded .. "/" .. stats.count .. " plugins" .. "  -  "
  local load_cost = "󱎫 " .. ms .. "ms"

  local footer = datetime .. nvim_version_info .. plugin_info .. load_cost

  return {
    align = "center",
    padding = { 0, 1 },
    text = {
      -- { stats.loaded .. "/" .. stats.count, hl = "special" },
      { footer, hl = "footer" },
      -- { ms .. "ms", hl = "special" },
    },
  }
end

return {

  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<Tab>", desc = "Increment Selection", mode = { "x", "n" } },
        { "<C-Space>", desc = "Toggle Terminal (Root Dir)", mode = { "t", "n" } },
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    keys = function()
      return {
        { "<Tab>", desc = "Increment Selection" },
        { "<bs>", desc = "Decrement Selection", mode = "x" },
      }
    end,
    opts = {
      incremental_selection = {
        keymaps = {
          init_selection = "<Tab>",
          node_incremental = "<Tab>",
        },
      },
    },
  },
  {
    "doodleEsc/Lazy-custom",
    event = "VeryLazy",
    keys = {
      {
        "<C-Space>",
        function()
          Snacks.terminal(nil, { cwd = LazyVim.root() })
        end,
        mode = "n",
        desc = "Terminal (Root Dir)",
      },
      {
        "<C-Space>",
        "<cmd>close<cr>",
        mode = "t",
        silent = true,
        noremap = true,
        desc = "Hide Terminal",
      },
    },
    opts = {
      opts = {
        jumpoptions = "stack",
      },
      globals = {
        clipboard = {
          name = "uniClipboard",
          copy = {
            ["+"] = "clipboard-provider copy",
            ["*"] = "clipboard-provider copy",
          },
          paste = {
            ["+"] = "clipboard-provider paste",
            ["*"] = "clipboard-provider paste",
          },
          cache_enabled = 1,
        },
      },
    },
  },

  {
    "snacks.nvim",

    opts = function(_, opts)
      local snacksConfig = {

        input = {
          enabled = true,
        },

        -- Animation
        ---@type snacks.animate.Config
        animate = {
          easing = "inQuad",
        },

        -- Dashboard
        ---@type snacks.dashboard.Config
        dashboard = {
          preset = {
            header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
      ]],
          },
          sections = {
            { section = "header", padding = 1 },
            -- { title = "Shortcuts", padding = 0, align = "center" },
            { section = "keys", padding = { 1, 0 }, gap = 1 },
            -- { title = "Recent Files", padding = 1, align = "center" },
            -- { section = "recent_files", padding = 1 },
            -- { title = "Recent Projects", padding = 1, align = "center" },
            { section = "projects", padding = 1, limit = 10, session = true },
            dashboardStartup,
          },
        },
      }
      LazyVim.merge(opts, snacksConfig)
    end,
  },
}
