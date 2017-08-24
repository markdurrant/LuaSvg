local path = { label = "path" }
      path.metatable = { __index = path }

function path:new(t)
  if not t then t = {} end
  if not t.points then t.points = {} end
  if not t.closed then t.closed = false end

  setmetatable(t, path.metatable)

  return t
end

function path:log()
  local pathLog = string.format("path { closed = %s }", self.closed)

  for i, point in ipairs(self.points) do
    pathLog = pathLog .. string.format(
      "\n  point :%s { x = %s, y = %s }",
      i, point.x, point.y
    )
  end

  print(pathLog)
end

function path:addPoint(...)
  for _, point in ipairs({ ... }) do
    table.insert(self.points, point)
  end
end

function path:setPen(pen)
  table.insert(pen.paths, self)
end

function path:rotate(angle, origin)
  for _, point in ipairs(self.points) do
    point:rotate(angle, origin)
  end
end

function path:move(x, y)
  for _, point in ipairs(self.points) do
    point:move(x, y)
  end
end

function path:clone()
  local t = {}

  for _, point in ipairs(self.points) do
    table.insert(t, point)
  end

  return path:new({ points = t, closed = self.closed })
end

function path:render()
  local pathTag = ""

  for i, point in ipairs(self.points) do
    if i == 1 then
      pathTag = "M "
    else
      pathTag = pathTag .. " L"
    end

    pathTag = pathTag .. point.x .. " " .. point.y
  end

  if self.closed == true then pathTag = pathTag .. " Z" end

  pathTag = '<path d="' .. pathTag .. '"/>'

  return pathTag
end

return path