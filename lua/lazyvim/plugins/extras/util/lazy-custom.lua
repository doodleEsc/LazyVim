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
    opts = {
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
      },
    },
  },
}
