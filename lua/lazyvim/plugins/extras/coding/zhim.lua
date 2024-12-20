return {

  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>z", group = "Input Method" },
      },
    },
  },

  {
    "doodleEsc/zhim.nvim",
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
    opts = function()
      local ret = {
        enabled = true,
        command = "im-select.exe",
        default_im = { "1033" },
        zh_im = { "2052" },
        default_events = { "VimEnter", "FocusGained", "InsertLeave", "CmdlineLeave" },
        zh_events = { "InsertEnter" },
        nodes = { "comment", "comment_content", "string", "string_content" },
        ft = { "markdown", "AvanteInput" },
      }

      local os = vim.uv.os_uname().sysname

      if os == "Linux" then
        ret.command = "fcitx5-remote"
        ret.default_im = { "-s", "keyboard-us" }
        ret.zh_im = { "-s", "rime" }
      end

      return ret
    end,
  },
}
