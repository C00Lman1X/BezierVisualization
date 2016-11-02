io.stdout:setvbuf("no")

Point = require("point")
require("utils")
Bar = require("Bar")
Bezier = require("bezier")
Button = require("Button")

function onAdd()
	crv:addPoint()
end

function onDel()
	crv:delPoint()
end

function love.load()
	counter = 0
	fpsCounter = 0
	fps = 0
	love.graphics.setBackgroundColor(255, 255, 255)

	bar = Bar:new(100, 20, 500)

	crv = Bezier:new{{x=200, y=200},
									 {x=500, y=200}}

	btnAddPoint = Button:new(700, 100, 100, 17, 'Add point', onAdd)
	btnDelPoint = Button:new(700, 120, 100, 17, 'Del point', onDel)

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
	if btnAddPoint:isIn(x,y) then
		btnAddPoint.fn()
	end
	if btnDelPoint:isIn(x,y) then
		btnDelPoint.fn()
	end
end

function love.mousereleased( x, y, button, istouch )
	bar.cpt = false
	crv.cpt = 0
end

function love.mousemoved(x, y, dx, dy, istouch)
	if bar.cpt then
		bar:move(dx)
	end
	if crv.cpt ~= 0 then
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
	btnAddPoint:draw()
	btnDelPoint:draw()
	
end
