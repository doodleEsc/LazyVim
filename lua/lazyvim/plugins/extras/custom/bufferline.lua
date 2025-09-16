return {
  "akinsho/bufferline.nvim",
  optional = true,
  keys = function(_, keys)
    table.insert(keys, {
      "<S-n>",
      function()
        Snacks.bufdelete()
      end,
      desc = "Close Current Buffer",
    })

    table.insert(keys, {
      "<M-h>",
      "<cmd>BufferLineMovePrev<cr>",
      desc = "Move to Prev",
    })

    table.insert(keys, {
      "<M-l>",
      "<cmd>BufferLineMoveNext<cr>",
      desc = "Move to Next",
    })

    table.insert(keys, {
      "<M-p>",
      "<cmd>BufferLineTogglePin<cr>",
      desc = "Pin buffer",
    })
  end,
  opts = function(_, opts)
    local filtered_filetypes = {
      "Avante",
      "AvanteInput",
      "AvanteSelectedFiles",
      "codecompanion",
      "neo-tree",
      "help",
      "qf",
      "notify",
      "snacks_dashboard",
    }

    local filtered_buf_names = {
      "kulala://ui",
    }

    opts.options.custom_filter = function(buf_number, buf_numbers)
      local ft = vim.bo[buf_number].filetype
      for _, filtered_ft in ipairs(filtered_filetypes) do
        if ft == filtered_ft then
          return false
        end
      end

      local buf_name = vim.fn.bufname(buf_number)
      for _, filtered_buf_name in ipairs(filtered_buf_names) do
        if buf_name == filtered_buf_name then
          return false
        end
      end

      return true
    end
    opts.options.always_show_bufferline = false
    opts.options.diagnostics = false
    opts.options.hover = {
      enabled = true,
      delay = 200,
      reveal = { "close" },
    }

    opts.options.separator_style = "slant"
    opts.options.color_icons = false
    opts.options.show_buffer_icons = false
    opts.options.tab_size = 14
  end,
}
