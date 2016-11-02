io.stdout:setvbuf("no")

Point = require("point")
require("utils")
Bar = require("Bar")
Bezier = require("bezier")
local shine = require("shine")

function love.load()
  counter = 0
  fpsCounter = 0
  fps = 0
  love.graphics.setBackgroundColor(255, 255, 255)

  bar = Bar:new(100, 20, 500)

  crv = Bezier:new(4, {200, 200,
                       500, 200,
                       200, 600,
                       500, 600})

end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end
end

function love.mousepressed( x, y, button, istouch )
  if bar:isIn(x,y) then
    bar.cpt = true
  end
  crv:checkMouse(x,y)
end

function love.mousereleased( x, y, button, istouch )
  bar.cpt = false
  crv.cpt = ''
end

function love.mousemoved(x, y, dx, dy, istouch)
  if bar.cpt then
    bar:move(dx)
  end
  if crv.cpt ~= '' then
    crv:move(x,y)    
  end
end

function love.update(dt)
  --FPS
  time = dt
  counter = counter + dt
  fpsCounter = fpsCounter + 1
  if counter >= 1 then
    counter = 0
    fps = fpsCounter
    fpsCounter = 0
  end
end

function love.draw()
  love.graphics.setColor(0, 0, 0)
  love.graphics.print(string.format('Time: %.04f', time), 0, 0)
  love.graphics.print('FPS: '.. fps, 0, 15)
  x, y = love.mouse.getPosition()
  love.graphics.print(string.format('%d, %d', x, y), 0, 30)

  bar:draw()
  crv:draw()
  
end