local Bar = {}
function Bar:new(_x, _y, _length)
	newObj = {
		x = _x,
		y = _y,
		l = _length,
		t = 0,
		cpt = false
	}
	self.__index = self
	return setmetatable(newObj, self)
end

function Bar:draw()
	r, g, b, a = love.graphics.getColor()

	love.graphics.setColor(0, 0, 0, 255)

	love.graphics.print(string.format('t=%.03f', self.t), self.x, self.y-15)

	love.graphics.line(self.x, self.y, self.x, self.y+30)
	love.graphics.line(self.x, self.y+15, self.x+self.l, self.y+15)
	for i = 1,9 do
		love.graphics.line(self.x+i*self.l/10, self.y+10, self.x+i*self.l/10, self.y+20)
	end
	love.graphics.line(self.x+self.l, self.y, self.x+self.l, self.y+30)

	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.rectangle('fill', self.x+self.l*self.t-5, self.y+5, 10, 20)
	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.rectangle('line', self.x+self.l*self.t-5, self.y+5, 10, 20)

	mx, my = love.mouse.getPosition()
	if self:isIn(mx, my) or self.cpt then
		love.graphics.setColor(0, 255, 0, 255)
		love.graphics.rectangle('line', self.x+self.l*self.t-6, self.y+4, 12, 22)
	end

	love.graphics.setColor(r, g, b, a)
end

function Bar:isIn(x,y)
	if x > self.x+self.l*self.t-5 and x < self.x+self.l*self.t+5 then
		if y > self.y+5 and y < self.y+25 then
			return true
		end
	end
	return false
end

function Bar:move(dx)
	self.t = self.t + dx/self.l
	if self.t > 1 then
		self.t = 1
	elseif self.t < 0 then
		self.t = 0
	end
	crv.t = self.t
	crv:generateLevels()
end

return Bar
