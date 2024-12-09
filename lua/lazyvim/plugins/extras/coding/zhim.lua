return {
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
        -- ft = { "markdown", "AvanteInput" },
      }

      if LazyVim.get_os() == "Linux" then
        ret.command = "fcitx5-remote"
        ret.default_im = { "-s", "keyboard-us" }
        ret.zh_im = { "-s", "rime" }
      end

      return ret
    end,
  },
}
