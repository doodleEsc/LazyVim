---@class lazyvim.util.hydra
---@overload fun(name: string)
local M = setmetatable({}, {
  __call = function(m, ...)
    return m.run(...)
  end,
})

---@type table<string, function>
local factories = {}

--- add hydra
---@param key string
---@param value function
M.add = function(key, value)
  factories[key] = value
end

--- remove hydra factory
---@param key string
M.remove = function(key)
  factories[key] = nil
end

--- check if factory exist
---@param key string
M.contain = function(key)
  return factories[key] ~= nil
end

--- run hydra
---@param key string
M.run = function(key)
  if not LazyVim.has_extra("util.hydra") then
    vim.notify("'lazyvim.plugin.extras.util.hydra' Not Found", vim.log.levels.ERROR)
    return
  end

  -- if not LazyVim.is_loaded("hydra") then
  --   vim.notify("'hydra' Not Loaded", vim.log.levels.ERROR)
  -- end

  if not M.contain(key) then
    vim.notify("No Such Hydra Factory: " .. key, vim.log.levels.ERROR)
    return
  end

  local hydra, ok = nil, false
  local hydra_factory = factories[key]
  -- ok, hydra = pcall(hydra_factory)
  -- if not ok then
  --   vim.notify("Generate Hydra " .. key .. " Failed", vim.log.levels.ERROR)
  --   return
  -- end

  hydra = hydra_factory()

  hydra:activate()
end

return M
