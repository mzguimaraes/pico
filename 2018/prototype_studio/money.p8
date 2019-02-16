pico-8 cartridge // http://www.pico-8.com
version 16
__lua__


drawlist = {}
updatelist = {}

function drawadd(o,prio)
	if prio==nil then
		prio=0
	end
	o.dprio=prio
	add(drawlist,o)
end

function _init()
	menu:new{options={
		{name="dance", cb=function() test=test.."dancing!" end},
		ops.new{
			ops.exit	
		},
		ops.exit
	}}
end

function _update60()
	for o in all(updatelist) do
		o:update()
	end
	
	menumgr:update()
end

test=""

function _draw()
	cls(12)
	for o in all(drawlist) do
		o:draw()
	end
	if #menumgr.menus>0 then
		ptr:draw()
	end
	
	print(test,0,0,7)
	test=""
	
end

-->8
--objects

menu = {
	x=0,y=96,w=128,h=32,
	options={}, isel=1,
	
	new = function(self,t,prio)
	
		setmetatable(t,
			{__index={
				x=1,y=96,w=125,h=31,
				options={}
			}
		})
		
		local o = {}
		setmetatable(o,self)
		self.__index = self
		
		o.x=t[1] or t.x
		o.y=t[2] or t.y
		o.w=t[3] or t.w
		o.h=t[4] or t.h
		o.options=t[5] or t.options
		
		
		drawadd(o,prio)
		--add(updatelist,o)
		add(menumgr.menus,o)
		return o
	end,
	
	moveup=function(self)
		self.isel=max(self.isel-1,1)
	end,
	
	movedown=function(self)
		self.isel=min(self.isel+1,
			#self.options)
	end,
	
	draw=function(self)
		rectfill(self.x,self.y,
			self.x+self.w,self.y+self.h,
			6)
		rect(self.x,self.y,
			self.x+self.w,self.y+self.h,
			5)
		
		local y = self.y+6
		for o in all(self.options) do
			print(o.name,self.x+8,y,0)
			y+=8
		end
	end,
	
	getptrloc=function(self)
		local x = self.x+4
		local y = self.y+8+(8*(self.isel-1))
		return x,y
	end,
	
	select=function(self)
		if #self.options<1 then
			return
		end
		self.options[self.isel].cb()
	end,
	del=function(self)
		del(drawlist,self)
		del(menumgr.menus,self)
	end
}

menumgr = {
	menus={},
	
	update=function(self)
		if #self.menus > 0 then
		
			if btnp(⬆️) then
				--test=test.."moveup\n"
				self:getactive():
					moveup()
				--test=test..self.menus[#self.menus].isel.."\n"
			elseif btnp(⬇️) then
				--test=test.."movedown\n"
				self:getactive():
					movedown()
				--test=test..self.menus[#self.menus].isel.."\n"
			end
			
			if btnp(❎) then
				self:getactive():select()
			end
		end
	end,
	
	getactive=function(self)
		return self.menus[#self.menus]
	end
}

ptr = {
	x=0,y=0,
	verts={
		tip={2,0},
		top={-2,-2},
		mid={-1,0},
		bot={-2,2}
	},
	
	draw=function(self)
		self.x,self.y=
			menumgr:getactive():getptrloc()
		--test=test..self.x.." "..self.y.."\n"	
		local tverts={}
		for k,v in pairs(self.verts) do
			tverts[k]=v
			--tverts[k]=rotvert(tverts[k],self.theta)
			tverts[k]=vert2xy(tverts[k],self)
		end
		
		vertline(tverts.tip,tverts.top,2)
		vertline(tverts.top,tverts.mid,2)
		vertline(tverts.mid,tverts.bot,2)
		vertline(tverts.bot,tverts.tip,2)
	end,
}
-->8
--helpers

function vertline(v1,v2,c)
	line(v1[1],v1[2],v2[1],v2[2],c)
end

function rotvert(v,t)
	local x=v[1]*cos(t)-v[2]*sin(t)
	local y=v[1]*sin(t)+v[2]*cos(t)
	return {x,y}
end

function vert2xy(v,c)
	local x=c.x+v[1]
	local y=c.y+v[2]
	
	return {x,y}
end
-->8
--option defs

ops = {
	exit = {
		name="exit",
		cb=function() 
			menumgr:getactive():del()
		end
	},
	new=function(newops)
		return {
			name="new",
			cb=function()
				menu:new{
					options=newops
				}
			end
		}
	end
}
