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
          preselect = false,
          auto_insert = true,
        },
      },
    },
    keymap = {
      -- set to 'none' to disable the 'default' preset
      preset = "none",

      ["<C-e>"] = { "hide", "fallback" },

      ["<Tab>"] = {
        function(cmp)
          if cmp.snippet_active() then
            return cmp.accept()
          else
            return cmp.select_and_accept()
          end
        end,
        "snippet_forward",
        "fallback",
      },
      ["<S-Tab>"] = { "snippet_backward", "fallback" },

      ["<Up>"] = { "select_prev", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
      ["<C-p>"] = { "select_prev", "fallback" },
      ["<C-n>"] = { "select_next", "fallback" },

      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },

      ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },

      ["<CR>"] = { "select_and_accept", "fallback" },

      -- term = {},
    },
  },
}

