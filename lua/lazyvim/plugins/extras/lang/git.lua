return {
  recommended = {
    ft = { "gitcommit", "gitconfig", "gitrebase", "gitignore", "gitattributes" },
  },
  -- Treesitter git support
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "git_config", "gitcommit", "git_rebase", "gitignore", "gitattributes" } },
  },

  {
    "hrsh7th/nvim-cmp",
    optional = true,
    dependencies = {
      { "petertriho/cmp-git", opts = {} },
    },
    ---@module 'cmp'
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      table.insert(opts.sources, { name = "git" })
    end,
  },

  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = {
      {
        "Kaiser-Yang/blink-cmp-git",
      },
    },
    opts = {
      sources = {
        -- add 'git' to the list
        default = { "git" },
        providers = {
          git = {
            module = "blink-cmp-git",
            name = "Git",
            opts = {
              commit = {
                -- You may want to customize when it should be enabled
                -- The default will enable this when `git` is found and `cwd` is in a git repository
                -- enable = function() end
                -- You may want to change the triggers
                -- triggers = { ':' },
              },
              git_centers = {
                github = {
                  -- Those below have the same fields with `commit`
                  -- Those features will be enabled when `git` and `gh` (or `curl`) are found and
                  -- remote contains `github.com`
                  -- issue = {
                  --     get_token = function() return '' end,
                  -- },
                  -- pull_request = {
                  --     get_token = function() return '' end,
                  -- },
                  -- mention = {
                  --     get_token = function() return '' end,
                  --     get_documentation = function(item)
                  --         local default = require('blink-cmp-git.default.github')
                  --             .mention.get_documentation(item)
                  --         default.get_token = function() return '' end
                  --         return default
                  --     end
                  -- }
                },
                gitlab = {
                  -- Those below have the same fields with `commit`
                  -- Those features will be enabled when `git` and `glab` (or `curl`) are found and
                  -- remote contains `gitlab.com`
                  -- issue = {
                  --     get_token = function() return '' end,
                  -- },
                  -- NOTE:
                  -- Even for `gitlab`, you should use `pull_request` rather than`merge_request`
                  -- pull_request = {
                  --     get_token = function() return '' end,
                  -- },
                  -- mention = {
                  --     get_token = function() return '' end,
                  --     get_documentation = function(item)
                  --         local default = require('blink-cmp-git.default.gitlab')
                  --            .mention.get_documentation(item)
                  --         default.get_token = function() return '' end
                  --         return default
                  --     end
                  -- }
                },
              },
            },
          },
        },
      },
    },
  },
}
