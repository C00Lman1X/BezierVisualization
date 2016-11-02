local Button = {}

function Button:new(_x, _y, _w, _h, _txt, _fn)
	newObj = {
		x = _x,
		y = _y,
		w = _w,
		h = _h,
		txt = _txt,
		fn = _fn
	}

	self.__index = self
	return setmetatable(newObj, self)
end

function Button:isIn(x, y)
	if x > self.x and x < self.x+self.w then
		if y > self.y and y < self.y+self.h then
			return true
		end
	end
	return false
end

function Button:draw()
	r, g, b, a = love.graphics.getColor()

	love.graphics.setColor(0,0,0, 128)
	love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
	love.graphics.setColor(0,0,0, 255)
	love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
	love.graphics.printf(self.txt, self.x, self.y, self.w, 'center')

	love.graphics.setColor(r, g, b, a)
end

return Button