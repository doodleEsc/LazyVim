return {
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    event = "VeryLazy",
    version = "*",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "SmiteshP/nvim-navic",
    },
    opts = function()
      local default_theme = {
        -- this highlight is used to override other highlights
        -- you can take advantage of its `bg` and set a background throughout your winbar
        -- (e.g. basename will look like this: { fg = "#c0caf5", bold = true })
        normal = { fg = "#ac8fe4" },

        -- these highlights correspond to symbols table from config
        ellipsis = { fg = "#737aa2" },
        separator = { fg = "#737aa2" },
        modified = { fg = "#737aa2" },

        -- these highlights represent the _text_ of three main parts of barbecue
        dirname = { fg = "#737aa2" },
        basename = { bold = true },
        context = {},

        -- these highlights are used for context/navic icons
        context_file = { fg = "#ac8fe4" },
        context_module = { fg = "#ac8fe4" },
        context_namespace = { fg = "#ac8fe4" },
        context_package = { fg = "#ac8fe4" },
        context_class = { fg = "#ac8fe4" },
        context_method = { fg = "#ac8fe4" },
        context_property = { fg = "#ac8fe4" },
        context_field = { fg = "#ac8fe4" },
        context_constructor = { fg = "#ac8fe4" },
        context_enum = { fg = "#ac8fe4" },
        context_interface = { fg = "#ac8fe4" },
        context_function = { fg = "#ac8fe4" },
        context_variable = { fg = "#ac8fe4" },
        context_constant = { fg = "#ac8fe4" },
        context_string = { fg = "#ac8fe4" },
        context_number = { fg = "#ac8fe4" },
        context_boolean = { fg = "#ac8fe4" },
        context_array = { fg = "#ac8fe4" },
        context_object = { fg = "#ac8fe4" },
        context_key = { fg = "#ac8fe4" },
        context_null = { fg = "#ac8fe4" },
        context_enum_member = { fg = "#ac8fe4" },
        context_struct = { fg = "#ac8fe4" },
        context_event = { fg = "#ac8fe4" },
        context_operator = { fg = "#ac8fe4" },
        context_type_parameter = { fg = "#ac8fe4" },
      }

      local function hl_convert(data)
        local function capitalize_first_letter(str)
          return str:sub(1, 1):upper() .. str:sub(2)
        end

        for key, value in pairs(data) do
          if key:match("^context_") then
            local parts = {}
            for part in key:gmatch("[^_]+") do
              table.insert(parts, part)
            end

            if #parts == 2 and parts[1] == "context" then
              local context_type = capitalize_first_letter(parts[2])
              local highlight = "NavicIcons" .. context_type
              data[key] = { link = highlight }
            end
          end
        end

        return data
      end

      local navic_theme = hl_convert(default_theme)
      navic_theme["context_type_parameter"] = { link = "NavicIconsTypeParameter" }
      navic_theme["normal"] = { link = "NavicText" }
      navic_theme["ellipsis"] = { link = "NavicEllipsis" }
      navic_theme["separator"] = { link = "NavicSeparator" }
      navic_theme["modified"] = { link = "NavicModified" }
      navic_theme["dirname"] = { link = "NavicDirname" }
      navic_theme["basename"] = { link = "NavicBaseName" }

      return {
        theme = navic_theme,
      }
    end,
  },

  {
    "ellisonleao/gruvbox.nvim",
    opts = {
      overrides = {
        NavicText = { link = "GruvboxOrange" },
        NavicEllipsis = { link = "GruvboxWhite" },
        NavicModified = { link = "GruvboxYellow" },
        NavicDirname = { link = "GruvboxBlue" },
        NavicBaseName = { link = "GruvboxBlue" },
      },
    },
  },
}
