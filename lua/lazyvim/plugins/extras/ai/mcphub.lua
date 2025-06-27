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
        server_url = nil, -- In cases where mcp-hub is hosted somewhere, set this to the server URL e.g `http://mydomain.com:customport` or `https://url_without_need_for_port.com`
        config = vim.fn.expand("~/.config/mcphub/servers.json"), -- Default config location
        shutdown_delay = 10 * 60 * 1000, -- 10 minutes -- Delay before shutting down the mcp-hub
        mcp_request_timeout = 60000, --Timeout for MCP requests in milliseconds, useful for long running tasks
        ---@type table<string, NativeServerDef>
        native_servers = {},
        builtin_tools = {},
        ---@type boolean | fun(parsed_params: MCPHub.ParsedParams): boolean | nil | string  Function to determine if a call should be auto-approved
        auto_approve = false,
        auto_toggle_mcp_servers = true, -- Let LLMs start and stop MCP servers automatically
        use_bundled_binary = false, -- Whether to use bundled mcp-hub binary
        ---@type string?
        cmd = nil, -- will be set based on system if not provided
        ---@type table?
        cmdArgs = nil, -- will be set based on system if not provided
        ---@type LogConfig
        log = {
          level = vim.log.levels.ERROR,
          to_file = false,
          file_path = nil,
          prefix = "MCPHub",
        },
        ---@type MCPHub.UIConfig
        ui = {
          window = {},
          wo = {},
        },
        ---@type MCPHub.Extensions.Config
        extensions = {
          avante = {
            enabled = true,
            make_slash_commands = true,
          },
        },
        on_ready = function() end,
        ---@param msg string
        on_error = function(msg) end,
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
      local system_prompt = opts.system_prompt

      opts.system_prompt = function()
        local hub = require("mcphub").get_hub_instance()
        return system_prompt .. "\n====\n" .. hub:get_active_servers_prompt()
      end

      opts.custom_tools = function()
        return {
          require("mcphub.extensions.avante").mcp_tool(),
        }
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
