return {
  {
    "doodleEsc/zhim.nvim",
    lazy = true,
    event = "VeryLazy",
    keys = {
      {
        "<leader>zh",
        function()
          require("zhim").toggle()
        end,
        desc = "Toggle IM Change",
      },
    },
    opts = {
      enabled = true,

      -- im-select binary's name, or the binary's full path
      command = { "im-select.exe" },

      -- normal mode im
      default_im = "1033",

      -- insert mode im
      zh_im = "2052",

      -- Restore the default input method state when the following events are triggered
      default_events = { "VimEnter", "FocusGained", "InsertLeave", "CmdlineLeave" },

      -- when to change zh im
      zh_events = { "InsertEnter" },

      -- enabled treesitter nodes
      nodes = { "comment", "comment_content", "string", "string_content" },

      ft = { "markdown", "AvanteInput" },
    },
  },
}
