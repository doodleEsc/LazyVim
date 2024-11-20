---@param config {type?:string, args?:string[]|fun():string[]?}
local function get_args(config)
  local args = type(config.args) == "function" and (config.args() or {}) or config.args or {} --[[@as string[] | string ]]
  local args_str = type(args) == "table" and table.concat(args, " ") or args --[[@as string]]

  config = vim.deepcopy(config)
  ---@cast args string[]
  config.args = function()
    local new_args = vim.fn.expand(vim.fn.input("Run with args: ", args_str)) --[[@as string]]
    if config.type and config.type == "java" then
      ---@diagnostic disable-next-line: return-type-mismatch
      return new_args
    end
    return require("dap.utils").splitstr(new_args)
  end
  return config
end

local dap_hydra_factory = function()
  local hint = [[
 _<F5>_       : Continue
 _<S-F5>_     : Run with Args
 _<F6>_       : Pause
 _<F9>_       : Toggle Breakpoint
 _<S-F9>_     : Breakpoint Condition
 _<F10>_      : Step Over
 _<F11>_      : Step Into
 _<S-F11>_    : Step Out
 _<F4>_       : Terminate
 ^
 _<leader>dc_ : Run to Cursor
 _<leader>dg_ : Go to Line (No Execute)
 _<leader>dj_ : Down
 _<leader>dk_ : Up
 _<leader>dl_ : Run Last
 _<leader>dr_ : Toggle REPL
 _<leader>ds_ : Session
 _<leader>dw_ : Widgets
 ^
 _<Esc>_      : Terminate And Exit
]]

  local Hydra = require("hydra")
  local cmd = require("hydra.keymap-util").cmd
  local dap_hydra = Hydra({
    name = "Dap",
    hint = hint,
    config = {
      invoke_on_body = false,
      color = "pink",
      hint = {
        position = "top-right",
        float_opts = {
          -- row, col, height, width, relative, and anchor should not be
          -- overridden
          style = "minimal",
          focusable = false,
          noautocmd = true,
        },
      },
      on_enter = function()
        require("persistent-breakpoints.api").load_breakpoints()
      end,
      on_exit = function()
        local dap = require("dap")
        if dap.session() ~= nil then
          require("dap").terminate()
        end
      end,
    },
    mode = "n",
    heads = {

      {
        "<F9>",
        function()
          require("persistent-breakpoints.api").toggle_breakpoint()
        end,
        desc = "Toggle Breakpoint",
      },
      {
        "<S-F9>",
        function()
          require("persistent-breakpoints.api").set_conditional_breakpoint()
        end,
        desc = "Breakpoint Condition",
      },

      {
        "<F5>",
        function()
          require("dap").continue()
        end,
        desc = "Continue",
      },
      {
        "<S-F5>",
        function()
          require("dap").continue({ before = get_args })
        end,
        desc = "Run with Args",
      },

      {
        "<F10>",
        function()
          require("dap").step_over()
        end,
        desc = "Step Over",
      },
      {
        "<F11>",
        function()
          require("dap").step_into()
        end,
        desc = "Step Into",
      },
      {
        "<S-F11>",
        function()
          require("dap").step_out()
        end,
        desc = "Step Out",
      },

      {
        "<F4>",
        function()
          require("dap").terminate()
        end,
        desc = "Terminate",
      },
      {
        "<F6>",
        function()
          require("dap").pause()
        end,
        desc = "Pause",
      },

      {
        "<leader>dc",
        function()
          require("dap").run_to_cursor()
        end,
        desc = "Run to Cursor",
      },
      {
        "<leader>dg",
        function()
          require("dap").goto_()
        end,
        desc = "Go to Line (No Execute)",
      },
      {
        "<leader>dj",
        function()
          require("dap").down()
        end,
        desc = "Down",
      },
      {
        "<leader>dk",
        function()
          require("dap").up()
        end,
        desc = "Up",
      },
      {
        "<leader>dl",
        function()
          require("dap").run_last()
        end,
        desc = "Run Last",
      },
      {
        "<leader>dr",
        function()
          require("dap").repl.toggle()
        end,
        desc = "Toggle REPL",
      },
      {
        "<leader>ds",
        function()
          require("dap").session()
        end,
        desc = "Session",
      },
      {
        "<leader>dw",
        function()
          require("dap.ui.widgets").hover()
        end,
        desc = "Widgets",
      },
    },
  })
  return dap_hydra
end

return {
  {
    "mfussenegger/nvim-dap",
    recommended = true,
    desc = "Debugging support. Requires language specific adapters to be configured. (see lang extras)",

    dependencies = {
      "rcarriga/nvim-dap-ui",
      -- virtual text for the debugger
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
      {
        "Weissle/persistent-breakpoints.nvim",
        opts = {
          load_breakpoints_event = nil,
        },
      },
    },

    -- stylua: ignore
    keys = {
      { "<leader>dd", function() LazyVim.hydra.run("dap") end, desc = "Load Breakpoints" },
      { "<F9>", function() require("persistent-breakpoints.api").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<S-F9>", function() require("persistent-breakpoints.api").set_conditional_breakpoint() end, desc = "Breakpoint Condition" },
      { "<F5>", function() require("dap").continue() end, desc = "Continue" },
      { "<S-F5>", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
      { "<F10>", function() require("dap").step_over() end, desc = "Step Over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Step Into" },
      { "<S-F11>", function() require("dap").step_out() end, desc = "Step Out" },
      { "<F4>", function() require("dap").terminate() end, desc = "Terminate" },
      { "<F6>", function() require("dap").pause() end, desc = "Pause" },
      { "<leader>dc", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
      { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
      { "<leader>dj", function() require("dap").down() end, desc = "Down" },
      { "<leader>dk", function() require("dap").up() end, desc = "Up" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
      { "<leader>ds", function() require("dap").session() end, desc = "Session" },
      { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
    },

    config = function()
      -- load mason-nvim-dap here, after all adapters have been setup
      if LazyVim.has("mason-nvim-dap.nvim") then
        require("mason-nvim-dap").setup(LazyVim.opts("mason-nvim-dap.nvim"))
      end

      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      for name, sign in pairs(LazyVim.config.icons.dap) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
          "Dap" .. name,
          { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
        )
      end

      -- setup dap config by VsCode launch.json file
      local vscode = require("dap.ext.vscode")
      local json = require("plenary.json")
      vscode.json_decode = function(str)
        return vim.json.decode(json.json_strip_comments(str))
      end

      -- add dap hydra
      LazyVim.hydra.add("dap", dap_hydra_factory)
    end,
  },

  -- fancy UI for the debugger
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "nvim-neotest/nvim-nio" },
    -- stylua: ignore
    keys = {
      { "<leader>du", function() require("dapui").toggle({ }) end, desc = "Dap UI" },
      { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "v"} },
    },
    opts = {},
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup(opts)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({})
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close({})
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({})
      end
    end,
  },

  -- mason.nvim integration
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = "mason.nvim",
    cmd = { "DapInstall", "DapUninstall" },
    opts = {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
      },
    },
    -- mason-nvim-dap is loaded when nvim-dap loads
    config = function() end,
  },

  {

    "folke/which-key.nvim",
    optional = true,
    opts = function(_, opts)
      local group = { "<leader>d", group = "+debug" }
      table.insert(opts["spec"][1], group)
    end,
  },
}
