return {
  {
    "doodleEsc/nvim-updater.nvim",
    version = "*", -- Pin to GitHub releases
    config = function()
      require("nvim_updater").setup({
        source_dir = "~/Projects/doodleEsc/neovim", -- Custom target directory
        build_type = "Release", -- Default build type
        tag = "stable", -- Default Neovim branch to track
        notify_updates = false, -- Enable update notification
        verbose = false, -- Default verbose mode
        default_keymaps = false, -- Use default keymaps
        build_fresh = true, -- Always remove build dir before building
        env = {
          NINJA_J = 1,
          CC = "clang",
          CXX = "clang++",
        },
      })
    end,
    keys = { -- Custom keymappings
      { -- Custom Update Neovim
        "<Leader>cuU",
        function()
          require("nvim_updater").update_neovim()
        end,
        desc = "Custom Update Neovim",
      },
      { -- Debug Build Neovim
        "<Leader>cuD",
        function()
          require("nvim_updater").update_neovim({ build_type = "Debug" })
        end,
        desc = "Debug Build Neovim",
      },
      { -- Remove Neovim Source
        "<Leader>cRN",
        ":NVUpdateRemoveSource<CR>",
        desc = "Remove Neovim Source Directory",
      },
    },
  },
}
