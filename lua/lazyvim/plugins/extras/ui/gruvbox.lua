return {

  {
    "catppuccin/nvim",
    enabled = false,
  },

  {
    "doodleEsc/gruvbox.nvim",
    lazy = true,
    opts = {
      terminal_colors = true, -- add neovim terminal colors
      undercurl = true,
      underline = true,
      bold = true,
      italic = {
        strings = true,
        emphasis = true,
        comments = true,
        operators = false,
        folds = true,
      },
      strikethrough = true,
      invert_selection = false,
      invert_signs = false,
      invert_tabline = false,
      invert_intend_guides = false,
      inverse = true, -- invert background for search, diffs, statuslines and errors
      contrast = "", -- can be "hard", "soft" or empty string
      palette_overrides = {},
      overrides = {
        SignColumn = { bg = "NONE" },
      },
      dim_inactive = false,
      transparent_mode = false,
    },
    specs = {
      {
        "akinsho/bufferline.nvim",
        optional = true,
        opts = function(_, opts)
          if (vim.g.colors_name or ""):find("gruvbox") then
            opts.highlights = require("gruvbox.integrations.bufferline").get()
          end
        end,
      },

      {
        "nvim-lualine/lualine.nvim",
        optional = true,
        opts = function(_, opts)
          if (vim.g.colors_name or ""):find("gruvbox") then
            opts.options.theme = require("gruvbox.integrations.lualine").get()
          end
        end,
      },
    },
  },
}
