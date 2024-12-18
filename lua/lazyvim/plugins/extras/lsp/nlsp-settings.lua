return {
  {
    "tamago324/nlsp-settings.nvim",
    lazy = true,
    command = { "LspSetting" },
    opts = {
      config_home = vim.fn.stdpath("config") .. "/nlsp-settings",
      local_settings_dir = ".nlsp-settings",
      local_settings_root_markers_fallback = { ".git" },
      append_default_schemas = true,
      loader = "json",
    },
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "tamago324/nlsp-settings.nvim",
    },
  },
}
