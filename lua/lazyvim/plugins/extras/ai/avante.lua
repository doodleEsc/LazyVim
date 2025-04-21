return {

  {
    "olimorris/codecompanion.nvim",
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
    "saghen/blink.cmp",
    optional = true,
    dependencies = {
      "Kaiser-Yang/blink-cmp-avante",
    },
    opts = {
      sources = {
        -- Add 'avante' to the list
        default = { "avante" },
        providers = {
          avante = {
            module = "blink-cmp-avante",
            name = "Avante",
            opts = {
              kind_icons = {
                Avante = "󰖷",
              },
            },
          },
        },
      },
    },
  },

  {
    "yetone/avante.nvim",
    dev = false,
    event = "VeryLazy",
    lazy = true,
    init = function()
      LazyVim.env.load()
    end,
    version = false, -- set this if you want to always pull the latest change
    build = "make",
    opts = function()
      local endpoint = LazyVim.env.get("OPENAI_BASE_URL")
      local model = LazyVim.env.get("OPENAI_MODEL")
      local proxy = nil
      local max_tokens = LazyVim.env.get("OPENAI_MAX_TOKENS")
      local google_proxy = LazyVim.env.get("GOOGLE_SEARCH_PROXY")

      -- If model contains "openai" or "gpt", set proxy to nil
      if model and (model:lower():find("openai") or model:lower():find("gpt")) then
        proxy = LazyVim.env.get("OPENAI_PROXY")
      end

      return {
        debug = true,
        ---@alias Provider "claude" | "openai" | "azure" | "gemini" | "vertex" | "cohere" | "copilot" | string
        provider = "openai", -- Recommend using Claude
        auto_suggestions_provider = nil, -- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot
        cursor_applying_provider = "openai",
        memory_summary_provider = nil,
        ---@alias Tokenizer "tiktoken" | "hf"
        -- Used for counting tokens and encoding text.
        -- By default, we will use tiktoken.
        -- For most providers that we support we will determine this automatically.
        -- If you wish to use a given implementation, then you can override it here.
        tokenizer = "tiktoken",
        rag_service = {
          enabled = false, -- Enables the rag service, requires OPENAI_API_KEY to be set
          host_mount = os.getenv("HOME"), -- Host mount path for the rag service (docker will mount this path)
          runner = "docker", -- The runner for the rag service, (can use docker, or nix)
          provider = "openai", -- The provider to use for RAG service. eg: openai or ollama
          llm_model = "", -- The LLM model to use for RAG service
          embed_model = "", -- The embedding model to use for RAG service
          endpoint = "https://api.openai.com/v1", -- The API endpoint for RAG service
          docker_extra_args = "", -- Extra arguments to pass to the docker command
        },
        web_search_engine = {
          provider = "google",
          proxy = google_proxy,
          providers = {
            tavily = {
              api_key_name = "TAVILY_API_KEY",
              extra_request_body = {
                include_answer = "basic",
              },
              ---@type WebSearchEngineProviderResponseBodyFormatter
              format_response_body = function(body)
                return body.answer, nil
              end,
            },
            google = {
              api_key_name = "GOOGLE_SEARCH_API_KEY",
              engine_id_name = "GOOGLE_SEARCH_ENGINE_ID",
              extra_request_body = {},
              ---@type WebSearchEngineProviderResponseBodyFormatter
              format_response_body = function(body)
                if body.items ~= nil then
                  local jsn = vim
                    .iter(body.items)
                    :map(function(result)
                      return {
                        title = result.title,
                        link = result.link,
                        snippet = result.snippet,
                      }
                    end)
                    :take(10)
                    :totable()
                  return vim.json.encode(jsn), nil
                end
                return "", nil
              end,
            },
          },
        },
        openai = {
          endpoint = endpoint,
          model = model,
          proxy = proxy,
          max_tokens = tonumber(max_tokens),
          timeout = 300000, -- Timeout in milliseconds
          temperature = 0.5,
        },

        vendors = {
          ["gemini-2.5-pro-1M-free"] = {
            __inherited_from = "openai",
            model = "google/gemini-2.5-pro-exp-03-25:free",
            max_tokens = 1000000,
          },
          ["gemini-2.0-flash-1M"] = {
            __inherited_from = "openai",
            model = "google/gemini-2.0-flash-001",
            max_tokens = 1000000,
          },
          ["gemini-2.0-pro-2M-free"] = {
            __inherited_from = "openai",
            model = "google/gemini-2.0-pro-exp-02-05:free",
            max_tokens = 2000000,
          },

          ["claude-3.7-sonnet-200K-thinking"] = {
            __inherited_from = "openai",
            model = "anthropic/claude-3.7-sonnet:thinking",
            max_tokens = 200000,
          },

          ["claude-3.7-sonnet-200K"] = {
            __inherited_from = "openai",
            model = "anthropic/claude-3.7-sonnet",
            max_tokens = 200000,
          },

          ["claude-3.5-haiku-200K"] = {
            __inherited_from = "openai",
            model = "anthropic/claude-3.5-haiku",
            max_tokens = 200000,
          },

          ["deepseek-v3-64K"] = {
            __inherited_from = "openai",
            model = "deepseek/deepseek-chat-v3-0324",
            max_tokens = "64000",
          },

          ["deepseek-r1-164K-thinking"] = {
            __inherited_from = "openai",
            model = "deepseek/deepseek-r1",
            max_tokens = "164000",
          },
        },

        ---Specify the special dual_boost mode
        ---1. enabled: Whether to enable dual_boost mode. Default to false.
        ---2. first_provider: The first provider to generate response. Default to "openai".
        ---3. second_provider: The second provider to generate response. Default to "claude".
        ---4. prompt: The prompt to generate response based on the two reference outputs.
        ---5. timeout: Timeout in milliseconds. Default to 60000.
        ---How it works:
        --- When dual_boost is enabled, avante will generate two responses from the first_provider and second_provider respectively. Then use the response from the first_provider as provider1_output and the response from the second_provider as provider2_output. Finally, avante will generate a response based on the prompt and the two reference outputs, with the default Provider as normal.
        ---Note: This is an experimental feature and may not work as expected.
        dual_boost = {
          enabled = false,
          first_provider = "openai",
          second_provider = "claude",
          prompt = "Based on the two reference outputs below, generate a response that incorporates elements from both but reflects your own judgment and unique perspective. Do not provide any explanation, just give the response directly. Reference Output 1: [{{provider1_output}}], Reference Output 2: [{{provider2_output}}]",
          timeout = 60000, -- Timeout in milliseconds
        },
        behaviour = {
          auto_focus_sidebar = true,
          auto_suggestions = false, -- Experimental stage
          auto_suggestions_respect_ignore = false,
          auto_set_highlight_group = true,
          auto_set_keymaps = true,
          auto_apply_diff_after_generation = false,
          jump_result_buffer_on_finish = false,
          support_paste_from_clipboard = false,
          minimize_diff = true,
          enable_token_counting = true,
          enable_cursor_planning_mode = true,
          enable_claude_text_editor_tool_mode = true,
          use_cwd_as_project_root = false,
        },
        history = {
          max_tokens = 164000,
          storage_path = vim.fn.stdpath("state") .. "/avante",
          paste = {
            extension = "png",
            filename = "pasted-%Y-%m-%d-%H-%M-%S",
          },
        },
        highlights = {
          diff = {
            current = nil,
            incoming = nil,
          },
        },
        mappings = {
          ---@class AvanteConflictMappings
          diff = {
            ours = "co",
            theirs = "ct",
            all_theirs = "ca",
            both = "cb",
            cursor = "cc",
            next = "]x",
            prev = "[x",
          },
          suggestion = {
            accept = "<M-l>",
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
          jump = {
            next = "]]",
            prev = "[[",
          },
          submit = {
            normal = "<CR>",
            insert = "<C-CR>",
          },
          -- NOTE: The following will be safely set by avante.nvim
          ask = "<leader>aa",
          edit = "<leader>ae",
          refresh = "<leader>ar",
          focus = "<leader>af",
          toggle = {
            default = "<leader>at",
            debug = "<leader>ad",
            hint = "<leader>ah",
            suggestion = "<leader>as",
            repomap = "<leader>aR",
          },
          sidebar = {
            apply_all = "A",
            apply_cursor = "a",
            retry_user_request = "r",
            edit_user_request = "e",
            switch_windows = "<Tab>",
            reverse_switch_windows = "<S-Tab>",
            remove_file = "d",
            add_file = "@",
            close = { "<Esc>", "q" },
          },
          files = {
            add_current = "<leader>ac", -- Add current buffer to selected files
          },
          select_model = "<leader>a?", -- Select model command
        },
        windows = {
          ---@alias AvantePosition "right" | "left" | "top" | "bottom" | "smart"
          position = "right",
          wrap = true, -- similar to vim.o.wrap
          width = 30, -- default % based on available width in vertical layout
          height = 30, -- default % based on available height in horizontal layout
          sidebar_header = {
            enabled = true, -- true, false to enable/disable the header
            align = "center", -- left, center, right for title
            rounded = true,
          },
          input = {
            prefix = "> ",
            height = 8, -- Height of the input window in vertical layout
          },
          edit = {
            border = "rounded",
            start_insert = true, -- Start insert mode when opening the edit window
          },
          ask = {
            floating = false, -- Open the 'AvanteAsk' prompt in a floating window
            border = "rounded",
            start_insert = true, -- Start insert mode when opening the ask window
            ---@alias AvanteInitialDiff "ours" | "theirs"
            focus_on_apply = "ours", -- which diff to focus after applying
          },
        },
        --- @class AvanteConflictConfig
        diff = {
          autojump = true,
          --- Override the 'timeoutlen' setting while hovering over a diff (see :help timeoutlen).
          --- Helps to avoid entering operator-pending mode with diff mappings starting with `c`.
          --- Disable by setting to -1.
          override_timeoutlen = 500,
        },
        run_command = {
          -- Only applies to macOS and Linux
          shell_cmd = "sh -c",
        },
        --- @class AvanteHintsConfig
        hints = {
          enabled = true,
        },
        --- @class AvanteRepoMapConfig
        repo_map = {
          ignore_patterns = { "%.git", "%.worktree", "__pycache__", "node_modules" }, -- ignore files matching these
          negate_patterns = {}, -- negate ignore files matching these.
        },
        --- @class AvanteFileSelectorConfig
        file_selector = {
          --- @alias FileSelectorProvider "native" | "fzf" | "mini.pick" | "snacks" | "telescope" | string | fun(params: avante.file_selector.IParams|nil): nil
          provider = "telescope",
          -- Options override for custom providers
          provider_opts = {
            pickers = {
              find_files = {
                find_command = { "fd", "-t=f", "-a" },
                path_display = { "absolute" },
              },
            },
          },
        },
        suggestion = {
          debounce = 600,
          throttle = 600,
        },

        system_prompt = nil,
        disabled_tools = {}, ---@type string[]
        -- The custom_tools type supports both a list and a function that returns a list. Using a function here prevents requiring mcphub before it's loaded
        ---@type AvanteLLMToolPublic[] | fun(): AvanteLLMToolPublic[]
        custom_tools = {},
      }
    end,

    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    -- build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      -- "echasnovski/mini.pick", -- for file_selector provider mini.pick
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      -- "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      -- "ibhagwan/fzf-lua", -- for file_selector provider fzf
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      -- "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
    config = function(_, opts)
      require("avante_lib").load()
      local avante = require("avante")
      avante.setup(opts)
    end,
  },
}
