pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
function _init()
	board:init(8,8)
	ptr:init()
	unit:new(4,4,3,true,1)
end

function _update60()
	ptr:update()
end

function _draw()
	cls()
	board:draw()
	
	for u in all(units) do
		u:draw()
	end
	
	ptr:draw()
end
-->8
--board and cells

cell_size = 15

board = {
	numx = 8,
	numy = 8,
	
	cells = {},
	
	init=function(self, nx, ny)
		self.numx = nx
		self.numy = ny
		for y=1,ny do
			local row = {}
			add(self.cells, row)
			
			for x=1,nx do
				self:addcell(cell:new(x,y,nil))
			end
			
		end
	end,
	
	draw=function(self) 
		for row in all(self.cells) do
			for c in all(row) do
				c:draw()
			end
		end
	end,
	
	addcell=function(self,cell)
		--all cells added in rowwise order
		add(self.cells[cell.y],cell)
	end,
	
	atpos=function(self,x,y)
		if x<1 or x>self.numx or
			y<1 or y>self.numy then
			
			return nil
		end
		
		return self.cells[y][x].has
	end,
	
	toscreenpos=function(self,p)
		local x=p.x*cell_size
		local y=p.y*cell_size
		return x,y
	end,
}

cell = {
	x = 0,
	y = 0,
	
	has = nil,

	highlighted = nil,
	
	new=function(self, xx, yy, with)
		local o = {}
		setmetatable(o, self)
		self.__index = self
		
		o.x = xx
		o.y = yy
		o.has = with
		
		return o
	end,
	
	draw=function(self)
		--screen space coordinates
		drawbox(self.x,self.y,cell_size,7,1,highlighted)
	end,
}

pos = {
	--component for taking space on board
	x = 0,
	y = 0,
	collides = true,
	
	new=function(self,nx,ny,col)
		local o = {}
		setmetatable(o,self)
		self.__index = self
		
		o.x = nx
		o.y = ny
		o.collides = col
		
		return o
	end,
	
	move=function(self,nx,ny)
		local at=board:atpos(nx,ny)
		
		if at==nil and self.collides then
			self.x = max(1,
				min(board.numx,nx))
			self.y = max(1,
				min(board.numy,ny))
		end
	end,

	dist=function(self,pos)
		return dist(self.x,self.y,pos.x,pos.y)
	end,

	distto=function(self,x,y)
		return dist(self.x,self.y,x,y)
	end

}
-->8
--pointer & unit

ptr = {
	pos = nil,
	c = 10,
	
	init=function(self)
		local x = 1
		local y = board.numy
		self.pos=pos:new(x,y)
	end,
	
	update=function(self)
		local dx = 0
		local dy = 0
		
		if btnp(➡️) then
			dx+=1
		end
		if btnp(⬅️) then
			dx-=1
		end
		if btnp(⬆️) then
			dy-=1
		end
		if btnp(⬇️) then
			dy+=1
		end
		
		if dx!=0 or dy!=0 then
			dx+=self.x
			dy+=self.y
			self.pos:move(dx,dy)
		end
	end,

	draw=function(self)
		local p = self.pos
		print("x="..p.x.." y="..p.y,1,1,10)
		drawbox(p.x,p.y,cell_size,10,3)
	end,

}

units = {}
unit = {

	pos = nil,
	s = 0,

	ms = 3,
	
	new=function(self,x,y,ms,col,sp)
		local at=board:atpos(x,y)
		if col and at and at.collides then
			stop("cannot create unit where colliding unit already is")
		end
		
		local o = {}
		setmetatable(o,self)
		self.__index = self
		
		o.pos = pos:new(x,y,col)
		o.s = sp
		o.ms = ms
		
		add(units,o)
		return o
	end,
	
	draw=function(self)
		local x,y = board:toscreenpos(self.pos)
		sspr(8*(self.s%16),8*(flr(self.s/16)),
			8,8,x,y,cell_size,cell_size)
	end

	showmoves=function(self)
		--dfs, stop at ms
		--highlight each cell we touch

	end,

	move=function(self,x,y)
		if self.pos:distto(x,y)>self.ms then
			stop("this position is too far away")
		end

		self.pos:move(x,y)	
	end,
}

-->8
--helpers

function drawbox(x0,y0,width,
	c,stroke,fill)
	
	--board coords start at (1,1)
	--but screen space starts at
	--(0,0)--subract out cell_size
	--to compensate
	local xi = x0 * width - cell_size
	local yi = y0 * width - cell_size
	local xf = xi + width
	local yf = yi + width
	--todo:handle stroke
	if fill then
		--fill in cell 
		rectfill(xi,yi,xf,yf,fill)
	end
	--outline cell
	rect(xi,yi,xf,yf,c)
end

function dist(xi,yi,xf,yf)
	return abs(xf-xi)+abs(yf-yi)
end

stack={
	data={},
	length=0,
	
	new=function(self)
		local o = {}
		setmetatable(o,self)
		self.__index=self

		o.data={}
		o.length=0

		return o
	end,

	push=function(self,x)
		
	end,

	pop=function(self)

	end,
}

__gfx__
0000000000cccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000cccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700ccdccdcc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000ccdccdcc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000cccccccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700cccddccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000cccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000cccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
