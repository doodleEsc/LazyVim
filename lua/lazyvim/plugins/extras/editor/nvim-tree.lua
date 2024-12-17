return {

  {
    "nvim-neo-tree/neo-tree.nvim",
    optional = true,
    enabled = false,
  },

  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeOpen", "NvimTreeToggle", "NvimTreeClose" },
    event = { "SessionLoadPost" },
    init = function()
      vim.api.nvim_create_autocmd({ "SessionLoadPost" }, {
        callback = function()
          vim.defer_fn(function()
            local api = require("nvim-tree.api")
            local view = require("nvim-tree.view")

            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
              local name = vim.api.nvim_buf_get_name(buf)
              if name:match("NvimTree*") then
                if not view.is_visible() then
                  api.tree.toggle({ focus = false, find_file = true })
                end
                break
              end
            end
          end, 1) -- Jank defer to give lazy time to init the plugin, just 1 works for me increase as needed
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "NvimTreeSetup",
        callback = function()
          local events = require("nvim-tree.api").events
          events.subscribe(events.Event.NodeRenamed, function(data)
            print(vim.inspect(data))
            Snacks.rename.on_rename_file(data.old_name, data.new_name)
          end)
        end,
      })
    end,
    keys = {
      {
        "<leader>tt",
        function()
          local api = require("nvim-tree.api")
          api.tree.toggle()
        end,
        desc = "Toggle File Explorer",
      },

      {
        "<leader>tr",
        function()
          if vim.bo.filetype == "alpha" then
            return
          end
          local api = require("nvim-tree.api")
          if api.tree.is_visible() then
            api.tree.find_file(vim.fn.expand("%:p"))
          else
            api.tree.toggle(true, false)
          end
          api.tree.focus()
        end,
        desc = "Toggle File Explorer",
      },
    },
    dependencies = {
      "mortepau/codicons.nvim",
      "romgrk/barbar.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function(_, opts)
      local codicons = require("codicons")
      require("nvim-tree").setup({
        -- BEGIN_DEFAULT_OPTS
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        auto_reload_on_write = true,
        disable_netrw = true,
        hijack_cursor = true,
        hijack_netrw = true,
        hijack_unnamed_buffer_when_opening = false,
        sort_by = LazyVim.tree.sort_by,
        root_dirs = {},
        prefer_startup_root = false,
        reload_on_bufenter = false,
        on_attach = LazyVim.tree.on_attach,
        select_prompts = false,
        view = {
          cursorline = true,
          debounce_delay = 15,
          adaptive_size = false,
          centralize_selection = true,
          width = 30,
          side = "left",
          preserve_window_proportions = false,
          number = false,
          relativenumber = false,
          signcolumn = "yes",
          float = {
            enable = false,
            quit_on_focus_loss = true,
            open_win_config = {
              relative = "editor",
              border = "rounded",
              width = 30,
              height = 30,
              row = 1,
              col = 1,
            },
          },
        },
        renderer = {
          full_name = false,
          highlight_modified = "none",
          root_folder_label = ":~:s?$?/..?",
          indent_width = 2,
          add_trailing = false,
          group_empty = false,
          highlight_git = true,
          highlight_opened_files = "all",
          root_folder_modifier = ":~",
          highlight_diagnostics = false,
          highlight_bookmarks = "none",
          highlight_clipboard = "name",
          special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
          symlink_destination = true,
          indent_markers = {
            enable = true,
            inline_arrows = true,
            icons = {
              corner = "└",
              edge = "│",
              item = "│",
              bottom = "─",
              none = " ",
            },
          },
          icons = {
            webdev_colors = true,
            git_placement = "signcolumn",
            modified_placement = "after",
            padding = " ",
            symlink_arrow = codicons.get("arrow-small-right"),
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
              modified = true,
            },
            glyphs = {
              default = codicons.get("file"),
              symlink = codicons.get("file-symlink-file"),
              bookmark = codicons.get("bookmark"),
              modified = "●",
              folder = {
                arrow_closed = "",
                arrow_open = "",
                default = codicons.get("folder"),
                open = codicons.get("folder-opened"),
                empty = codicons.get("folder"),
                empty_open = codicons.get("folder-opened"),
                symlink = codicons.get("file-symlink-directory"),
                symlink_open = codicons.get("folder-opened"),
              },
              git = {
                unstaged = codicons.get("diff"),
                staged = codicons.get("diff-added"),
                unmerged = codicons.get("diff-modified"),
                renamed = codicons.get("diff-renamed"),
                untracked = codicons.get("zoom-in"),
                deleted = codicons.get("diff-removed"),
                ignored = codicons.get("diff-ignored"),
              },
            },
          },
        },
        hijack_directories = {
          enable = true,
          auto_open = true,
        },
        update_focused_file = {
          enable = true,
          update_cwd = true,
          ignore_list = {},
        },
        system_open = {
          cmd = "",
          args = {},
        },
        diagnostics = {
          enable = true,
          show_on_dirs = true,
          show_on_open_dirs = true,
          debounce_delay = 50,
          severity = {
            -- min = vim.diagnostic.severity.HINT,
            max = vim.diagnostic.severity.ERROR,
          },
          icons = {
            hint = codicons.get("question"),
            info = codicons.get("info"),
            warning = codicons.get("warning"),
            error = codicons.get("error"),
          },
        },
        filters = {
          dotfiles = false,
          git_clean = false,
          no_buffer = false,
          custom = {},
          exclude = {},
        },
        filesystem_watchers = {
          enable = true,
          debounce_delay = 100,
          ignore_dirs = {},
        },
        git = {
          enable = true,
          ignore = false,
          timeout = 200,
          show_on_dirs = true,
          show_on_open_dirs = true,
        },
        modified = {
          enable = true,
          show_on_dirs = true,
          show_on_open_dirs = true,
        },
        actions = {
          use_system_clipboard = true,
          change_dir = {
            enable = true,
            global = false,
            restrict_above_cwd = false,
          },
          expand_all = {
            max_folder_discovery = 300,
            exclude = {},
          },
          file_popup = {
            open_win_config = {
              col = 1,
              row = 1,
              relative = "cursor",
              border = "shadow",
              style = "minimal",
            },
          },
          open_file = {
            quit_on_open = false,
            resize_window = true,
            window_picker = {
              enable = true,
              picker = "default",
              chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
              exclude = {
                filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
                buftype = { "nofile", "terminal", "help" },
              },
            },
          },
          remove_file = {
            close_window = true,
          },
        },
        trash = {
          cmd = "git trash",
        },
        live_filter = {
          prefix = "[FILTER]: ",
          always_show_folders = true,
        },
        tab = {
          sync = {
            open = false,
            close = false,
            ignore = {},
          },
        },
        notify = {
          threshold = vim.log.levels.INFO,
        },
        ui = {
          confirm = {
            remove = true,
            trash = true,
          },
        },
        log = {
          enable = false,
          truncate = false,
          types = {
            all = false,
            config = false,
            copy_paste = false,
            dev = false,
            diagnostics = false,
            git = false,
            profile = false,
            watcher = false,
          },
        },
      })
    end,
  },
}
