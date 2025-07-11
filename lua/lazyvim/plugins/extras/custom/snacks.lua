--- Add the startup section
---@return snacks.dashboard.Section
local function dashboardStartup()
  local stats = Snacks.dashboard.lazy_stats
  stats = stats and stats.startuptime > 0 and stats or require("lazy.stats").stats()
  local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)

  local delimiter = "  -  "
  local datetime = os.date(" %Y-%m-%d")
  local version = vim.version()
  local nvim_version_info = " v" .. version.major .. "." .. version.minor .. "." .. version.patch
  local plugin_info = "󰚥 " .. stats.loaded .. "/" .. stats.count .. " plugins"
  local load_cost = "󱎫 " .. ms .. "ms"

  return {
    align = "center",
    padding = { 0, 1 },
    text = {
      { datetime },
      { delimiter },
      { nvim_version_info },
      { delimiter },
      { plugin_info },
      { delimiter },
      { load_cost, hl = "special" },
    },
  }
end

return {
  "snacks.nvim",
  optional = true,
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
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚══╝  ╚═╝╚═╝     ╚═╝
      ]],
        },
        sections = {
          { section = "header", padding = 1 },
          -- { title = "Shortcuts", padding = 0, align = "center" },
          { section = "keys", padding = { 1, 0 }, gap = 1 },
          -- { title = "Recent Files", padding = 1, align = "center" },
          -- { section = "recent_files", padding = 1 },
          -- { title = "Recent Projects", padding = 1, align = "center" },
          { section = "projects", padding = 1, limit = 5, session = true },
          dashboardStartup,
        },
      },

      terminal = {
        win = {
          height = 0.5,
        },
      },
    }
    LazyVim.merge(opts, snacksConfig)
  end,
}

