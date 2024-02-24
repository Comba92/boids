package.path = package.path .. ";../../?.lua;D:/code/love2d/libs/?.lua"
SpatialHash = require('spatialhash')
Vector = require('brinevector')

W, H = love.window.getMode()

local size = 400

Sh = SpatialHash.new(W, H)
Points = {}


local qsize = 15
function love.load()
end

function love.mousepressed()
  local mx, my = love.mouse.getPosition()
  if love.mouse.isDown(1) then Sh:insert(Vector(mx, my)) end
  if love.mouse.isDown(2) then Sh:query(Vector(mx, my), qsize, qsize) end
end

function love.update(dt)
  require('lurker').update()
end

function love.draw()
  Sh:debug()
  love.graphics.print('Sectors: ' .. #Sh.sectors+1, 10, 10)
  love.graphics.print('Items: ' .. Sh.count, 10, 20)

  local mx, my = love.mouse.getPosition()
  love.graphics.circle('line', mx, my, qsize)
end
