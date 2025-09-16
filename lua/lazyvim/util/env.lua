---@class lazyvim.util.env
local M = {}

M.loaded = false

-- load .env file
-- @param path string: .env file path
local function load_env_file(path)
  local file = io.open(path, "r")
  if not file then
    vim.notify(".env not found: " .. path, vim.log.levels.WARN)
    return
  end

  for line in file:lines() do
    line = line:match("^%s*(.-)%s*$")

    -- skip blank line and comment
    if line ~= "" and not line:match("^#") then
      local key, value = line:match("^([^=]+)=['\"]?([^'\"]+)['\"]?$")
      if key and value then
        key = key:match("^%s*(.-)%s*$")
        value = value:match("^%s*(.-)%s*$")

        vim.env[key] = value
      end
    end
  end

  file:close()
end

-- @param path string: .env file path（optional）
function M.load(path)
  if M.loaded then
    return
  end
  path = path or vim.fn.stdpath("config") .. "/.env"
  load_env_file(path)
  M.loaded = true
end

-- @param name string: env name
-- @return string: env value
function M.get(name)
  return vim.env[name]
end

return M
