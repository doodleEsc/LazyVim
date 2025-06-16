return {
  {
    "doodleEsc/translator.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>ts", ":Translate<CR>", mode = "v", desc = "Translate" },
    },
    opts = {
      source_language = "auto",
      target_language = "zh",
      prompt = "Translate the following text from $SOURCE_LANG to $TARGET_LANG, no explanations.:\n```$TEXT\n```",
      streaming = true,
      proxy = nil,
      translate_engine = {
        base_url = "https://openrouter.ai/api/v1",
        model = "openai/gpt-4o-mini",
      },
      detect_engine = {
        base_url = "https://openrouter.ai/api/v1",
        model = "meta-llama/llama-3.2-3b-instruct",
      },
      ui = {
        width = 0.6,
        height = 0.3,
        border = {
          style = "double",
          text = {
            top_source = " 原文 ",
            top_target = " 译文 ",
            top_align = "left",
          },
        },
      },
      keymaps = {
        enable = false,
        translate = "<leader>ts",
      },
    },
  },
}
