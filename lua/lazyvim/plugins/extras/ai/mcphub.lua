return {

  {
    "ravitemer/mcphub.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
    },
    -- comment the following line to ensure hub will be ready at the earliest
    cmd = "MCPHub", -- lazy load by default
    build = "npm install -g mcp-hub@latest", -- Installs required mcp-hub npm module
    -- uncomment this if you don't want mcp-hub to be available globally or can't use -g
    -- build = "bundled_build.lua",  -- Use this and set use_bundled_binary = true in opts  (see Advanced configuration)
    opts = function()
      return {
        port = 37373, -- Default port for MCP Hub
        config = vim.fn.expand("~/.config/mcphub/servers.json"), -- Absolute path to config file location (will create if not exists)
        native_servers = {}, -- add your native servers here

        auto_approve = true, -- Auto approve mcp tool calls
        -- Extensions configuration
        extensions = {
          avante = {
            make_slash_commands = true, -- make /slash commands from MCP server prompts
          },
          -- codecompanion = {
          --   -- Show the mcp tool result in the chat buffer
          --   -- NOTE:if the result is markdown with headers, content after the headers wont be sent by codecompanion
          --   show_result_in_chat = false,
          --   make_vars = true, -- make chat #variables from MCP server resources
          -- },
          codecompanion = {
            -- Show the mcp tool result in the chat buffer
            show_result_in_chat = true,
            make_vars = true, -- make chat #variables from MCP server resources
            make_slash_commands = true, -- make /slash_commands from MCP server prompts
          },
        },

        -- Default window settings
        ui = {
          window = {
            width = 0.8, -- 0-1 (ratio); "50%" (percentage); 50 (raw number)
            height = 0.8, -- 0-1 (ratio); "50%" (percentage); 50 (raw number)
            relative = "editor",
            zindex = 50,
            border = "rounded", -- "none", "single", "double", "rounded", "solid", "shadow"
          },
        },

        -- Event callbacks
        on_ready = function(hub)
          -- Called when hub is ready
        end,
        on_error = function(err)
          -- Called on errors
        end,

        --set this to true when using build = "bundled_build.lua"
        use_bundled_binary = false, -- Uses bundled mcp-hub instead of global installation

        -- Logging configuration
        log = {
          level = vim.log.levels.WARN,
          to_file = false,
          file_path = nil,
          prefix = "MCPHub",
        },
      }
    end,

    config = function(_, opts)
      require("mcphub").setup(opts)
    end,
  },

  {
    "yetone/avante.nvim",
    optional = true,
    dependencies = {
      "ravitemer/mcphub.nvim",
    },
    opts = function(_, opts)
      opts.system_prompt = function()
        local hub = require("mcphub").get_hub_instance()
        return hub:get_active_servers_prompt()
      end

      opts.custom_tools = function()
        return {
          require("mcphub.extensions.avante").mcp_tool(),
        }
      end

      local buildin_tools = {
        "list_files",
        "search_files",
        "read_file",
        "create_file",
        "rename_file",
        "delete_file",
        "create_dir",
        "rename_dir",
        "delete_dir",
        "bash",
      }
      for _, value in ipairs(buildin_tools) do
        table.insert(opts.disabled_tools, value)
      end
    end,
  },

  {
    "olimorris/codecompanion.nvim",
    optional = true,
    dependencies = {
      "ravitemer/mcphub.nvim",
    },
    opts = {
      strategies = {
        chat = {
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
      },
    },
  },
}
