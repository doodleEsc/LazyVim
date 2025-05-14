return {
  {
    "milanglacier/minuet-ai.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },

    -- init = function()
    --   LazyVim.env.load()
    -- end,
    opts = function()
      return {
        -- Enable or disable auto-completion. Note that you still need to add
        -- Minuet to your cmp/blink sources. This option controls whether cmp/blink
        -- will attempt to invoke minuet when minuet is included in cmp/blink
        -- sources. This setting has no effect on manual completion; Minuet will
        -- always be enabled when invoked manually. You can use the command
        -- `Minuet cmp/blink toggle` to toggle this option.
        cmp = {
          enable_auto_complete = false,
        },
        blink = {
          enable_auto_complete = false,
        },
        -- LSP is recommended only for built-in completion. If you are using
        -- `cmp` or `blink`, utilizing LSP for code completion from Minuet is *not*
        -- recommended.
        lsp = {
          enabled_ft = {},
          -- Filetypes excluded from LSP activation. Useful when `enabled_ft` = { '*' }
          disabled_ft = {},
          -- Enables automatic completion triggering using `vim.lsp.completion.enable`
          enabled_auto_trigger_ft = {},
          -- Filetypes excluded from autotriggering. Useful when `enabled_auto_trigger_ft` = { '*' }
          disabled_auto_trigger_ft = {},
          -- if true, when the user is using blink or nvim-cmp, warn the user
          -- that they should use the native source instead.
          warn_on_blink_or_cmp = true,
          -- See README section [Built-in Completion, Mini.Completion, and LSP
          -- Setup] for more details on this option.
          adjust_indentation = true,
        },
        virtualtext = {
          -- Specify the filetypes to enable automatic virtual text completion,
          -- e.g., { 'python', 'lua' }. Note that you can still invoke manual
          -- completion even if the filetype is not on your auto_trigger_ft list.
          auto_trigger_ft = {},
          -- specify file types where automatic virtual text completion should be
          -- disabled. This option is useful when auto-completion is enabled for
          -- all file types i.e., when auto_trigger_ft = { '*' }
          auto_trigger_ignore_ft = {},
          keymap = {
            accept = nil,
            accept_line = nil,
            -- accept n lines (prompts for number)
            accept_n_lines = nil,
            -- Cycle to next completion item, or manually invoke completion
            next = nil,
            -- Cycle to prev completion item, or manually invoke completion
            prev = nil,
            dismiss = nil,
          },
          -- Whether show virtual text suggestion when the completion menu
          -- (nvim-cmp or blink-cmp) is visible.
          show_on_completion_menu = false,
        },
        -- provider = "openai_compatible",
        provider = "openai_fim_compatible",
        -- the maximum total characters of the context before and after the cursor
        -- 16000 characters typically equate to approximately 4,000 tokens for
        -- LLMs.
        context_window = 16000,
        -- when the total characters exceed the context window, the ratio of
        -- context before cursor and after cursor, the larger the ratio the more
        -- context before cursor will be used. This option should be between 0 and
        -- 1, context_ratio = 0.75 means the ratio will be 3:1.
        context_ratio = 0.75,
        throttle = 1000, -- only send the request every x milliseconds, use 0 to disable throttle.
        -- debounce the request in x milliseconds, set to 0 to disable debounce
        debounce = 400,
        -- Control notification display for request status
        -- Notification options:
        -- false: Disable all notifications (use boolean false, not string "false")
        -- "debug": Display all notifications (comprehensive debugging)
        -- "verbose": Display most notifications
        -- "warn": Display warnings and errors only
        -- "error": Display errors only
        notify = "debug",
        -- The request timeout, measured in seconds. When streaming is enabled
        -- (stream = true), setting a shorter request_timeout allows for faster
        -- retrieval of completion items, albeit potentially incomplete.
        -- Conversely, with streaming disabled (stream = false), a timeout
        -- occurring before the LLM returns results will yield no completion items.
        request_timeout = 30,
        -- If completion item has multiple lines, create another completion item
        -- only containing its first line. This option only has impact for cmp and
        -- blink. For virtualtext, no single line entry will be added.
        add_single_line_entry = true,
        -- The number of completion items encoded as part of the prompt for the
        -- chat LLM. For FIM model, this is the number of requests to send. It's
        -- important to note that when 'add_single_line_entry' is set to true, the
        -- actual number of returned items may exceed this value. Additionally, the
        -- chat LLM cannot guarantee the exact number of completion items
        -- specified, as this parameter serves only as a prompt guideline.
        n_completions = 2,
        -- Defines the length of non-whitespace context after the cursor used to
        -- filter completion text. Set to 0 to disable filtering.
        --
        -- Example: With after_cursor_filter_length = 3 and context:
        --
        -- "def fib(n):\n|\n\nfib(5)" (where | represents cursor position),
        --
        -- if the completion text contains "fib", then "fib" and subsequent text
        -- will be removed. This setting filters repeated text generated by the
        -- LLM. A large value (e.g., 15) is recommended to avoid false positives.
        after_cursor_filter_length = 20,
        proxy = nil,
        provider_options = {
          -- Qwen
          openai_fim_compatible = {
            end_point = "https://openrouter.ai/api/v1/completions",
            api_key = "OPENAI_API_KEY",
            name = "Qwen",
            model = "qwen/qwen-2.5-coder-32b-instruct",
            stream = true,
            template = {
              prompt = function(context_before_cursor, context_after_cursor)
                return "<|fim_prefix|>"
                  .. context_before_cursor
                  .. "<|fim_suffix|>"
                  .. context_after_cursor
                  .. "<|fim_middle|>"
              end,
              suffix = false,
            },
            optional = {
              stop = nil,
              top_p = 0.95,
              temperature = 0.3,
              max_tokens = 256,
              provider = {
                quantizations = {
                  "fp8",
                },
              },
            },
          },

          openai_compatible = {
            end_point = "https://openrouter.ai/api/v1/chat/completions",
            api_key = "OPENAI_API_KEY",
            -- model = "anthropic/claude-3.5-sonnet",
            model = "qwen/qwen-2.5-coder-32b-instruct",
            name = "Openrouter",
            stream = true,
            optional = {
              max_tokens = 256,
              top_p = 0.9,
            },
          },
        },
        presets = {},
      }
    end,
    -- config = function(_, opts)
    --   require("minuet").setup(opts)
    -- end,
  },

  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      keymap = {
        ["<C-y>"] = {
          function(cmp)
            cmp.show({ providers = { "minuet" } })
          end,
        },
      },
      sources = {
        -- if you want to use auto-complete
        default = { "minuet" },
        providers = {
          minuet = {
            name = "minuet",
            module = "minuet.blink",
            score_offset = 100,
          },
        },
      },
    },
  },

  {
    "nvim-cmp",
    optional = true,
    opts = function(_, opts)
      -- if you wish to use autocomplete
      table.insert(opts.sources, 1, {
        name = "minuet",
        group_index = 1,
        priority = 100,
      })

      opts.performance = {
        -- It is recommended to increase the timeout duration due to
        -- the typically slower response speed of LLMs compared to
        -- other completion sources. This is not needed when you only
        -- need manual completion.
        fetching_timeout = 2000,
      }

      opts.mapping = vim.tbl_deep_extend("force", opts.mapping or {}, {
        -- if you wish to use manual complete
        ["<A-y>"] = require("minuet").make_cmp_map(),
      })
    end,
  },
}
