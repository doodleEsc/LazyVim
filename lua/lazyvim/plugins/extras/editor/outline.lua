return {
  {
    "hedyhli/outline.nvim",
    keys = {
      { "<leader>j", "", desc = "+Outline", mode = "n" },
      { "<leader>jj", "<cmd>Outline<cr>", desc = "Toggle Outline", group = "Outline" },
    },
    cmd = "Outline",
    opts = function()
      local defaults = require("outline.config").defaults
      local opts = {
        symbols = {
          icons = {},
          filter = vim.deepcopy(LazyVim.config.kind_filter),
        },
        keymaps = {
          up_and_jump = "<up>",
          down_and_jump = "<down>",
        },
      }

      for kind, symbol in pairs(defaults.symbols.icons) do
        opts.symbols.icons[kind] = {
          icon = LazyVim.config.icons.kinds[kind] or symbol.icon,
          hl = symbol.hl,
        }
      end
      return opts
    end,
  },

  {

    "folke/which-key.nvim",
    optional = true,
    opts = function(_, opts)
      local group = { "<leader>j", group = "+outline" }
      table.insert(opts["spec"][1], group)
    end,
  },

  -- -- edgy integration
  -- {
  --   "folke/edgy.nvim",
  --   optional = true,
  --   opts = function(_, opts)
  --     local edgy_idx = LazyVim.plugin.extra_idx("ui.edgy")
  --     local symbols_idx = LazyVim.plugin.extra_idx("editor.outline")
  --
  --     if edgy_idx and edgy_idx > symbols_idx then
  --       LazyVim.warn(
  --         "The `edgy.nvim` extra must be **imported** before the `outline.nvim` extra to work properly.",
  --         { title = "LazyVim" }
  --       )
  --     end
  --
  --     opts.right = opts.right or {}
  --     table.insert(opts.right, {
  --       title = "Outline",
  --       ft = "Outline",
  --       pinned = true,
  --       open = "Outline",
  --     })
  --   end,
  -- },
}
