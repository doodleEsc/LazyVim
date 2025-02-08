return {
  {
    "olimorris/codecompanion.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },

    opts = function()
      local endpoint = LazyVim.env.get("OPENAI_BASE_URL")
      local api_key = LazyVim.env.get("OPENAI_API_KEY")
      local model = LazyVim.env.get("OPENAI_MODEL")

      return {
        strategies = {
          chat = {
            adapter = "openai",
          },
        },
        adapters = {
          openai = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              env = {
                url = endpoint,
                api_key = api_key,
                chat_url = "/chat/completions",
              },
              schema = {
                model = {
                  default = model,
                },
              },
            })
          end,
        },
        opts = {
          -- Set debug logging
          log_level = "DEBUG",
          language = "Chinese",
        },
      }
    end,
  },

  -- {
  --   "MeanderingProgrammer/render-markdown.nvim",
  --   optional = true,
  --   ft = function(_, ft)
  --     vim.list_extend(ft, { "codecompanion" })
  --   end,
  -- },
}
