return {
  {
    "voldikss/vim-floaterm",
    cmd = {
      "FloatermNew",
      "FloatermToggle",
    },
    init = function()
      vim.g.floaterm_width = 0.9
      vim.g.floaterm_height = 0.9
      vim.g.floaterm_borderchars = "─│─│╭╮╯╰"
      vim.g.floaterm_opener = "edit"
    end,
    keys = {
      { "<C-space>", "<Cmd>FloatermToggle<CR>", mode = "n", desc = "Toggle Floaterm" },
      {
        "<M-n>",
        "<Cmd>FloatermNew<CR>",
        mode = "n",
        desc = "Open Floaterm In Project Root Dir",
      },
      {
        "<M-m>",
        "<Cmd>FloatermNew --cwd=<buffer><CR>",
        mode = "n",
        desc = "Open Floaterm In Current Buffer Dir",
      },
      {
        "<M-n>",
        ":<C-u>'<,'>FloatermNew<CR>",
        mode = "x",
        desc = "Open Floaterm In Project Root Dir",
      },
      {
        "<M-m>",
        ":<C-u>'<,'>FloatermNew --cwd=<buffer><CR>",
        mode = "x",
        desc = "Open Floaterm In Current Buffer Dir",
      },
      {
        "<C-space>",
        "<C-\\><C-n>:FloatermToggle<CR>",
        mode = "t",
        desc = "Toggle Terminal",
        silent = true,
        noremap = true,
      },

      {
        "<C-h>",
        "<C-\\><C-n>:FloatermPrev<CR>",
        mode = "t",
        silent = true,
        desc = "Go To Next Terminal",
      },
      {
        "<C-l>",
        "<C-\\><C-n>:FloatermNext<CR>",
        mode = "t",
        silent = true,
        desc = "Go To Previous Terminal",
      },
      {
        "<M-j>",
        "<C-\\><C-n>:FloatermKill<CR>",
        mode = "t",
        desc = "Kill Current Terminal",
      },
      {
        "<M-k>",
        "<C-\\><C-n>:FloatermKill!<CR>",
        mode = "t",
        desc = "Kill All Terminal",
      },
      {
        "<M-n>",
        function()
          vim.cmd("FloatermHide")
          local dir = vim.fn.getcwd()
          vim.cmd("FloatermNew --cwd=" .. dir)
        end,
        mode = "t",
        desc = "Floaterm In Project Root Dir",
        silent = true,
      },
      {
        "<M-m>",
        function()
          vim.schedule(function()
            vim.cmd("FloatermHide")
            local dir = vim.fn.expand("%:p:h")
            vim.cmd("FloatermNew --cwd=" .. dir)
          end)
        end,
        mode = "t",
        desc = "Floaterm In Current Buffer Dir",
        silent = true,
      },
    },
  },

  {
    "ellisonleao/gruvbox.nvim",
    opts = {
      overrides = {
        FloatermBorder = { link = "GruvboxOrange" },
      },
    },
  },
}
