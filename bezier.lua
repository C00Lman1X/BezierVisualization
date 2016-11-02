if Point == nil then
	Point = require("Point")
end
local Bezier = {}

function Bezier:new(points)
	newObj = {}
	newObj.points = points
	points_table = {}
	for i, p in pairs(points) do
		table.insert(points_table, p.x)
		table.insert(points_table, p.y)
	end

	newObj.t = 0.0
	newObj.cpt = 0
	newObj.levels = {}
	
	self.__index = self
	setmetatable(newObj, self)
	newObj:refresh()
	return newObj
end

function Bezier:draw()
	r, g, b, a = love.graphics.getColor()

	love.graphics.setColor(0, 0, 0, 128)
	for i = 1,#self.points do
		local p = self.points[i]
		love.graphics.circle('fill', p.x, p.y, 3)
		if i>1 then
			local prev = self.points[i-1]
			love.graphics.line(prev.x, prev.y, p.x, p.y)
		end
	end

	levels = self.levels
	for lvl = 2,#levels do
		love.graphics.setColor(70+30*lvl, 0, 0, 255)
		for i = 1, #levels[lvl] do
			local p = levels[lvl][i]
			love.graphics.circle('fill', p.x, p.y, 3)
			if i > 1 then
				local prev = levels[lvl][i-1]
	love.graphics.line(prev.x, prev.y, p.x, p.y)
			end
		end
	end

	love.graphics.setColor(255, 0, 0, 255)
	love.graphics.line(self.curve:render(5))

	love.graphics.setColor(0, 0, 0, 255)
	tx, ty = self.curve:evaluate(self.t)
	love.graphics.circle('fill', tx, ty, 3)

	mx, my = love.mouse.getPosition()
	for i = 1, #self.points do
		if self:isNear(mx, my, self.points[i]) then
			love.graphics.circle('line', self.points[i].x, self.points[i].y, 5)
		end
	end

	love.graphics.setColor(r, g, b, a)
end

function dist(x1,y1,x2,y2)
	return math.sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2))
end

function Bezier:generateLevels()
	local t = self.t
	local levels = {self.points}

	for i = 2,#self.points do
		table.insert(levels, {})
		for l = 2, #levels do
			local newPoint = {}
			local prevP1, prevP2 = levels[l-1][i-(l-2)-1],levels[l-1][i-(l-2)]
			newPoint.x = prevP1.x + (prevP2.x-prevP1.x)*t
			newPoint.y = prevP1.y + (prevP2.y-prevP1.y)*t
			table.insert(levels[l], newPoint)
		end
	end
	self.levels = levels
end

function Bezier:isNear(x,y,p)
	if dist(x, y, p.x, p.y) <= 5 then
		return true
	end
	return false
end

function Bezier:checkMouse(x,y)
	for i,p in pairs(self.points) do
		if self:isNear(x,y, p) then
			self.cpt = i
			break
		end
	end
end

function Bezier:move(x,y)
	self.points[self.cpt].x = x
	self.points[self.cpt].y = y
	self:refresh()
end

function Bezier:refresh()
	local points = {}
	for i,p in pairs(self.points) do
		table.insert(points, p.x)
		table.insert(points, p.y)
	end
	self.curve = love.math.newBezierCurve(points)
	self:generateLevels()
end

function Bezier:addPoint()
	local vx = self.points[#self.points].x - self.points[#self.points-1].x
	local vy = self.points[#self.points].y - self.points[#self.points-1].y
	local vec = Point:new(vx,vy)
	vec:vecNormalize()
	vec:vecRotate90()
	local newP = vec:vecGetPoint(self.points[#self.points].x, self.points[#self.points].y, 200)
	table.insert(self.points, {x=newP.x, y=newP.y})
	self:refresh()
end

function Bezier:delPoint()
	if #self.points	< 3 then
		return
	end
	self.points[#self.points] = nil
	self:refresh()
end

return Bezier