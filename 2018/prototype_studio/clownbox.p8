pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
--clownbox
--by marcus zaeyen

function _init()
	ring:new(48,64)
end

function _update60()
	box:update()
	hand:update()
end


test=""
function _draw()
	cls()
	--draw floor
	rectfill(0,114,128,128,4)
	
	for r in all(rings) do
		r:draw()
	end
	
	hand:draw()
	box:draw()
	
	print(test,0,0,7)
	test=""
end
-->8
--object definitions
box = {
	x=32, y=64,
	dx=0,dy=0,
	ddx=0,ddy=0,
	len=8,
	
	update = function(self)
		
		--gravity
		self.ddy+=gravity
		
		--accelerate
		self.dx += self.ddx
		self.dy += self.ddy
		
		test=test.."vel: "..self.dx..", "..self.dy.."\n"
		
		--move
		if not hand.gripping then
			self.x += self.dx
			self.y += self.dy
		else
			local cx,cy=moveoncircle(
				self.dx,self.dy,
				self.x,self.y,
				hand.gripping.x,hand.gripping.y
			)
			self.x+=cx
			self.y+=cy
			test=test..cx..", "..cy
		end
		
		--bounds check
		if self.y>112 then
			self.y=112
			self.dy=0
		end
		
		self.ddx=0
		self.ddy=0
	end,
	
	draw = function(self)
		local d = self.len / 2
		rectfill(
			self.x-d,self.y-d,
			self.x+d,self.y+d,
			8
		)
		line(
			self.x,self.y-d,
			self.x,self.y+d,
			7
		)
		line(
			self.x-d,self.y,
			self.x+d,self.y,
			7
		)
	end
	
}

hand = {
	--pos rel to box
	x=0,y=0,
	gripping=nil,
	theta=0.125,
	ntheta=0.125,
	armlen=24,
	r=2,
	
	update = function(self)
	
		if btnp(❎) then
			self.gripping=h_r_overlap()
		elseif self.gripping and not btn(❎) then
			self.gripping = nil
		end
	
		if not self.gripping then
			--set pos
			self.x=cos(self.theta)
			self.x*=self.armlen
			self.x+=box.x
			self.y=sin(self.theta)
			self.y*=self.armlen
			self.y+=box.y
		else
			self.x=self.gripping.x
			self.y=self.gripping.y
		end
		
		--update theta
		self.theta=atan2(self.x-box.x,
			self.y-box.y)
		self.theta=lerp(self.theta,
			self.ntheta,0.25)
	end,
	
	draw = function(self)
		line(
			self.x,self.y,
			box.x,box.y,
			5
		)
		circfill(self.x,self.y,
			self.r,7)
	end
}

rings = {}

ring = {
	x=0,y=0,
	r=3,
	
	new=function(self,x,y)
		o={}
		setmetatable(o,self)
		self.__index=self
		
		o.x=x
		o.y=y
		
		add(rings,o)
		return o
	end,
	
	draw=function(self)
		circ(self.x,self.y,self.r,10)
	end
}
-->8
--consts and helper functions

gravity = .125 --pixels/frame^2

function overlapping(x1,y1,w1,h1,
x2,y2,w2,h2)
	return (
		x1+w1>x2 and
		y1+h1>y2 and
		x2+w2>x1 and
		y2+h2>y1
	)
end

function h_r_overlap()
	for r in all(rings) do
		if overlapping(
			hand.x-hand.r-2,
			hand.y-hand.r-2,
			hand.r*2+4,hand.r*2+4,
			r.x-r.r,r.y-r.r,
			r.r*2,r.r*2
		) 
		
		then
			return r
		end
	end
	
	return nil
end

function distance(x1,y1,x2,y2)
	return sqrt(dist_sqr(x1,y1,x2,y2))
end

function dist_sqr(x1,y1,x2,y2)

	return (x2-x1)*(x2-x1)+
		(y2-y1)*(y2-y1)
end

function mag(vx,vy)
	return distance(vx,vy,0,0)
end

function circnorm(x,y,cx,cy)
	local r=distance(x,y,cx,cy)
	local ox=(x-cx)/r
	local oy=(y-cy)/r

	return ox,oy
end

function perp(dx,dy)
	return -dy,dx
end

function moveoncircle(x,y,px,py,nx,ny)
	--todo: make this work?
	local normx,normy=circnorm(px,py,nx,ny)
	local perpx,perpy=perp(normx,normy)
	test=test.."perp: "..perpx..", "..perpy.."\n"
	test=test.."input: "..x..", "..y.."\n"
	local mov=x+(y*perpy)
	return mov*perpx*10,mov*perpy*10
end

function lerp(a,b,t)
	return a + (b-a)*t
end
