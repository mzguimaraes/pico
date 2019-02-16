pico-8 cartridge // http://www.pico-8.com
version 16
__lua__


function _init()
	player:init()
	cam.following=player.phys
	initstars()
	--can:new()
end

function _update60()
	player:update()
	physics:update()
	cam:update()
	
	spawntimer+=1/60
	if spawntimer>=spawnrate then
		can:new()
		spawntimer=0
	end
end

function _draw()
	cls()
	camera(cam.x,cam.y)
	
	--circfill(64,64,16,1)
	
	for s in all(stars) do
		s:draw()
	end
	
	--ground:draw()
	
	player:draw()
	
	for c in all(cans) do
		c:draw()
	end

	--altimeter:draw()
	fuelmeter:draw()
	
	--print("vel: "..player.phys.dy,
	--	cam.x+46,cam.y+120,7)
	print("cans collected: "..player.score,
		cam.x+20,cam.y+120,7)
end
-->8
--objects

spawntimer=0

player = {
	phys=nil,
	verts={
		tip={4,0},
		top={-4,-4},
		mid={-2,0},
		bot={-4,4}
	},
	theta=0,
	dtheta=0,
	maxdtheta=.02,
	maxvel=3,
	accel=.25,
	fuel=49,
	drain=1/16,
	score=0,
	
	init=function(self)
		self.phys=physicsbody:new{
			x=54,y=64,
			--gravity=false,
			mu=.125
		}
	end,
	
	update=function(self)
		--rotation
		if btn(⬅️) and self.fuel>0 then
			self.dtheta+=.01
			self.fuel-=(self.drain/2)
		elseif btn(➡️) and self.fuel>0 then
			self.dtheta-=.01
			self.fuel-=(self.drain/2)
		end
		
		self.dtheta=min(
			abs(self.dtheta),self.maxdtheta)
			*sgn(self.dtheta)
		
		self.theta+=self.dtheta
		self.dtheta=lerp(
			self.dtheta,0,0.1
		)
		
		--movement
		local mov=0
		if btn(⬆️) and self.fuel>0 then
			mov+=self.accel
			self.fuel-=self.drain
		end
		
		local cmag=mag(self.phys.dx,self.phys.dy)
		if cmag>self.maxvel-self.accel then
				mov=self.maxvel-cmag
		end
		
		--rotate
		local dx=mov*cos(self.theta)
		local dy=mov*sin(self.theta)
		
		self.phys.ddx=dx
		self.phys.ddy=dy
		
		//self.phys.ddy+=.02
		
		--self.vel=lerp(self.vel,0,0.1)
		
		for c in all(cans) do
			if overlapping(
				self.phys.x-4,self.phys.y-4,8,8,
				c.phys.x,c.phys.y,4,4
			) then
				self.score+=1
				del(cans,c)
				self.fuel+=rnd(20)
			end
		end
		
		self.fuel-=.0125
		
	end,
	
	draw=function(self)
		local tverts={}
		for k,v in pairs(self.verts) do
			tverts[k]=v
			tverts[k]=rotvert(tverts[k],self.theta)
			tverts[k]=vert2xy(tverts[k],self)
		end
		
		vertline(tverts.tip,tverts.top,6)
		vertline(tverts.top,tverts.mid,6)
		vertline(tverts.mid,tverts.bot,6)
		vertline(tverts.bot,tverts.tip,6)
	end,
	
}

cans={}

can = {
	phys=nil,
	
	new=function(self)
		local o = {}
		setmetatable(o,self)
		self.__index=self
		
		o.phys=physicsbody:new{
			x=player.phys.x-32+flr(rnd(64)),
			y=cam.y+128+flr(rnd(15)),
			dy=player.phys.dy,
			gravity=false
		}
		
		add(cans,o)
		return o
	end,
	
	draw=function(self)
		rectfill(self.phys.x,self.phys.y,
			self.phys.x+4,self.phys.y+4,8)
	end
}

stars = {}

star = {
	x=0,y=0,

	new=function(self,x,y)
		local o = {}
		setmetatable(o,self)
		self.__index=self
		
		o.x=x
		o.y=y
		
		add(stars,o)
		return o
	end,
	
	draw=function(self)
		local x=((self.x+cam.x)%128)+cam.x
		local y=((self.y+cam.y)%128)+cam.y
		pset(x,y,7)
	end
}

function initstars()
	for i=1,100 do
		star:new(
			flr(rnd(128)),flr(rnd(128))
		)
	end
end

ground = {

	draw=function(self)
		rectfill(cam.x,endy,
			cam.x+128,endy+128,4)
	end
}

altimeter={
	draw=function(self)
		print("alt",cam.x+115,cam.y+4,7)
		line(cam.x+120,cam.y+14,
			cam.x+120,cam.y+114,7)
		local my=cam.y+14+128*(player.phys.y/endy)
		line(cam.x+115,my,
			cam.x+125,my,8)
	end
}

fuelmeter={
	draw=function(self)
		print("fuel",cam.x+1,cam.y+4,7)
		rect(cam.x+4,cam.y+12,
			cam.x+12,cam.y+114,7)
			
		local col
		if player.fuel<10 then
			col=8
		elseif player.fuel<25 then
			col=9
		elseif player.fuel<50 then
			col=10
		else
			col=3
		end
		
		rectfill(cam.x+5,cam.y+113-player.fuel,
			cam.x+11,cam.y+113,col)
	end
}


-->8
--physics

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
--rendering

cam={x=0,y=0,stress=0,
	following=nil, followspeed=.15,
	update=function(self)
		
		if self.following~=nil then
			
			--self.x=flr((lerp(self.x,
			--	self.following.x-64,
			--	self.followspeed)))
			self.y=flr((lerp(self.y,
				self.following.y-16,
				self.followspeed)))
		end
		
		if self.stress>0 then
			local r = rnd()
			self.x=cos(r)*self.stress
			self.y=sin(r)*self.stress
			
			self.stress=lerp(self.stress,0,.15)
			if self.stress<.05 then
				self.stress=0
			end
		end
	end
}

function vertline(v1,v2,c)
	line(v1[1],v1[2],v2[1],v2[2],c)
end

function rotvert(v,t)
	local x=v[1]*cos(t)-v[2]*sin(t)
	local y=v[1]*sin(t)+v[2]*cos(t)
	return {x,y}
end

function vert2xy(v,c)
	local x=c.phys.x+v[1]
	local y=c.phys.y+v[2]
	
	return {x,y}
end


-->8
--constants

endy=5000

nummax=32767.0
nummin=-nummax

spawnrate=5
