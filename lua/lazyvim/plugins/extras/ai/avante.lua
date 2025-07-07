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
    event = "VeryLazy",
    lazy = true,
    init = function()
      LazyVim.env.load()
    end,
    version = false, -- set this if you want to always pull the latest change
    build = "make",
    keys = {
      {
        "<leader>a+",
        function()
          local tree_ext = require("avante.extensions.nvim_tree")
          tree_ext.add_file()
        end,
        desc = "Select file in NvimTree",
      },
      {
        "<leader>a-",
        function()
          local tree_ext = require("avante.extensions.nvim_tree")
          tree_ext.remove_file()
        end,
        desc = "Deselect file in NvimTree",
      },
    },
    opts = function()
      local endpoint = LazyVim.env.get("OPENAI_BASE_URL")
      local model = LazyVim.env.get("OPENAI_MODEL")
      local temperature = LazyVim.env.get("OPENAI_TEMPERATURE")
      local rag_service_enabled = LazyVim.env.get("RAG_SERVICE_ENABLED") == "true"
      local google_proxy = LazyVim.env.get("GOOGLE_SEARCH_PROXY") or false
      local proxy = nil

      local override_prompt_dir = vim.fn.stdpath("config") .. "/avante/templates"
      local global_rule_dir = vim.fn.stdpath("config") .. "/avante/rules"

      -- If model contains "openai" or "gpt", set proxy to nil
      if model and (model:lower():find("openai") or model:lower():find("gpt")) then
        proxy = LazyVim.env.get("OPENAI_PROXY")
      end

      return {
        debug = false,
        ---@alias avante.Mode "agentic" | "legacy"
        mode = "agentic",
        ---@alias Provider "claude" | "openai" | "azure" | "gemini" | "vertex" | "cohere" | "copilot" | string
        provider = "openai", -- Recommend using Claude
        auto_suggestions_provider = nil, -- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot
        cursor_applying_provider = "llama-3.3-70b-instruct",
        memory_summary_provider = "gpt-4.1",
        ---@alias Tokenizer "tiktoken" | "hf"
        -- Used for counting tokens and encoding text.
        -- By default, we will use tiktoken.
        -- For most providers that we support we will determine this automatically.
        -- If you wish to use a given implementation, then you can override it here.
        tokenizer = "tiktoken",
        rag_service = {
          enabled = rag_service_enabled, -- Enables the rag service, requires OPENAI_API_KEY to be set
          host_mount = os.getenv("HOME"), -- Host mount path for the rag service (docker will mount this path)
          runner = "docker", -- The runner for the rag service, (can use docker, or nix)
          llm = {
            provider = "openrouter",
            endpoint = "https://openrouter.ai/api/v1",
            api_key = "OPENAI_API_KEY",
            model = "openai/gpt-4o-mini",
          },
          embed = {
            provider = "ollama", -- The embedding provider
            endpoint = "http://192.168.50.29:11434", -- The embedding API endpoint
            api_key = nil, -- The environment variable name for the embedding API key
            model = "nomic-embed-text", -- The embedding model name
            extra = { -- Extra configuration options for the embedding model
              embed_batch_size = 25,
            },
          },
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
        providers = {
          ---@type AvanteSupportedProvider
          openai = {
            endpoint = endpoint,
            model = model,
            timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
            proxy = proxy,
            extra_request_body = {
              temperature = tonumber(temperature),
              max_completion_tokens = 16384, -- Increase this to include reasoning tokens (for reasoning models)
              reasoning_effort = "low", -- low|medium|high, only used for reasoning models
            },
            use_ReAct_prompt = false,
          },
          ["llama-3.3-70b-instruct"] = {
            __inherited_from = "openai",
            model = "meta-llama/llama-3.3-70b-instruct",
            max_tokens = 1000000,
          },
          ["gemini-2.0-flash-lite-001"] = {
            __inherited_from = "openai",
            model = "google/gemini-2.0-flash-lite-001",
            max_tokens = 1000000,
          },
          ["claude-3.7-sonnet-thinking"] = {
            __inherited_from = "openai",
            model = "anthropic/claude-3.7-sonnet:thinking",
            max_tokens = 200000,
          },
          ["claude-3.7-sonnet"] = {
            __inherited_from = "openai",
            model = "anthropic/claude-3.7-sonnet",
            max_tokens = 200000,
          },
          ["claude-3.5-sonnet"] = {
            __inherited_from = "openai",
            model = "anthropic/claude-3.5-sonnet",
            max_tokens = 200000,
          },
          ["gpt-4.1"] = {
            __inherited_from = "openai",
            model = "openai/gpt-4.1",
            max_tokens = 1000000,
          },
          ["o4-mini"] = {
            __inherited_from = "openai",
            model = "openai/o4-mini",
            max_tokens = 200000,
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
          auto_focus_sidebar = false,
          auto_suggestions = false, -- Experimental stage
          auto_suggestions_respect_ignore = false,
          auto_set_highlight_group = true,
          auto_set_keymaps = true,
          auto_apply_diff_after_generation = false,
          jump_result_buffer_on_finish = false,
          support_paste_from_clipboard = false,
          minimize_diff = true,
          enable_token_counting = true,
          use_cwd_as_project_root = false,
          auto_focus_on_diff_view = false,
          ---@type boolean | string[] -- true: auto-approve all tools, false: normal prompts, string[]: auto-approve specific tools by name
          auto_approve_tool_permissions = false, -- Default: show permission prompts for all tools
          auto_check_diagnostics = true,
        },
        prompt_logger = { -- logs prompts to disk (timestamped, for replay/debugging)
          enabled = true, -- toggle logging entirely
          -- log_dir = Utils.join_paths(vim.fn.stdpath("cache"), "avante_prompts"), -- directory where logs are saved
          fortune_cookie_on_success = false, -- shows a random fortune after each logged prompt (requires `fortune` installed)
          next_prompt = {
            normal = "<M-n>", -- load the next (newer) prompt log in normal mode
            insert = "<M-n>",
          },
          prev_prompt = {
            normal = "<M-p>", -- load the previous (older) prompt log in normal mode
            insert = "<M-p>",
          },
        },
        history = {
          max_tokens = 4096,
          carried_entry_count = nil,
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
        img_paste = {
          url_encode_path = true,
          template = "\nimage: $FILE_PATH\n",
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
          cancel = {
            normal = { "<C-c>", "<Esc>", "q" },
            insert = { "<C-c>" },
          },
          -- NOTE: The following will be safely set by avante.nvim
          ask = "<leader>aa",
          new_ask = "<leader>an",
          edit = "<leader>ae",
          refresh = "<leader>ar",
          focus = "<leader>af",
          stop = "<leader>aS",
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
            close = { "q" },
            ---@alias AvanteCloseFromInput { normal: string | nil, insert: string | nil }
            ---@type AvanteCloseFromInput | nil
            close_from_input = nil, -- e.g., { normal = "<Esc>", insert = "<C-d>" }
          },
          files = {
            add_current = "<leader>ac", -- Add current buffer to selected files
            add_all_buffers = "<leader>aB", -- Add all buffer files to selected files
          },
          select_model = "<leader>a?", -- Select model command
          select_history = "<leader>ah", -- Select history command
          confirm = {
            focus_window = "<C-w>f",
            code = "c",
            resp = "r",
            input = "i",
          },
        },
        windows = {
          ---@alias AvantePosition "right" | "left" | "top" | "bottom" | "smart"
          ---@type AvantePosition
          position = "right",
          fillchars = "eob: ",
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
            height = 12, -- Height of the input window in vertical layout
          },
          edit = {
            border = { " ", " ", " ", " ", " ", " ", " ", " " },
            start_insert = true, -- Start insert mode when opening the edit window
          },
          ask = {
            floating = false, -- Open the 'AvanteAsk' prompt in a floating window
            border = { " ", " ", " ", " ", " ", " ", " ", " " },
            start_insert = true, -- Start insert mode when opening the ask window
            ---@alias AvanteInitialDiff "ours" | "theirs"
            ---@type AvanteInitialDiff
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
        --- @class AvanteHintsConfig
        hints = {
          enabled = true,
        },
        --- @class AvanteRepoMapConfig
        repo_map = {
          ignore_patterns = { "%.git", "%.worktree", "__pycache__", "node_modules" }, -- ignore files matching these
          negate_patterns = {}, -- negate ignore files matching these.
        },
        selector = {
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
          exclude_auto_select = { "NvimTree" }, -- List of items to exclude from auto selection
        },
        input = {
          provider = "native",
          provider_opts = {},
        },
        suggestion = {
          debounce = 600,
          throttle = 600,
        },
        system_prompt = nil,
        override_prompt_dir = override_prompt_dir,
        rules = {
          project_dir = nil,
          global_dir = global_rule_dir,
        },
        disabled_tools = {
          "git_commit",
          "git_diff",
          "undo_edit",
          "read_definitions",
          "read_file_toplevel_symbols",
        }, ---@type string[]
        -- The custom_tools type supports both a list and a function that returns a list. Using a function here prevents requiring mcphub before it's loaded
        ---@type AvanteLLMToolPublic[] | fun(): AvanteLLMToolPublic[]
        custom_tools = {
          {
            name = "restart_lsp_server", -- Unique name for the tool
            description = "Restarts the language server (LSP). This action is required to fix import errors after installing new dependencies. A reason for the restart must be provided.", -- Description shown to AI
            param = { -- Input parameters
              type = "table",
              fields = {
                {
                  name = "reason",
                  description = "The reason why the language server needs to be restarted (e.g., 'to load the new 'golang.org/x/tools' dependency').",
                  type = "string",
                  -- This field is required by default (optional = false)
                },
              },
            },
            returns = { -- Expected return values
              {
                name = "status",
                description = "A confirmation that the restart command was executed.",
                type = "string",
              },
            },
            func = function(params, on_log, on_complete) -- Custom function to execute
              -- Check if the reason was provided, with a fallback just in case
              local reason = params.reason or "No reason specified"
              -- Use vim.notify to show the reason to the user
              vim.notify("Restarting LSP server: " .. reason, vim.log.levels.INFO)
              -- Execute the core command
              vim.cmd([[LspRestart]])
              -- Return a success message to the Agent to confirm the action was taken.
              return "LSP server restart command issued successfully."
            end,
          },
        },
        ---@type AvanteSlashCommand[]
        slash_commands = {},
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
      "nvim-tree/nvim-tree.lua", -- or echasnovski/mini.icons
      -- "zbirenbaum/copilot.lua", -- for providers='copilot'
      -- {
      --   -- support for image pasting
      --   "HakonHarnes/img-clip.nvim",
      --   event = "VeryLazy",
      --   opts = {
      --     -- recommended settings
      --     default = {
      --       embed_image_as_base64 = false,
      --       prompt_for_file_name = false,
      --       drag_and_drop = {
      --         insert_mode = true,
      --       },
      --       -- required for Windows users
      --       use_absolute_path = true,
      --     },
      --   },
      -- },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante", "AvanteTodos" },
        },
        ft = { "markdown", "Avante", "AvanteTodos" },
      },
    },
  },
}
