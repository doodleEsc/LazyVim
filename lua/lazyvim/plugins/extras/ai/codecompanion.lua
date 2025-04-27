return {

  {
    "yetone/avante.nvim",
    enabled = false,
  },

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
      local model = LazyVim.env.get("OPENAI_MODEL")

      local proxy = nil
      local max_tokens = LazyVim.env.get("OPENAI_MAX_TOKENS")
      local temperature = LazyVim.env.get("OPENAI_TEMPERATURE")
      local google_proxy = LazyVim.env.get("GOOGLE_SEARCH_PROXY")

      -- If model contains "openai" or "gpt", set proxy to nil
      if model and (model:lower():find("openai") or model:lower():find("gpt")) then
        proxy = LazyVim.env.get("OPENAI_PROXY")
      end

      -- If model contains "google" or "gemini", set temperature greater than 1
      if model and (model:lower():find("google") or model:lower():find("gemini")) then
        temperature = 1.0
      end

      return {
        strategies = {
          chat = {
            adapter = "openrouter",
            tools = {
              ["mcp"] = {
                -- calling it in a function would prevent mcphub from being loaded before it's needed
                callback = function()
                  return require("mcphub.extensions.codecompanion")
                end,
                description = "Call tools and resources from the MCP Servers",
              },
            },
          },
          inline = {
            adapter = "openrouter",
          },
          cmd = {
            adapter = "openrouter",
          },
        },
        adapters = {
          openrouter = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              env = {
                url = endpoint,
                api_key = "OPENAI_API_KEY",
                chat_url = "/chat/completions",
                models_endpoint = "/models",
              },

              opts = {
                proxy = proxy,
              },
              schema = {
                model = {
                  default = model,
                },
                temperature = {
                  order = 2,
                  mapping = "parameters",
                  type = "number",
                  optional = true,
                  default = tonumber(temperature),
                  desc = "What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. We generally recommend altering this or top_p but not both.",
                  validate = function(n)
                    return n >= 0 and n <= 2, "Must be between 0 and 2"
                  end,
                },
                max_completion_tokens = {
                  order = 3,
                  mapping = "parameters",
                  type = "integer",
                  optional = true,
                  default = max_tokens,
                  desc = "An upper bound for the number of tokens that can be generated for a completion.",
                  validate = function(n)
                    return n > 0, "Must be greater than 0"
                  end,
                },
                stop = {
                  order = 4,
                  mapping = "parameters",
                  type = "string",
                  optional = true,
                  default = nil,
                  desc = "Sets the stop sequences to use. When this pattern is encountered the LLM will stop generating text and return. Multiple stop patterns may be set by specifying multiple separate stop parameters in a modelfile.",
                  validate = function(s)
                    return s:len() > 0, "Cannot be an empty string"
                  end,
                },
                logit_bias = {
                  order = 5,
                  mapping = "parameters",
                  type = "map",
                  optional = true,
                  default = nil,
                  desc = "Modify the likelihood of specified tokens appearing in the completion. Maps tokens (specified by their token ID) to an associated bias value from -100 to 100. Use https://platform.openai.com/tokenizer to find token IDs.",
                  subtype_key = {
                    type = "integer",
                  },
                  subtype = {
                    type = "integer",
                    validate = function(n)
                      return n >= -100 and n <= 100, "Must be between -100 and 100"
                    end,
                  },
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
