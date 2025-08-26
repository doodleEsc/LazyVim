return {
  {
    "nvimtools/hydra.nvim",
    lazy = true,
  },

  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>h", group = "Hydra Operation", icon = " " },
      },
    },
  },
}
