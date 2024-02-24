local HashMap = {}
HashMap.__index = HashMap

function HashMap.new()
  local map = {
    count = 0,
    items = {}
  }

  return setmetatable(map, HashMap)
end

function HashMap:get(pos)
  return self.items[tostring(pos)]
end

function HashMap:insert(pos)
  self.items[tostring(pos)] = pos
  self.count = self.count + 1
  print(self.count)
end

function HashMap:remove(pos)
  self.items[tostring(pos)] = nil
  self.count = self.count - 1
end


local SpatialHash = {}
SpatialHash.__index = SpatialHash

SpatialHash.density = 10

function SpatialHash.new(w, h)
  local sectors = {}

  local sw, sh = w/SpatialHash.density, h/SpatialHash.density
  for y=0, SpatialHash.density-1 do
    for x=0, SpatialHash.density-1 do
      local idx = y * SpatialHash.density + x
      sectors[idx] = HashMap.new()
    end
  end

  local sh = {
    w = w,
    h = h,
    sector_w = w/SpatialHash.density,
    sector_h = h/SpatialHash.density,
    count = 0,
    sectors = sectors
  }
  return setmetatable(sh, SpatialHash)
end

function SpatialHash:getIdx(pos)
  pos.x = math.floor(pos.x / (self.w / SpatialHash.density))
  pos.y = math.floor(pos.y / (self.h / SpatialHash.density))
  return pos.y * SpatialHash.density + pos.x
end

function SpatialHash:insert(pos)
  local idx = self:getIdx(pos)
  self.sectors[idx]:insert(pos)
  self.count = self.count + 1
end

function SpatialHash:remove(pos)
  local idx = self:getIdx(pos)
  self.sectors[idx]:remove(pos)
end

function SpatialHash:update(pos)

end

function SpatialHash:query(pos, w, h)

end

function SpatialHash:debug()
  for x=0, SpatialHash.density do
    love.graphics.line(x * (self.w / SpatialHash.density), 0, x * (self.w / SpatialHash.density), self.h)
  end

  for y=0, SpatialHash.density do
    love.graphics.line(0, y * (self.h / SpatialHash.density), self.w, y * (self.h / SpatialHash.density))
  end
end

return SpatialHash