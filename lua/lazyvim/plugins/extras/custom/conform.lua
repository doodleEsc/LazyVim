-- conform
return {
  "stevearc/conform.nvim",
  optional = true,
  ---@param opts ConformOpts
  opts = function(_, opts)
    opts.default_format_opts.quiet = true
  end,
}
