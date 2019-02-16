pico-8 cartridge // http://www.pico-8.com
version 16
__lua__


function _init()
	player:init()
end

function _update60()
	player:update()
end

function _draw()
	cls()
	player:draw()

end
-->8
--objects

player = {
	phys=nil,
	verts={
		tip={4,0},
		top={-4,-4},
		mid={-2,0},
		bot={-4,4}
	},
	theta=0,
	
	init=function(self)
		self.phys=physicsbody:new{
			x=16,y=64,
			gravity=false
		}
	end,
	
	update=function(self)
		--self.theta+=1/300
		if btn(⬅️) then
			self.theta+=.1
		elseif btn(➡️) then
			self.theta-=.1
		end
		
		print(self.theta)
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


