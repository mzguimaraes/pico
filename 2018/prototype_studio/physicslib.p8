pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
--mazeheaven
--by marcus zaeyen and josh melnick

function _init()
	--p = phys.body:new{x=64,y=64}
	g = phys.group:new(
		phys.body:new{x=64,y=64,
			col={x=-2,y=-2,w=4,h=4}})
	g:collideswith(g)
	--g:modify("gravity", false)
	for i=1,20 do
		g:clone{x=rnd(108)+16,
			y=rnd(108)+16,
			dx=rnd(4)-2,
			dy=rnd(4)-2}
	end
end

function _update60()
	phys:update()
end

function _draw()
	cls()
	for e in all(g.eles) do
		circfill(e.x,e.y,4,6)
	end
end
-->8
--physics

phys = {
	gravity = 0.25,
	bodies = {},
	
	body = {
		x=0,y=0,
		dx=0,dy=0,
		ddx=0,ddy=0,
		gravity=true,
		m=1,mu=0.05,
		col=nil,
		
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
					col={
						x=0, y=0,
						w=8, h=8,
						collist={}
					}
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
			
			colt=t[10] or t.col
			colt.parent=o
			o.col=phys.col:new(colt)
			
			add(phys.bodies,o)
			return o	
		end,
		
		update=function(self)
			--gravity
			if self.gravity then
				self:addforce(0,phys.gravity)
				--self.dy+=phys.gravity
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
		end,
		
		collideswith=function(self,
			other,cb)
			
			
		end
		
	},
	
	group = {
		eles = {},
		proto = nil, --prototype
		
		new = function(self,p)
			local o = {}
			setmetatable(o,self)
			self.__index=self
			
			o.eles = {}
			
			if p~=nil then
				o.proto = p
				add(o.eles,p)
			else
				o.proto = nil
			end
			
			return o
		end,
		
		modify=function(self,key,val)
			for e in all(self.eles) do
				if e[key] ~= nil then
					e[key] = val
				else
					stop(key.." does not exist on object")
				end
			end
		end,
		
		clone=function(self, t)
			if self.proto ==nil then
				stop("no prototype assigned")
			end

			local params={}
			
			for k,v in pairs(self.proto) do
				--if t has value for proto
				--field, use
				--else use proto field value
				
				if t[k]==nil then
					params[k] = v
				else
					params[k] = t[k]
				end
			end
			
			local new = self.proto:new(params)
			add(self.eles, new)
			return new
		end,
		
		collideswith=function(self,
			other,cb)
			
			if other.eles==nil then
				--not a group
				for e in all(self.eles) do
					e:collideswith(other,cb)
				end
			else
				for e in all(self.eles) do
					for o in all(other.eles) do 
						e:collideswith(o,cb)
					end
				end
			end
		end
	},
	
	cols = {},
	
	col = { --collider
		x=0, y=0, --upper left corner
		w=8, h=8, --width/height
		collist={}, --collides with
		parent=nil, --body attached to
		
		new = function(self,t)
			setmetatable(t, {
				__index={
					x=0,y=0,w=8,h=8,
					colllist={},
					parent=nil
				}
			})
			
			local o = {}
			setmetatable(o,self)
			self.__index=self
			
			o.x=t[1] or t.x
			o.y=t[2] or t.y
			o.w=t[3] or t.w
			o.h=t[4] or t.h
			o.collist=t[5] or t.collist
			o.parent=t[6] or t.parent
			
			if o.parent==nil then
				stop("must assign parent to collider")
			end
			
			add(phys.cols,o)
			return o
		end,
		
		update = function(self)
			for c in self.collist do
				if self:overlaps(c.col) then
					c.cb(self,c.col)
				end
			end
		end,
		
		overlaps=function(self,other)
			return overlapping(
				self.x,self.y,self.w,self.h,
				other.x,other.y,other.w,other.h
			)
		end,
		
		collideswith=function(self,
			other,cb)
			
			if cb==nil then
				cb=reflect
			end
			
			add(self.collist, {
				col=other,cb=cb
			})
		end,
		
		getbounds=function(self)
			local lx=self.parent.x+self.x
			local rx=lx+self.w
			local uy=self.parent.y+self.y
			local dy=uy+self.h
			
			return {
				nw={lx,uy},
				ne={rx,uy},
				sw={lx,dy},
				se={rx,dy}
			}
		end
	},

	update = function(self)
		for b in all(self.bodies) do
			b:update()
		end
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

function dot(ax,ay,bx,by)
	return ax*bx + ay*by
end

function reflect(dx,dy,normx,normy)
	local dotprod=dot(dx,dy,normx,normy)
	local x=dx-2*normx*dotprod
	local y=dy-2*normy*dotprod
	return x,y
end

function reflcols(r,other)
	local nx,ny=colnorm(
		r.parent.x,
		r.parent.y,
		other
	)
	
	local rdx,rdy=reflect(
		r.parent.dx,r.parent.dy,
		nx,ny)
	
	r.parent.dx=rdx
	r.parent.dy=rdy
	return rdx,rdy
end

function colnorm(x,y,col)
	local rx,ry
	
	if x>=col.parent.x then
		rx=1
	else
		rx=-1
	end
	
	if y>=col.parent.y then
		ry=1
	else
		ry=-1
	end
	
	return rx,ry
end
-->8
--objects


