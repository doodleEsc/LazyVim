return {

  {

    "saghen/blink.cmp",
    opts = {
      sources = {
        compat = { "avante_commands", "avante_mentions" },

        providers = {
          avante_commands = {
            name = "avante_commands",
            module = "blink.compat.source",
            score_offset = 11, -- show at a higher priority than lsp
            -- opts = {},
          },
          -- avante_files = {
          --   name = "avante_commands",
          --   module = "blink.compat.source",
          --   score_offset = 100, -- show at a higher priority than lsp
          --   -- opts = {},
          -- },
          avante_mentions = {
            name = "avante_mentions",
            module = "blink.compat.source",
            score_offset = 10, -- show at a higher priority than lsp
            -- opts = {},
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
    "doodleEsc/avante.nvim",
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

      return {
        ---@alias Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
        provider = "openai", -- Recommend using Claude
        auto_suggestions_provider = "openai", -- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot
        ---@alias Tokenizer "tiktoken" | "hf"
        -- Used for counting tokens and encoding text.
        -- By default, we will use tiktoken.
        -- For most providers that we support we will determine this automatically.
        -- If you wish to use a given implementation, then you can override it here.
        tokenizer = "tiktoken",
        ---@alias AvanteSystemPrompt string
        -- Default system prompt. Users can override this with their own prompt
        -- You can use `require('avante.config').override({system_prompt = "MY_SYSTEM_PROMPT"}) conditionally
        -- in your own autocmds to do it per directory, or that fit your needs.
        system_prompt = [[
You are an excellent programming expert. All responses are in Simplified Chinese.
]],
        openai = {
          endpoint = endpoint,
          model = "gpt-4o-mini",
          max_tokens = 4096,
          timeout = 30000, -- Timeout in milliseconds
          temperature = 0,
        },
        behaviour = {
          auto_suggestions = false, -- Experimental stage
          auto_set_highlight_group = true,
          auto_set_keymaps = true,
          auto_apply_diff_after_generation = false,
          support_paste_from_clipboard = true,
        },
        mappings = {
          --- @class AvanteConflictMappings
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
            accept = "<M-CR>",
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
            insert = "<M-CR>",
          },
          sidebar = {
            switch_windows = "<Tab>",
            reverse_switch_windows = "<S-Tab>",
          },
        },
        hints = { enabled = true },
        windows = {
          ---@type "right" | "left" | "top" | "bottom"
          position = "right", -- the position of the sidebar
          wrap = true, -- similar to vim.o.wrap
          width = 30, -- default % based on available width
          sidebar_header = {
            align = "center", -- left, center, right for title
            rounded = true,
          },
        },
        highlights = {
          ---@type AvanteConflictHighlights
          diff = {
            current = "DiffText",
            incoming = "DiffAdd",
          },
        },
        --- @class AvanteConflictUserConfig
        diff = {
          autojump = true,
          ---@type string | fun(): any
          list_opener = "copen",
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
      "saghen/blink.compat",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
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
        lazy = true,
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
