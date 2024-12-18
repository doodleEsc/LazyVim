return {
  {
    "doodleEsc/Lazy-custom",
    dev = true,
    event = "VeryLazy",
    keys = {
      {
        "<C-Space>",
        function()
          Snacks.terminal()
        end,
        mode = "n",
        desc = "Terminal (cwd)",
      },
      {
        "<leader>ft",
        function()
          Snacks.terminal(nil, { cwd = LazyVim.root() })
        end,
        mode = "n",
        desc = "Terminal (Root Dir)",
      },
      {
        "<c-/>",
        function()
          Snacks.terminal(nil, { cwd = LazyVim.root() })
        end,
        mode = "n",
        desc = "Terminal (Root Dir)",
      },
      {
        "<c-_>",
        function()
          Snacks.terminal(nil, { cwd = LazyVim.root() })
        end,
        mode = "n",
        desc = "which_key_ignore",
      },
    },
    opts = {
      opts = {
        jumpoptions = "stack",
      },
      globals = {
        clipboard = {
          name = "uniClipboard",
          copy = {
            ["+"] = "clipboard-provider copy",
            ["*"] = "clipboard-provider copy",
          },
          paste = {
            ["+"] = "clipboard-provider paste",
            ["*"] = "clipboard-provider paste",
          },
          cache_enabled = 1,
        },
      },
    },
  },
}
