return {
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

      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--fixed-strings",
      },
    })
  end,
}
