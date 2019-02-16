pico-8 cartridge // http://www.pico-8.com
version 16
__lua__


function _init()
	cls()
	testball=ball:new(vec2:new(64,64),2)
	testball.phys:addforce(vec2:new(10,10))
end

function _update60()
	physics:update()
--	test=test..testball.p0s
end

test=""
function _draw()
	cls()
	testball:draw()
	print(test,0,0)
	test=""
end
-->8
--object defs

ball = {

	num = 1,
	r = 4,
	phys = nil,
	pos = nil,

	new=function(self,p,num)
		local o = {}
		setmetatable(o,self)
		self.__index=self
		
		o.phys=physicsbody:new{
			pos=p,
			gravity=false
		}

		
		o.num=num or 1
		
		o.pos = o.phys.pos
		
		return o
	end,
	
	draw = function(self)
		print(self.pos.x..", "..self.pos.y
		.."\n"..self.phys.vel.x..", "..self.phys.vel.y)
		
		--assign pool ball color
		local c = self:getcolor()
		circfill(self.pos.x,self.pos.y,
			self.r,c)
		circfill(self.pos.x,self.pos.y,
			self.r/2,7)
		print(self.num,
			self.pos.x-self.r/2,
			self.pos.y-self.r/2
		)
	end,
	
	getcolor = function(self)
		if self.num==1 or self.num==9 then
		 return 14 
		end
		if self.num==2 or self.num==10 then
		 return 1
		end
		if self.num==3 or self.num==11 then
		 return 9 
		end
		if self.num==4 or self.num==12 then
		 return 2 
		end
		if self.num==5 or self.num==13 then
		 return 14 
		end
		if self.num==6 or self.num==14 then
		 return 3 
		end
		if self.num==7 or self.num==15 then
		 return 8 
		end
		if self.num==8 then return 0 end
	end
}
-->8
--helpers

vec2 = {
	new=function(self,x,y)
		local o={}
		setmetatable(o,self)
		self.__index=self
		
		o.x = x
		o.y = y
		
		return o
	end,
	
	__unm = function(vec)
		return vec2:new(-vec.x,-vec.y)
	end,
	
	__add = function(lhs,rhs)
		return vec2:new(
			lhs.x+rhs.x,
			lhs.y+rhs.y
		)
	end,
	
	__sub = function(lhs,rhs)
		return vec2:new(
			lhs.x-rhs.x,
			lhs.y-rhs.y
		)
	end,	
	
	__scalarmul = function(scalar, vec)
		return vec2:new(
			scalar * vec.x,
			scalar * vec.y
		)
	end,
	
	__mul = function(lhs,rhs)
		if type(lhs)=="number" then
		 return vec2.__scalarmul(lhs,rhs)
		elseif type(rhs)=="number" then
			return vec2.__scalarmul(rhs,lhs)
		end
		
		--vec * vec defaults to component-wise
		--like opengl
		--(dot should be called manually)
		lhs.x *= rhs.x
		lhs.y *= rhs.y
		return lhs		
	end,	
	
	__div = function(lhs,rhs)
		--component-wise
		return vec2:new(
			lhs.x / rhs.x,
			lhs.y / rhs.y
		)
	end,
		
	dot = function(self,rhs)
		return self.x*rhs.x + self.y*rhs.y
	end,
	
	perp = function(self)
		swap(self.x,self.y)
		self.y = -self.y
		return self
	end,
	
	vecto = function(self,dst)
		return dst - self
	end,
	
	magnitude = function(self)
		return sqrt(self.x*self.x + self.y*self.y)
	end,
	
	sqrmagnitude = function(self)
		return self.x*self.x + self.y*self.y
	end,
	
	zero = function()
		return vec2:new(0,0)
	end
}

physics = {
	bodies = {},
	
	gravity = vec2:new(0,0.25),

	update = function(self)
		for b in all(self.bodies) do
			b:update()
		end
	end
}

physicsbody = {
	pos=vec2:new(0,0),
	vel=vec2:new(0,0),
	accel=vec2:new(0,0),
	gravity=true,
	m=1,mu=0.05,
	
	new=function(self,t)
		--inspiration:
		--https://stackoverflow.com/questions/6022519/define-default-values-for-function-arguments
		setmetatable(t,
			{__index=
				{
					pos=vec2:zero(),
					vel=vec2:zero(),
					accel=vec2:zero(),
					gravity=true,
					m=1,mu=0.05,
				}
			}
		)
		
		local o = {}
		setmetatable(o, self)
		self.__index = self
		
		o.pos = t[1] or t.pos
		o.vel = t[2] or t.vel
		o.accel = t[3] or t.accel
		o.gravity=t[4] or t.gravity
		o.m=t[5] or t.m
		o.mu=t[6] or t.mu
		
		add(physics.bodies,o)
		return o	
	end,
	
	update=function(self)
		--gravity
		if self.gravity then
			self:addforce(physics.gravity)
		end
		
		--accelerate
		self.vel = self.vel+self.accel

		--move
		local dp = self.pos+self.vel
		self.pos = dp
		stop(self.pos.x..", "..self.pos.y)
	
		--test=test.."ddy: "..self.ddy.."\n"
		--reset
		self.accel = vec2:new(0,0)
		--"drag"
		self.vel=lerp(self.vel,vec2.zero(),self.mu)
	end,
	
	addforce=function(self,f)
		self.vel = self.vel + (f*self.m)
	end
	
}

function lerp(a,b,t)
	return a + (b-a)*t
end

function distance(x,y)
	return x:vecto(y):magnitude()
end

function distsqr(xi,yi,xf,yf)
	return x:vecto(y):sqrmagnitude()
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

function swap(x,y)
	if x == y then return end
	x = bxor(x,y)
	y = bxor(x,y)
	x = bxor(x,y)
end
