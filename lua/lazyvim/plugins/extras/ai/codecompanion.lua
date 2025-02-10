return {

  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>a", group = "AI" },
      },
    },
  },

  {
    "olimorris/codecompanion.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    init = function()
      LazyVim.env.load()
    end,
    keys = {
      {
        "<leader>ai",
        "<cmd>CodeCompanionChat<cr>",
        mode = "n",
        desc = "LLM Chat",
      },
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
          inline = {
            adapter = "openai",
          },
          cmd = {
            adapter = "openai",
          },
        },
        adapters = {
          openai = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              env = {
                url = endpoint,
                api_key = api_key,
                chat_url = "/v1/chat/completions",
              },
              schema = {
                model = {
                  default = model,
                },
                temperature = {
                  default = 0.1,
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
}
