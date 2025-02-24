return {
  {
    "milanglacier/minuet-ai.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },

    init = function()
      LazyVim.env.load()
    end,
    opts = function()
      local endpoint = LazyVim.env.get("QWEN_URL")
      local model = LazyVim.env.get("QWEN_MODEL")

      return {
        -- enable or disable auto-completion. note that you still need to add
        -- minuet to your cmp/blink sources. this option controls whether cmp/blink
        -- will attempt to invoke minuet when minuet is included in cmp/blink
        -- sources. this setting has no effect on manual completion; minuet will
        -- always be enabled when invoked manually. you can use the command
        -- `minuet cmp/blink toggle` to toggle this option.
        cmp = {
          enable_auto_complete = false,
        },
        blink = {
          enable_auto_complete = true,
        },
        virtualtext = {
          -- specify the filetypes to enable automatic virtual text completion,
          -- e.g., { 'python', 'lua' }. note that you can still invoke manual
          -- completion even if the filetype is not on your auto_trigger_ft list.
          auto_trigger_ft = {},
          -- specify file types where automatic virtual text completion should be
          -- disabled. this option is useful when auto-completion is enabled for
          -- all file types i.e., when auto_trigger_ft = { '*' }
          auto_trigger_ignore_ft = {},
          -- keymap = {
          --   accept = nil,
          --   accept_line = nil,
          --   accept_n_lines = nil,
          --   -- cycle to next completion item, or manually invoke completion
          --   next = nil,
          --   -- cycle to prev completion item, or manually invoke completion
          --   prev = nil,
          --   dismiss = nil,
          -- },

          keymap = {
            -- accept whole completion
            accept = "<A-A>",
            -- accept one line
            accept_line = "<A-a>",
            -- accept n lines (prompts for number)
            -- e.g. "A-z 2 CR" will accept 2 lines
            accept_n_lines = "<A-z>",
            -- Cycle to prev completion item, or manually invoke completion
            prev = "<A-[>",
            -- Cycle to next completion item, or manually invoke completion
            next = "<A-]>",
            dismiss = "<A-e>",
          },

          -- whether show virtual text suggestion when the completion menu
          -- (nvim-cmp or blink-cmp) is visible.

          show_on_completion_menu = false,
        },
        provider = "openai_fim_compatible",
        provider_options = {
          openai_fim_compatible = {
            end_point = endpoint,
            api_key = "QWEN_API_KEY",
            name = "Qwen",
            model = model,
            stream = false,
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
              stop = { "\n\n" },
              max_tokens = 256,
            },
          },
          -- see the documentation in each provider in the following part.
        },
        -- the maximum total characters of the context before and after the cursor
        -- 16000 characters typically equate to approximately 4,000 tokens for
        -- llms.
        context_window = 16000,
        -- when the total characters exceed the context window, the ratio of
        -- context before cursor and after cursor, the larger the ratio the more
        -- context before cursor will be used. this option should be between 0 and
        -- 1, context_ratio = 0.75 means the ratio will be 3:1.
        context_ratio = 0.75,
        throttle = 1000, -- only send the request every x milliseconds, use 0 to disable throttle.
        -- debounce the request in x milliseconds, set to 0 to disable debounce
        debounce = 1000,
        -- control notification display for request status
        -- notification options:
        -- false: disable all notifications (use boolean false, not string "false")
        -- "debug": display all notifications (comprehensive debugging)
        -- "verbose": display most notifications
        -- "warn": display warnings and errors only
        -- "error": display errors only
        notify = "debug",
        -- the request timeout, measured in seconds. when streaming is enabled
        -- (stream = true), setting a shorter request_timeout allows for faster
        -- retrieval of completion items, albeit potentially incomplete.
        -- conversely, with streaming disabled (stream = false), a timeout
        -- occurring before the llm returns results will yield no completion items.
        request_timeout = 10,
        -- if completion item has multiple lines, create another completion item
        -- only containing its first line. this option only has impact for cmp and
        -- blink. for virtualtext, no single line entry will be added.
        add_single_line_entry = true,
        -- the number of completion items encoded as part of the prompt for the
        -- chat llm. for fim model, this is the number of requests to send. it's
        -- important to note that when 'add_single_line_entry' is set to true, the
        -- actual number of returned items may exceed this value. additionally, the
        -- llm cannot guarantee the exact number of completion items specified, as
        -- this parameter serves only as a prompt guideline.
        n_completions = 3,
        -- defines the length of non-whitespace context after the cursor used to
        -- filter completion text. set to 0 to disable filtering.
        --
        -- example: with after_cursor_filter_length = 3 and context:
        --
        -- "def fib(n):\n|\n\nfib(5)" (where | represents cursor position),
        --
        -- if the completion text contains "fib", then "fib" and subsequent text
        -- will be removed. this setting filters repeated text generated by the
        -- llm. a large value (e.g., 15) is recommended to avoid false positives.
        after_cursor_filter_length = 20,
        -- proxy port to use
        proxy = nil,
        -- -- see the documentation in the `prompt` section
        -- default_template = {
        --   template = "...",
        --   prompt = "...",
        --   guidelines = "...",
        --   n_completion_template = "...",
        -- },
        -- default_fim_template = {
        --   prompt = "...",
        --   suffix = "...",
        -- },
        -- default_few_shots = { "..." },
        -- default_chat_input = { "..." },
        -- -- config options for `minuet change_preset` command
        -- presets = {},
      }
    end,
    config = function(_, opts)
      require("minuet").setup(opts)
    end,
  },

  -- {
  --   "saghen/blink.cmp",
  --   optional = true,
  --   opts = function(_, opts)
  --     if opts.sources.providers == nil then
  --       opts.sources.providers = {}
  --     end
  --
  --     opts.sources.providers.minuet = {
  --       name = "minuet",
  --       module = "minuet.blink",
  --       score_offset = 8, -- Gives minuet higher priority among suggestions
  --     }
  --
  --     table.insert(opts.sources.default, "minuet")
  --
  --     opts.completion.trigger = { prefetch_on_insert = true }
  --
  --     opts.keymap["<A-y>"] = require("minuet").make_blink_map()
  --
  --     return opts
  --   end,
  -- },

  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      keymap = {
        ["<A-y>"] = {
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
}
