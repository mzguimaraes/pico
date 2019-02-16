pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
--a game
--by marcus zaeyen

function _init()
	player:init()
end

function _update60()
	player:update()
	
	physics:update()
end

maxdy=0
function _draw()
	cls(1)
	player:draw()
	if player.phys.dy>maxdy then
		maxdy=player.phys.dy
	end
	print("dx: "..player.phys.dx..
		"\nmax dy: "..maxdy,0,0)
end
-->8
--physics and helpers

physics = {
	bodies = {},
	
	gravity = 0.25,

	update = function(self)
		for b in all(self.bodies) do
			b:update()
		end
	end
}

physicsbody = {
	x=0,y=0,
	dx=0,dy=0,
	ddx=0,ddy=0,
	gravity=true,
	m=1,mu=0.05,
	
	new=function(self,t)
		--inspiration:
		--https://stackoverflow.com/questions/6022519/define-default-values-for-function-arguments
		setmetatable(t,
			{__index={
				x=0,y=0,
				dx=0,dy=0,
				ddx=0,ddy=0,
				gravity=true,
				m=1,mu=0.05,
			}
		})
		
		local o = {}
		setmetatable(o, self)
		self.__index = self
		
		o.x=t[1] or t.x
		o.y=t[2] or t.y
		o.dx=t[3] or t.dx
		o.dy=t[4] or t.dy
		o.ddx=t[5] or t.ddx
		o.ddy=t[6] or t.ddy
		o.gravity=t[7] or t.gravity
		o.m=t[8] or t.m
		o.mu=t[9] or t.mu
		
		add(physics.bodies,o)
		return o	
	end,
	
	update=function(self)
		--gravity
		if self.gravity then
			self:addforce(0,physics.gravity)
			--self.dy+=physics.gravity
		end
		--accelerate
		self.dx+=self.ddx
		self.dy+=self.ddy

		
		--move
		self.x+=self.dx
		self.y+=self.dy
	
		--test=test.."ddy: "..self.ddy.."\n"
		--reset
		self.ddx=0
		self.ddy=0
		--"drag"
		self.dx=lerp(self.dx,0,self.mu)
		self.dy=lerp(self.dy,0,self.mu)
	end,
	
	addforce=function(self,x,y)
		self.ddx+=x*self.m
		self.ddy+=y*self.m
	end
	
}

function lerp(a,b,t)
	return a + (b-a)*t
end

function inversevec(x,y)
	return -x,-y
end

function perpvec(x,y)
	return y,-x
end

function vecbtwn(xi,yi,xf,yf)
	return xf-xi,yf-yi
end

function distance(xi,yi,xf,yf)
	local dx=xf-xi
	local dy=yf-yi
	return sqrt(dx*dx + dy*dy)
end

function distsqr(xi,yi,xf,yf)
	local dx=xf-xi
	local dy=yf-yi
	return dx*dx + dy*dy
end

function mag(dx,dy)
	return distance(0,0,dx,dy)
end

function magsqr(dx,dy)
	return distsqr(0,0,dx,dy)
end

function overlapping(x1,y1,w1,h1,
	x2,y2,w2,h2)
	
	return (
		x1+w1>x2 and
		y1+h1>y2 and
		x2+w2>x1 and
		y2+h2>y1
	)
end
-->8
--objects

player = {
	phys = nil,
	r=8,
	
	init = function(self)
		self.phys = physicsbody:new{
			x=64,y=64,dx=1,mu=0
		}
	end,
	
	update = function(self)
		if self.phys.x > 128-self.r then
			self.phys.x=128-self.r
			self.phys:addforce(-2*self.phys.dx,0)
		elseif self.phys.x < self.r then
			self.phys.x=self.r
			self.phys:addforce(-2*self.phys.dx,0)
		elseif self.phys.y > 128-self.r then
			self.phys.y=128-self.r
			self.phys:addforce(0,-2*self.phys.dy)
		elseif self.phys.y < self.r then
			self.phys.y=self.r
			self.phys:addforce(0,-2*self.phys.dy)
		end
	end,
	
	draw = function(self)
		circ(self.phys.x,self.phys.y,8,13)
		circ(self.phys.x+2,self.phys.y-2,2,12)
	end
}
