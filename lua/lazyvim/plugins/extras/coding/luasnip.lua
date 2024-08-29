return {
  {
    "L3MON4D3/LuaSnip",
    lazy = true,
    build = (not LazyVim.is_win())
        and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
      or nil,
    dependencies = {
      "rafamadriz/friendly-snippets",
      {
        "nvim-cmp",
        dependencies = {
          "saadparwaiz1/cmp_luasnip",
        },
        opts = function(_, opts)
          opts.snippet = {
            expand = function(args)
              require("luasnip").lsp_expand(args.body)
            end,
          }
          table.insert(opts.sources, { name = "luasnip" })
        end,
      },
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
    config = function(opts)
      require("luasnip").setup(opts)
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
  {
    "nvim-cmp",
    -- stylua: ignore
    opts = function(_, opts)
      local cmp = require("cmp")
      local mapping = {
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif require("luasnip").jumpable(-1) then
              require("luasnip").jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif require("luasnip").jumpable(1) then
              require("luasnip").jump(1)
            else
              fallback()
            end
          end, { "i", "s" }),
      }

      for k, v in pairs(mapping) do
        if opts.mapping[k] == nil then
          opts.mapping[k] = v
        end
      end

    end
,
  },
  {
    "garymjr/nvim-snippets",
    enabled = false,
  },
}
