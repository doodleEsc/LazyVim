--- Add the startup section
---@return snacks.dashboard.Section
local function dashboardStartup()
  local stats = Snacks.dashboard.lazy_stats
  stats = stats and stats.startuptime > 0 and stats or require("lazy.stats").stats()
  local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)

  local delimiter = "  -  "
  local datetime = os.date(" %Y-%m-%d")
  local version = vim.version()
  local nvim_version_info = " v" .. version.major .. "." .. version.minor .. "." .. version.patch
  local plugin_info = "󰚥 " .. stats.loaded .. "/" .. stats.count .. " plugins"
  local load_cost = "󱎫 " .. ms .. "ms"

  return {
    align = "center",
    padding = { 0, 1 },
    text = {
      { datetime },
      { delimiter },
      { nvim_version_info },
      { delimiter },
      { plugin_info },
      { delimiter },
      { load_cost, hl = "special" },
    },
  }
end

return {

  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<Tab>", desc = "Increment Selection", mode = { "x", "n" } },
        { "<C-Space>", desc = "Toggle Terminal (Root Dir)", mode = { "t", "n" } },
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    keys = function()
      return {
        { "<Tab>", desc = "Increment Selection" },
        { "<bs>", desc = "Decrement Selection", mode = "x" },
      }
    end,
    opts = {
      incremental_selection = {
        keymaps = {
          init_selection = "<Tab>",
          node_incremental = "<Tab>",
        },
      },
    },
  },

  {
    "snacks.nvim",
    optional = true,
    keys = {
      {
        "<C-Space>",
        function()
          Snacks.terminal(nil, { cwd = LazyVim.root() })
        end,
        mode = "n",
        desc = "Terminal (Root Dir)",
      },
      {
        "<C-Space>",
        "<cmd>close<cr>",
        mode = "t",
        silent = true,
        noremap = true,
        desc = "Hide Terminal",
      },
    },

    opts = function(_, opts)
      local snacksConfig = {

        input = {
          enabled = true,
        },

        -- Animation
        ---@type snacks.animate.Config
        animate = {
          easing = "inQuad",
        },

        -- Dashboard
        ---@type snacks.dashboard.Config
        dashboard = {
          preset = {
            header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
      ]],
          },
          sections = {
            { section = "header", padding = 1 },
            -- { title = "Shortcuts", padding = 0, align = "center" },
            { section = "keys", padding = { 1, 0 }, gap = 1 },
            -- { title = "Recent Files", padding = 1, align = "center" },
            -- { section = "recent_files", padding = 1 },
            -- { title = "Recent Projects", padding = 1, align = "center" },
            { section = "projects", padding = 1, limit = 5, session = true },
            dashboardStartup,
          },
        },
      }
      LazyVim.merge(opts, snacksConfig)
    end,
  },

  {
    "akinsho/bufferline.nvim",
    optional = true,
    keys = function(_, keys)
      table.insert(keys, {
        "<S-n>",
        function()
          Snacks.bufdelete()
        end,
        desc = "Close Current Buffer",
      })

      table.insert(keys, {
        "<M-h>",
        "<cmd>BufferLineMovePrev<cr>",
        desc = "Move to Prev",
      })

      table.insert(keys, {
        "<M-l>",
        "<cmd>BufferLineMoveNext<cr>",
        desc = "Move to Next",
      })

      table.insert(keys, {
        "<M-p>",
        "<cmd>BufferLineTogglePin<cr>",
        desc = "Pin buffer",
      })
    end,
    opts = function(_, opts)
      local filtered_filetypes = {
        "Avante",
        "AvanteInput",
        "AvanteSelectedFiles",
        "codecompanion",
        "neo-tree",
        "help",
        "qf",
        "notify",
        "snacks_dashboard",
      }

      local filtered_buf_names = {
        "kulala://ui",
      }

      opts.options.custom_filter = function(buf_number, buf_numbers)
        local ft = vim.bo[buf_number].filetype
        for _, filtered_ft in ipairs(filtered_filetypes) do
          if ft == filtered_ft then
            return false
          end
        end

        local buf_name = vim.fn.bufname(buf_number)
        for _, filtered_buf_name in ipairs(filtered_buf_names) do
          if buf_name == filtered_buf_name then
            return false
          end
        end

        return true
      end
      opts.options.always_show_bufferline = false
      opts.options.diagnostics = false
      opts.options.hover = {
        enabled = true,
        delay = 200,
        reveal = { "close" },
      }

      opts.options.separator_style = "slant"
      opts.options.color_icons = false
      opts.options.show_buffer_icons = false
      opts.options.tab_size = 14

      opts.highlights = {
        buffer_selected = {
          fg = "#000000",
          bg = "#fabd2f",
        },
        close_button_selected = {
          fg = "#000000",
          bg = "#fabd2f",
        },
        separator_selected = {
          bg = "#fabd2f",
        },
        duplicate_selected = {
          fg = "#000000",
          bg = "#fabd2f",
        },
        modified_selected = {
          fg = "#000000",
          bg = "#fabd2f",
        },
      }
    end,
  },

  {
    "saghen/blink.cmp",
    -- optional = true,
    opts = {
      completion = {
        menu = {
          border = "rounded",
          winhighlight = "Normal:BlinkCmpMenu,FloatBorder:None,CursorLine:BlinkCmpMenuSelection,Search:None",
        },
        documentation = {
          window = {
            border = "rounded",
            winhighlight = "Normal:BlinkCmpDoc,FloatBorder:None,EndOfBuffer:BlinkCmpDoc",
          },
        },
        trigger = {
          show_in_snippet = false,
        },
        list = {
          selection = {
            preselect = false,
            auto_insert = true,
          },
        },
      },
      keymap = {
        -- set to 'none' to disable the 'default' preset
        preset = "none",

        ["<C-e>"] = { "hide", "fallback" },

        ["<Tab>"] = {
          function(cmp)
            if cmp.snippet_active() then
              return cmp.accept()
            else
              return cmp.select_and_accept()
            end
          end,
          "snippet_forward",
          "fallback",
        },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },

        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },

        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },

        ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },

        ["<CR>"] = { "select_and_accept", "fallback" },

        -- term = {},
      },
    },
  },

  -- Markdown preview
  {
    "iamcco/markdown-preview.nvim",
    optional = true,
    init = function()
      vim.g.mkdp_preview_options = {
        mkit = {
          breaks = true,
        },
        katex = {},
        uml = {},
        maid = {},
        disable_sync_scroll = 0,
        sync_scroll_type = "top",
        hide_yaml_meta = 1,
        sequence_diagrams = {
          theme = "hand",
        },
      }
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    optional = true,
    opts = function(_, opts)
      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        sorting_strategy = "ascending",
        scroll_strategy = "cycle",
        layout_strategy = "flex",
        layout_config = {
          horizontal = {
            width = 0.9,
            height = 0.9,
            preview_cutoff = 120,
            preview_width = 0.45,
            prompt_position = "top",
          },
          vertical = {
            height = 0.9,
            width = 0.9,
            preview_cutoff = 40,
            prompt_position = "top",
          },
        },
      })
    end,
  },

  {
    "hedyhli/outline.nvim",
    optional = true,
    opts = function(_, opts)
      opts = {
        symbol_folding = {
          -- Depth past which nodes will be folded by default. Set to false to unfold all on open.
          autofold_depth = 2,
          -- When to auto unfold nodes
          auto_unfold = {
            -- Auto unfold currently hovered symbol
            hovered = true,
            -- Auto fold when the root level only has this many nodes.
            -- Set true for 1 node, false for 0.
            only = true,
          },
          markers = { "", "" },
        },
        preview_window = {
          auto_preview = false,
        },
      }
      return opts
    end,
  },

  {
    "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = {
        nls.builtins.formatting.shfmt,
        nls.builtins.code_actions.gitsigns,
        nls.builtins.formatting.stylua,
        nls.builtins.formatting.prettier,
      }
    end,
  },

  {
    "snacks.nvim",
    optional = true,
    opts = {
      terminal = {
        win = {
          height = 0.5,
        },
      },
    },
  },
}
