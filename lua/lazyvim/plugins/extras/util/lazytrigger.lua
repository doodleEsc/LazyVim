return {
  {
    "doodleEsc/LazyTrigger.nvim",
    event = "VeryLazy",
    opts = {
      debug = false,
      events = {
        {
          name = "MyDeferEvent",
          delay = 1000,
        },
      },
    },
  },
}
