local SORT_METHODS = {
  "name",
  "case_sensitive",
  "modification_time",
  "extension",
}

local sort_current = 1

local cycle_sort = function()
  if sort_current >= #SORT_METHODS then
    sort_current = 1
  else
    sort_current = sort_current + 1
  end
  local api = require("nvim-tree.api")
  api.tree.reload()
end

local resize = function(delta)
  return function()
    vim.cmd("tabdo NvimTreeResize " .. delta)
  end
end

local function sort_by()
  return SORT_METHODS[sort_current]
end

local function on_attach(bufnr)
  local api = require("nvim-tree.api")

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  vim.keymap.set("n", "<C-]>", api.tree.change_root_to_node, opts("CD"))
  vim.keymap.set("n", "<C-e>", api.node.open.replace_tree_buffer, opts("Open: In Place"))
  vim.keymap.set("n", "<C-k>", api.node.show_info_popup, opts("Info"))
  vim.keymap.set("n", "<C-r>", api.fs.rename_sub, opts("Rename: Omit Filename"))
  vim.keymap.set("n", "<C-t>", api.node.open.tab, opts("Open: New Tab"))
  vim.keymap.set("n", "<C-v>", api.node.open.vertical, opts("Open: Vertical Split"))
  vim.keymap.set("n", "<C-x>", api.node.open.horizontal, opts("Open: Horizontal Split"))
  vim.keymap.set("n", "<BS>", api.node.navigate.parent_close, opts("Close Directory"))
  vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))
  vim.keymap.set("n", "<Tab>", api.node.open.preview, opts("Open Preview"))
  vim.keymap.set("n", ">", api.node.navigate.sibling.next, opts("Next Sibling"))
  vim.keymap.set("n", "<", api.node.navigate.sibling.prev, opts("Previous Sibling"))
  vim.keymap.set("n", ".", api.node.run.cmd, opts("Run Command"))
  vim.keymap.set("n", "-", api.tree.change_root_to_parent, opts("Up"))
  vim.keymap.set("n", "a", api.fs.create, opts("Create"))
  vim.keymap.set("n", "bd", api.marks.bulk.delete, opts("Delete Bookmarked"))
  vim.keymap.set("n", "bmv", api.marks.bulk.move, opts("Move Bookmarked"))
  vim.keymap.set("n", "B", api.tree.toggle_no_buffer_filter, opts("Toggle No Buffer"))
  vim.keymap.set("n", "c", api.fs.copy.node, opts("Copy"))
  vim.keymap.set("n", "C", api.tree.toggle_git_clean_filter, opts("Toggle Git Clean"))
  vim.keymap.set("n", "[c", api.node.navigate.git.prev, opts("Prev Git"))
  vim.keymap.set("n", "]c", api.node.navigate.git.next, opts("Next Git"))
  vim.keymap.set("n", "d", api.fs.remove, opts("Delete"))
  vim.keymap.set("n", "D", api.fs.trash, opts("Trash"))
  vim.keymap.set("n", "E", api.tree.expand_all, opts("Expand All"))
  vim.keymap.set("n", "e", api.fs.rename_basename, opts("Rename: Basename"))
  vim.keymap.set("n", "]e", api.node.navigate.diagnostics.next, opts("Next Diagnostic"))
  vim.keymap.set("n", "[e", api.node.navigate.diagnostics.prev, opts("Prev Diagnostic"))
  vim.keymap.set("n", "F", api.live_filter.clear, opts("Clean Filter"))
  vim.keymap.set("n", "f", api.live_filter.start, opts("Filter"))
  vim.keymap.set("n", "g?", api.tree.toggle_help, opts("Help"))
  vim.keymap.set("n", "gy", api.fs.copy.absolute_path, opts("Copy Absolute Path"))
  vim.keymap.set("n", "H", api.tree.toggle_hidden_filter, opts("Toggle Dotfiles"))
  vim.keymap.set("n", "I", api.tree.toggle_gitignore_filter, opts("Toggle Git Ignore"))
  vim.keymap.set("n", "J", api.node.navigate.sibling.last, opts("Last Sibling"))
  vim.keymap.set("n", "K", api.node.navigate.sibling.first, opts("First Sibling"))
  vim.keymap.set("n", "m", api.marks.toggle, opts("Toggle Bookmark"))
  vim.keymap.set("n", "o", api.node.open.edit, opts("Open"))
  vim.keymap.set("n", "O", api.node.open.no_window_picker, opts("Open: No Window Picker"))
  vim.keymap.set("n", "p", api.fs.paste, opts("Paste"))
  vim.keymap.set("n", "P", api.node.navigate.parent, opts("Parent Directory"))
  vim.keymap.set("n", "q", api.tree.close, opts("Close"))
  vim.keymap.set("n", "r", api.fs.rename, opts("Rename"))
  vim.keymap.set("n", "R", api.tree.reload, opts("Refresh"))
  vim.keymap.set("n", "s", api.node.run.system, opts("Run System"))
  vim.keymap.set("n", "S", api.tree.search_node, opts("Search"))
  vim.keymap.set("n", "U", api.tree.toggle_custom_filter, opts("Toggle Hidden"))
  vim.keymap.set("n", "W", api.tree.collapse_all, opts("Collapse"))
  vim.keymap.set("n", "x", api.fs.cut, opts("Cut"))
  vim.keymap.set("n", "y", api.fs.copy.filename, opts("Copy Name"))
  vim.keymap.set("n", "Y", api.fs.copy.relative_path, opts("Copy Relative Path"))
  vim.keymap.set("n", "<2-LeftMouse>", api.node.open.edit, opts("Open"))
  vim.keymap.set("n", "<2-RightMouse>", api.tree.change_root_to_node, opts("CD"))
  vim.keymap.set("n", "T", cycle_sort, opts("Cycle Sort"))
  vim.keymap.set("n", "<Tab>", resize("+5"), opts("resize +5"))
  vim.keymap.set("n", "<S-Tab>", resize("-5"), opts("resize -5"))
