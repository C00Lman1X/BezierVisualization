local Bezier = {}

function Bezier:new(points_count, points_table)
  newObj = {}
  for i = 1,points_count do
    p = { x = points_table[i*2-1], y = points_table[i*2-1+1]}
    newObj['P'..i-1] = p
  end

  newObj.count = points_count
  newObj.curve = love.math.newBezierCurve(points_table)
  newObj.t = 0.0
  newObj.cpt = ''
  
  self.__index = self
  return setmetatable(newObj, self)
end

function Bezier:draw()
  r, g, b, a = love.graphics.getColor()

  local P0, P1, P2, P3, P4, t = self.P0, self.P1, self.P2, self.P3, self.P4, self.t

  love.graphics.setColor(0, 0, 0, 128)
  for i = 1, self.count do
    love.graphics.circle('fill', self['P'..i-1].x, self['P'..i-1].y, 3)
    if i>1 then
      love.graphics.line(self['P'..i-1].x, self['P'..i-1].y, self['P'..i-2].x, self['P'..i-2].y)
    end
  end

  local Q0, Q1, Q2, Q3, Q4
  local R0, R1, R2
  local S0, S1

  if self.count >= 3 then
    love.graphics.setColor(0, 255, 0, 255)

    Q0 = { x = P0.x+(P1.x-P0.x)*t, y = P0.y+(P1.y-P0.y)*t}
    Q1 = { x = P1.x+(P2.x-P1.x)*t, y = P1.y+(P2.y-P1.y)*t}
    love.graphics.line(Q0.x, Q0.y, Q1.x, Q1.y)
    love.graphics.circle('fill', Q0.x, Q0.y, 3)
    love.graphics.circle('fill', Q1.x, Q1.y, 3)
  end
  if self.count >= 4 then
    Q2 = { x = P2.x+(P3.x-P2.x)*t, y = P2.y+(P3.y-P2.y)*t}
    love.graphics.line(Q1.x, Q1.y, Q2.x, Q2.y)
    love.graphics.circle('fill', Q1.x, Q1.y, 3)
    R0 = { x = Q0.x+(Q1.x-Q0.x)*t, y = Q0.y+(Q1.y-Q0.y)*t}
    R1 = { x = Q1.x+(Q2.x-Q1.x)*t, y = Q1.y+(Q2.y-Q1.y)*t}
    love.graphics.setColor(0, 0, 255, 255)
    love.graphics.line(R0.x, R0.y, R1.x, R1.y)
    love.graphics.circle('fill', R0.x, R0.y, 3)
    love.graphics.circle('fill', R1.x, R1.y, 3)
  end

  love.graphics.setColor(255, 0, 0, 255)
  love.graphics.line(self.curve:render(5))

  love.graphics.setColor(0, 0, 0, 255)
  tx, ty = self.curve:evaluate(t)
  love.graphics.circle('fill', tx, ty, 3)

  mx, my = love.mouse.getPosition()
  if self:isNear(mx,my, P0) then
    love.graphics.circle('line', P0.x, P0.y, 5)
  elseif P1 and self:isNear(mx,my, P1) then
    love.graphics.circle('line', P1.x, P1.y, 5)
  elseif P2 and self:isNear(mx,my, P2) then
    love.graphics.circle('line', P2.x, P2.y, 5)
  elseif P3 and self:isNear(mx,my, P3) then
    love.graphics.circle('line', P3.x, P3.y, 5)
  end

  love.graphics.setColor(r, g, b, a)
end

function dist(x1,y1,x2,y2)
  return math.sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2))
end

function Bezier:isNear(x,y,p)
  if dist(x, y, p.x, p.y) <= 5 then
    return true
  end
  return false
end

function Bezier:checkMouse(x,y)
  for i = 1,self.count do
    if self:isNear(x,y, self['P'..i-1]) then
      self.cpt = 'P'..i-1
      print(self.cpt)
      break
    end
  end
end

function Bezier:move(x,y)
  self[self.cpt].x = x
  self[self.cpt].y = y
  local points = {}
  for i = 1,self.count do
    table.insert(points, self['P'..i-1].x)
    table.insert(points, self['P'..i-1].y)
  end
  self.curve = love.math.newBezierCurve(points)

end

return Bezier