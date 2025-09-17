return {
  "folke/flash.nvim",
  keys = function(_, keys)
    for i = #keys, 1, -1 do
      if keys[i][1] == "<c-space>" then
        table.remove(keys, i)
      end
    end
    table.insert(keys, 1, {
      "<Tab>",
      mode = { "n", "o", "x" },
      function()
        require("flash").treesitter({
          actions = {
            ["<Tab>"] = "next",
            ["<BS>"] = "prev",
          },
        })
      end,
      desc = "Treesitter Incremental Selection",
    })
  end,
}
