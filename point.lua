local Point = {}
function Point:new(_x, _y)
	newObj = {
		x = _x or 0,
		y = _y or 0
	}
	self.__index = self
	return setmetatable(newObj, self)
end

function Point:dist(point)
	local dst = 0.0
	dst = ((self.x-point.x)*(self.x-point.x) + (self.y-point.y)*(self.y-point.y)) ^ 0.5
	return dst
end

function Point:isNear(x, y)
	return self:dist(Point:new(x, y)) < 15.0
end

function Point.__add(p1, p2)
	return Point:new(p1.x+p2.x, p1.y+p2.y)
end
function Point.__sub(p1, p2)
	return Point:new(p1.x-p2.x, p1.y-p2.y)
end

-- VECTOR
function Point:vecModule()
	return self:dist(Point:new(0, 0))
end
function Point:vecNormalize()
	local d = self:vecModule()
	self.x = self.x/d
	self.y = self.y/d
end
function Point:vecGetPoint(x0, y0, _m)
	local m = _m or 1
	return Point:new(x0+self.x*m, y0+self.y*m)
end
function Point:vecRotate90(clockwise)
	local x = self.x
	if not clockwise then
		self.x = self.y
		self.y = -x
	else
		self.x = -self.y
		self.y = x
	end
end

return Point