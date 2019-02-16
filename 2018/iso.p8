pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
--isometric engine
--by marcus zaeyen

function _init()
	grid:init()
end

function _update60()

end

function _draw()
	cls()
	grid:draw()
end
-->8
--objects

grid = {
	map={},
	wx=5,wy=5,
	init = function(self)
		for i=1,self.wy do
			local row={}
			for j=1,self.wx do
				add(row,tile:new((j-1)*8,(i-1)*8))
			end
			add(self.map,row)
		end
	end,
	
	draw = function(self)
		for i=1,self.wy do
			for j=1,self.wx do
				self.map[i][j]:draw()
			end
		end
	end
}

tile = {
	c=1,
	x=0,y=0,
	new = function(self,x,y)
		local o = {}
		setmetatable(o,self)
		self.__index = self
		
		o.c=flr(rnd(16))
		o.x=x
		o.y=y
		
		return o
	end,
	
	draw = function(self)
		local tr=isofrom2d(self)
		rectfill(tr.x,tr.y,
			self.x+8,self.y+8,self.c)
	end
}
-->8
--helpers

function isoto2d(pt)
	local x = (2*pt.y + pt.x) / 2
	local y = (2*pt.y - pt.x) / 2
	local temp = tile:new(x,y)
	temp.c=pt.c
	
	return temp
end

function isofrom2d(pt)
	local x = pt.x - pt.y
	local y = (pt.x + pt.y) / 2
	local temp = tile:new(x,y)
	temp.c=pt.c
	
	return temp
end

function box(p1,p2,p3,p4)
	
end
