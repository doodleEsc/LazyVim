return {

  {
    "lucasrabiec/swagger-preview.nvim",
    cmd = { "SwaggerPreview", "SwaggerPreviewStop", "SwaggerPreviewToggle" },
    build = "npm i",
    opts = {
      port = 18000,
    },
  },
}
