return {
  {
    "lucasrabiec/swagger-preview.nvim",
    cmd = { "SwaggerPreview", "SwaggerPreviewStop", "SwaggerPreviewToggle" },
    build = "npm i",
    config = {
      port = 12888,
      host = "0.0.0.0",
    },
  },
}