end

return {

  {
    "nvim-neo-tree/neo-tree.nvim",
    optional = true,
    enabled = false,
  },

  {
    "nvim-tree/nvim-tree.lua",
    event = "VeryLazy",
    init = function()
      vim.api.nvim_create_autocmd({ "SessionLoadPost" }, {
        callback = function()
          vim.defer_fn(function()
            local api = require("nvim-tree.api")

            if not api.tree.is_visible() then
              api.tree.toggle({ focus = false, find_file = true })
            end
          end, 1) -- Jank defer to give lazy time to init the plugin, just 1 works for me increase as needed
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "NvimTreeSetup",
        callback = function()
          local events = require("nvim-tree.api").events
          events.subscribe(events.Event.NodeRenamed, function(data)
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
          api.tree.toggle({ path = LazyVim.root(), find_file = true, focus = true })
        end,
        desc = "Toggle File Explorer",
      },

      {
        "<leader>tr",
        function()
          if vim.bo.filetype == "snacks_dashboard" then
            return
          end
          local api = require("nvim-tree.api")
          api.tree.toggle({ path = LazyVim.root(), find_file = true, focus = true })
        end,
        desc = "Toggle File Explorer",
      },
    },
    dependencies = {
      -- "mortepau/codicons.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    opts = function()
      return {
        -- BEGIN_DEFAULT_OPTS
        sync_root_with_cwd = false,
        respect_buf_cwd = false,
        auto_reload_on_write = true,
        disable_netrw = true,
        hijack_cursor = true,
        hijack_netrw = true,
        hijack_unnamed_buffer_when_opening = false,
        sort_by = sort_by,
        root_dirs = {},
        prefer_startup_root = false,
        reload_on_bufenter = false,
        on_attach = on_attach,
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
            -- symlink_arrow = codicons.get("arrow-small-right"),
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
              modified = true,
            },
            -- glyphs = {
            --   default = codicons.get("file"),
            --   symlink = codicons.get("file-symlink-file"),
            --   bookmark = codicons.get("bookmark"),
            --   modified = "●",
            --   folder = {
            --     arrow_closed = "",
            --     arrow_open = "",
            --     default = codicons.get("folder"),
            --     open = codicons.get("folder-opened"),
            --     empty = codicons.get("folder"),
            --     empty_open = codicons.get("folder-opened"),
            --     symlink = codicons.get("file-symlink-directory"),
            --     symlink_open = codicons.get("folder-opened"),
            --   },
            --   git = {
            --     unstaged = codicons.get("diff"),
            --     staged = codicons.get("diff-added"),
            --     unmerged = codicons.get("diff-modified"),
            --     renamed = codicons.get("diff-renamed"),
            --     untracked = codicons.get("zoom-in"),
            --     deleted = codicons.get("diff-removed"),
            --     ignored = codicons.get("diff-ignored"),
            --   },
            -- },
          },
        },
        hijack_directories = {
          enable = true,
          auto_open = true,
        },
        update_focused_file = {
          enable = true,
          update_root = {
            enable = false,
            ignore_list = {},
          },
          exclude = false,
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
          -- icons = {
          --   hint = codicons.get("question"),
          --   info = codicons.get("info"),
          --   warning = codicons.get("warning"),
          --   error = codicons.get("error"),
          -- },
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
      }
    end,
  },

  {
    "akinsho/bufferline.nvim",
    optional = true,
    init = function()
      vim.o.hidden = false
    end,
    opts = function(_, opts)
      table.insert(opts.options.offsets, {
        filetype = "NvimTree",
        text = "File Explorer",
        highlight = "Directory",
        separator = true, -- use a "true" to enable the default, or set your own character
      })
    end,
  },

  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>t", group = "File Tree" },
      },
    },
  },

  {
    "folke/snacks.nvim",
    optional = true,
    opts = function(_, opts)
      table.insert(opts.dashboard.preset.keys, 1, {
        action = ":ene | lua require('nvim-tree.api').tree.open({path = LazyVim.root()})",
        desc = "Directory Tree",
        icon = "󱏒 ",
        key = "o",
      })
    end,
  },
}
