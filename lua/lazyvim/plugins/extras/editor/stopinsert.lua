return {
  {
    "doodleEsc/stopinsert.nvim",
    dev = true,
    event = "VeryLazy",
    dependencies = {
      "saghen/blink.cmp",
    },
    opts = {
      idle_time_ms = 2000,
      show_popup_msg = false,
      clear_popup_ms = 5000,
      disabled_filetypes = {
        "TelescopePrompt",
        "checkhealth",
        "AvanteInput",
        "help",
        "lspinfo",
        "mason",
        "neo%-tree*",
      },
      stopinsert_guard = function()
        return require("blink.cmp").is_documentation_visible()
      end,
    },
  },
}
