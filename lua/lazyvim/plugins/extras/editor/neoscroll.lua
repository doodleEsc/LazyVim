return {
  {
    "karb94/neoscroll.nvim",
    lazy = true,
    opts = {
      mappings = nil,
      hide_cursor = false, -- Hide cursor while scrolling
      stop_eof = true, -- Stop at <EOF> when scrolling downwards
      respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
      cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
      easing = "linear", -- Default easing function
      pre_hook = nil, -- Function to run before the scrolling animation starts
      post_hook = nil, -- Function to run after the scrolling animation ends
      performance_mode = false, -- Disable "Performance Mode" on all buffers.
    },
    keys = {
      {
        "<C-d>",
        function()
          require("neoscroll").ctrl_d({ duration = 150 })
        end,
        mode = { "n", "v", "x" },
        desc = "Smoothing Scroll Down",
      },
      {
        "<C-u>",
        function()
          require("neoscroll").ctrl_u({ duration = 150 })
        end,
        mode = { "n", "v", "x" },
        desc = "Smoothing Scroll Up",
      },
      {
        "<C-b>",
        function()
          require("neoscroll").ctrl_b({ duration = 450 })
        end,
        mode = { "n", "v", "x" },
        desc = "Smoothing Page Up",
      },
      {
        "<C-f>",
        function()
          require("neoscroll").ctrl_f({ duration = 450 })
        end,
        mode = { "n", "v", "x" },
        desc = "Smoothing Page Down",
      },

      {
        "<C-y>",
        function()
          require("neoscroll").scroll(-0.1, { move_cursor = false, duration = 100 })
        end,
        mode = { "n", "v", "x" },
        desc = "Smoothing Page Down",
      },

      {
        "<C-e>",
        function()
          require("neoscroll").scroll(0.1, { move_cursor = false, duration = 100 })
        end,
        mode = { "n", "v", "x" },
        desc = "Smoothing Page Down",
      },
    },
  },
}
