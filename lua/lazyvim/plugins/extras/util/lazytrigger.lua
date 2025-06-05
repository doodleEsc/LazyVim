return {
  {
    "doodleEsc/LazyTrigger.nvim",
    event = "VeryLazy",
    dev = true,
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
