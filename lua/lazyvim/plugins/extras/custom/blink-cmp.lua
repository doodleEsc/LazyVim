return {
  "saghen/blink.cmp",
  -- optional = true,
  opts = {
    completion = {
      menu = {
        border = "rounded",
        winhighlight = "Normal:BlinkCmpMenu,FloatBorder:None,CursorLine:BlinkCmpMenuSelection,Search:None",
      },
      documentation = {
        window = {
          border = "rounded",
          winhighlight = "Normal:BlinkCmpDoc,FloatBorder:None,EndOfBuffer:BlinkCmpDoc",
        },
      },
      trigger = {
        show_in_snippet = false,
      },
      list = {
        selection = {
          preselect = true,
          auto_insert = false,
        },
      },
    },
    keymap = {
      preset = "enter",
    },
  },
}
