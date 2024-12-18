return {
  {

    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.incremental_selection = {
        enabled = false,
      }
    end,
  },
  {
    "doodleEsc/Lazy-custom",
    dev = true,
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
}
