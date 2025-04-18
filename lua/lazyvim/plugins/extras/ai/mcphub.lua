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
          avante = {},
          codecompanion = {
            -- Show the mcp tool result in the chat buffer
            -- NOTE:if the result is markdown with headers, content after the headers wont be sent by codecompanion
            show_result_in_chat = false,
            make_vars = true, -- make chat #variables from MCP server resources
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

        --WARN: Use the custom setup if you can't use `npm install -g mcp-hub` or cant have `build = "bundled_build.lua"`
        -- Custom Server command configuration
        --cmd = "node", -- The command to invoke the MCP Hub Server
        --cmdArgs = {"/path/to/node_modules/mcp-hub/dist/cli.js"},    -- Additional arguments for the command

        -- Common command configurations (when not using bundled binary):
        -- 1. Global installation (default):
        --   cmd = "mcp-hub"
        --   cmdArgs = {}
        -- 2. Local npm package:
        --   cmd = "node"
        --   cmdArgs = {"/path/to/node_modules/mcp-hub/dist/cli.js"}
        -- 3. Custom binary:
        --   cmd = "/usr/local/bin/custom-mcp-hub"
        --   cmdArgs = {"--custom-flag"}

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
    -- optional = true,
    dependencies = {
      "ravitemer/mcphub.nvim",
    },

    -- opts = function(_, opts)
    --   opts.system_prompt = function()
    --     local hub = require("mcphub").get_hub_instance()
    --     return hub:get_active_servers_prompt()
    --   end
    --
    --   table.insert(opts.custom_tools, {
    --     require("mcphub.extensions.avante").mcp_tool(),
    --   })
    --
    --   return opts
    -- end,
    opts = {
      system_prompt = function()
        local hub = require("mcphub").get_hub_instance()
        return hub:get_active_servers_prompt()
      end,
      -- The custom_tools type supports both a list and a function that returns a list. Using a function here prevents requiring mcphub before it's loaded
      custom_tools = function()
        return {
          require("mcphub.extensions.avante").mcp_tool(),
        }
      end,
    },
  },
}
