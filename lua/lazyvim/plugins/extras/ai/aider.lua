return {

  {
    "GeorgesAlkhouri/nvim-aider",
    cmd = "Aider",
    -- Example key mappings for common actions:
    build = "pipx install aider-chat",
    keys = {
      { "<leader>aa", "<cmd>Aider toggle<cr>", desc = "Toggle Aider" },
      { "<leader>as", "<cmd>Aider send<cr>", desc = "Send to Aider", mode = { "n", "v" } },
      { "<leader>ac", "<cmd>Aider command<cr>", desc = "Aider Commands" },
      { "<leader>ab", "<cmd>Aider buffer<cr>", desc = "Send Buffer" },
      { "<leader>a=", "<cmd>Aider add<cr>", desc = "Add File" },
      { "<leader>a-", "<cmd>Aider drop<cr>", desc = "Drop File" },
      { "<leader>ar", "<cmd>Aider add readonly<cr>", desc = "Add Read-Only" },
      -- Example nvim-tree.lua integration if needed
      { "<leader>a=", "<cmd>AiderTreeAddFile<cr>", desc = "Add File from Tree to Aider", ft = "NvimTree" },
      { "<leader>a-", "<cmd>AiderTreeDropFile<cr>", desc = "Drop File from Tree from Aider", ft = "NvimTree" },
    },
    dependencies = {
      "folke/snacks.nvim",
      "nvim-tree/nvim-tree.lua",
    },
    opts = function()
      return {
        -- Command that executes Aider
        aider_cmd = "aider",
        -- Command line arguments passed to aider
        args = {
          "--no-auto-commits",
          "--pretty",
          "--stream",
        },
        -- Theme colors (automatically uses Catppuccin flavor if available)
        theme = {
          user_input_color = "#a6da95",
          tool_output_color = "#8aadf4",
          tool_error_color = "#ed8796",
          tool_warning_color = "#eed49f",
          assistant_output_color = "#c6a0f6",
          completion_menu_color = "#cad3f5",
          completion_menu_bg_color = "#24273a",
          completion_menu_current_color = "#181926",
          completion_menu_current_bg_color = "#f4dbd6",
        },
        -- snacks.picker.layout.Config configuration
        picker_cfg = {
          preset = "vscode",
        },
        -- Other snacks.terminal.Opts options
        config = {
          os = { editPreset = "nvim-remote" },
          gui = { nerdFontsVersion = "3" },
        },
        win = {
          wo = { winbar = "Aider" },
          style = "nvim_aider",
          position = "right",
          keys = {
            term_normal = {
              "<esc>",
              function(self)
                self.esc_timer = self.esc_timer or (vim.uv or vim.loop).new_timer()
                if self.esc_timer:is_active() then
                  self.esc_timer:stop()
                  require("nvim_aider.api").toggle_terminal()
                else
                  self.esc_timer:start(200, 0, function() end)
                  return "<esc>"
                end
              end,
              mode = "t",
              expr = true,
              desc = "Double escape to toggle nvim_aider",
            },
          },
        },
      }
    end,
    config = true,
  },
}
