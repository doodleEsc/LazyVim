return {
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
}
