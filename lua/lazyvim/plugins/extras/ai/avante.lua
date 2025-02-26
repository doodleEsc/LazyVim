return {

  -- {
  --
  --   "saghen/blink.cmp",
  --   opts = {
  --     sources = {
  --       compat = { "avante_commands", "avante_mentions" },
  --       providers = {
  --         avante_commands = {
  --           name = "avante_commands",
  --           module = "blink.compat.source",
  --           score_offset = 11, -- show at a higher priority than lsp
  --           -- opts = {},
  --         },
  --         -- avante_files = {
  --         --   name = "avante_commands",
  --         --   module = "blink.compat.source",
  --         --   score_offset = 100, -- show at a higher priority than lsp
  --         --   -- opts = {},
  --         -- },
  --         avante_mentions = {
  --           name = "avante_mentions",
  --           module = "blink.compat.source",
  --           score_offset = 10, -- show at a higher priority than lsp
  --           -- opts = {},
  --         },
  --       },
  --     },
  --   },
  -- },

  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = {
      "Kaiser-Yang/blink-cmp-avante",
    },
    opts = {
      sources = {
        -- Add 'avante' to the list
        default = { "avante", "lsp", "path", "luasnip", "buffer" },
        providers = {
          avante = {
            module = "blink-cmp-avante",
            name = "Avante",
            opts = {
              -- options for blink-cmp-avante
            },
          },
        },
      },
    },
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

      return {
        debug = false,
        ---@alias Provider "claude" | "openai" | "azure" | "gemini" | "vertex" | "cohere" | "copilot" | string
        provider = "openai", -- Recommend using Claude
        auto_suggestions_provider = "openai", -- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot
        openai = {
          endpoint = endpoint,
          model = model,
          max_tokens = 4096,
          timeout = 30000, -- Timeout in milliseconds
          temperature = 0,
        },
        cursor_applying_provider = nil,
        ---@alias Tokenizer "tiktoken" | "hf"
        -- Used for counting tokens and encoding text.
        -- By default, we will use tiktoken.
        -- For most providers that we support we will determine this automatically.
        -- If you wish to use a given implementation, then you can override it here.
        tokenizer = "tiktoken",
        rag_service = {
          enabled = false, -- Enables the rag service, requires OPENAI_API_KEY to be set
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
          enable_cursor_planning_mode = false,
        },
        history = {
          max_tokens = 4096,
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
            insert = "<C-s>",
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
          provider = "native",
          -- Options override for custom providers
          provider_opts = {},
        },
        suggestion = {
          debounce = 600,
          throttle = 600,
        },
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
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
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
