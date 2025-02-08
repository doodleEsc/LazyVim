return {

  {
    "lucasrabiec/swagger-preview.nvim",
    cmd = { "SwaggerPreview", "SwaggerPreviewStop", "SwaggerPreviewToggle" },
    build = "npm i",
    config = {
      port = 18000,
    },
  },
}
