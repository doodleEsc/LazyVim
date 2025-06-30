return {
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
}

