pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
--pietas
--by marcus zaeyen

function _init()
	field:init()
	maze:init()
	crsr.active=true
end

ticktimer=0
ticktime=30

function _update60()
	--editing
	if crsr.active then
		crsr:input()
	else
		ticktimer+=1
		if ticktimer==ticktime then
			ticktimer=0
			interp:tick()
		end
	end
	
	if btnp(❎) then
		crsr.active=not crsr.active
		interp.x=0
		interp.y=0
		interp.facing=1
	end
end

test=""
function _draw()
	cls(5)
	field:draw()
	if crsr.active then
		crsr:draw()
	else
		interp:draw()
	end
	maze:draw()
	runner:draw()
	
	print("at least it runs",0,120)
	
	--print(test,0,0)
	--test=""
end
-->8
--interpreter and ide

crsr={
	x=0,
	y=0,
	active=false,
	c=9,
	input=function(self)
		--movement
		if not self.active then return end
	
		if btnp(⬅️) and self.x>0 then
			self.x-=1
		end
		if btnp(➡️) and self.x<field.xnum-1 then
			self.x+=1
		end
		if btnp(⬆️) and self.y>0 then
			self.y-=1
		end
		if btnp(⬇️) and self.y<field.ynum-1 then
			self.y+=1
		end
		
	--	color cycling
		if btnp(⬆️,1) then
			local at=field.getcellat(self.x,self.y)
			at:cyclecolor(1)
		end
		if btnp(⬇️,1) then
			local at=field.getcellat(self.x,self.y)
			at:cyclecolor(-1)
		end
	end,
	
	draw=function(self)
		local xs,ys=
			field.indextoscreen(self.x,self.y)
		rect(xs-1,ys-1,
			xs+field.d,ys+field.d,
			self.c)
		
		--test
		--local at=field.getcellat(self.x,self.y)
		--print(at.c,0,0,7)
	end
}

cell={
	x=0,y=0,c=0,
	numcolors=4,
	
	new=function(self,x,y,c)
		o={}
		setmetatable(o,self)
		self.__index=self
		
		o.x=x
		o.y=y
		o.c=c
		
		return o
	end,
	
	draw=function(self)
		local xscreen=
			field.xstart+(field.d*self.x)
		local yscreen=
			field.ystart+(field.d*self.y)
		rectfill(xscreen,yscreen,
			xscreen+field.d,yscreen+field.d,
			self.c)	
	end,
	
	cyclecolor=function(self,n)
		self.c+=n
		while self.c<0 do
			self.c+=self.numcolors
		end
		self.c=self.c%self.numcolors
	end
}

field={
	d=4, --pixels/codel side
	xnum=16,ynum=16,
	xstart=62,ystart=32,
	cells={},
	
	init=function(self)
		for i=1,self.xnum do
			for j=1,self.ynum do
				local ncell=cell:new(
						j-1,i-1,0)
				add(self.cells,ncell)
			end
		end
	end,
	
	draw=function(self)
		rectfill(
			self.xstart-1,self.ystart-1,
			self.xstart+self.d*self.xnum+1,
			self.ystart+self.d*self.ynum+1,
			6
		)
		for c in all(self.cells) do
			c:draw()
		end
	end,
	
	indextoscreen=function(x,y)
		local xs=field.xstart+field.d*x
		local ys=field.ystart+field.d*y
		return xs,ys
	end,
	
	getcellat=function(x,y)
		local i=1+(y*field.xnum)+x
		return field.cells[i]
	end,
	
	colorat=function(x,y)
		return field.getcellat(x,y).c
	end,
	
	getblocksizeat=function(x,y)
		if field.colorat(x,y)==0 then
			return
		end
		return blocksize_recurse(x,y)
	end
}

function blocksize_recurse(x,y)
	local at=field.getcellat(x,y)
	if at.seen then
	 return 0
	end
	
	at.seen=true
	--at.c=7
	
	local count=1
	
	if x>0 and 
		field.colorat(x-1,y)==
		field.colorat(x,y) then
		
		count+=blocksize_recurse(x-1,y)
	end
	if x<field.xnum and 
		field.colorat(x+1,y)==
		field.colorat(x,y) then
		
		count+=blocksize_recurse(x+1,y)
	end
	if y>0 and 
		field.colorat(x,y-1)==
		field.colorat(x,y) then
		
		count+=blocksize_recurse(x,y-1)
	end
	if y<field.ynum and 
		field.colorat(x,y+1)==
		field.colorat(x,y) then
		
		count+=blocksize_recurse(x,y+1)
	end
	
	return count
end

interp={
	x=0,y=0,
	--0=n,1=e,2=s,3=w
	facing=1,
	
	tick=function(self)
		local currcolor=
			field.colorat(self.x,self.y)
	
		local dx=0
		local dy=0
		
		if self.facing==0 then
			if self.y>0 then
				dy-=1
			else
				self:rotate(1)
				return
			end
		elseif self.facing==1 then
			if self.x<field.xnum then
			dx+=1
			else
				self:rotate(1)
				return
			end
		elseif self.facing==2 then
			if self.y<field.ynum then
				dy+=1
			else
				self:rotate(1)
				return
			end
		elseif self.facing==3 then
			if self.x<0 then
				dx-=1
			else
				self:rotate(1)
				return
			end
		end
		
		local newcol=field.
			colorat(self.x+dx,self.y+dy)
		
		if newcol==0 then
			self:rotate(1)
			return
		end
		
		local dc=newcol-currcolor
		local blocksize=
			field.getblocksizeat(
				self.x+dx,self.y+dy)
		
		self.x+=dx
		self.y+=dy
		
		if dc==-2 then
			test=test.."rotateleft "..blocksize
			runner:rotateleft(blocksize)
		elseif dc==-1 then
			test=test.."rotateright "..blocksize
			runner:rotateright(blocksize)
		elseif dc==1 then
			test=test.."rotate "..blocksize
			self:rotate(blocksize)
		elseif dc==2 then
			test=test.."forward "..blocksize
			runner:forward(blocksize)
		end
		
	end,
	
	rotate=function(self,n)
		self.facing=(self.facing+n)%4
	end,
	
	draw=function(self)
		local xs,ys=field.indextoscreen(self.x,self.y)
		if self.facing==0 then
			spr(18,xs,ys)
		elseif self.facing==1 then
			spr(17,xs,ys)
		elseif self.facing==2 then
			spr(18,xs,ys,1,1,false,true)
		else
			spr(17,xs,ys,1,1,true)
		end
	end
}
-->8
--maze
maze = {
	xmin=1,ymin=32,
	xnum=7,ynum=8,
	d=8,
	cells={},
	walls={},
	
	init=function(self)
		--todo
		self.cells=createcells(self.xnum,self.ynum)
		
		--create maze
		self.cells[5].clear=true
		self.cells[6].clear=true
		self.cells[12].clear=true
		self.cells[16].clear=true
		self.cells[17].clear=true
		self.cells[18].clear=true
		self.cells[19].clear=true
		self.cells[23].clear=true
		self.cells[30].clear=true
		self.cells[37].clear=true
		self.cells[38].clear=true
		self.cells[45].clear=true
		self.cells[49].clear=true
		self.cells[50].clear=true
		self.cells[51].clear=true
		self.cells[52].clear=true
	end,
	
	draw=function(self)
		--todo
		rect(self.xmin-1,self.ymin-1,
			self.xmin+self.d*self.xnum,
			self.ymin+self.d*self.ynum,
			6)
		
		for c in all(self.cells) do
			if not c.clear then
				local x,y=maze.indextoscreen(c.x,c.y)
				spr(5,x,y)
			end
		end
			
		for e in all(self.walls) do
			local s=e[1]
			local f=e[2]
			local x,y=maze.indextoscreen(f.x,f.y)
			--pal(6,flr(rnd(16)))
			if s.x~=f.x then
				--vertical wall				
				spr(4,x,y)
			elseif s.y~=f.y then
				--horiz wall
				spr(3,x,y)
			else
				stop("invalid edge\n"..s[1]..s[2]..f[1]..f[2])
			end
			--pal(6,6)
		end
	end,
	
	indextoscreen=function(x,y)
		local xs=maze.xmin+maze.d*x
		local ys=maze.ymin+maze.d*y
		return xs,ys
	end,
	
	xytoindex=function(x,y)
		return y*maze.xnum+x
	end,
	
	isvalidmove=function(xi,yi,xf,yf)
		
	end
}

mazecell={
	x=0,y=0,clear=false,
	new=function(self,x,y)
		o={}
		setmetatable(o,self)
		self.__index=self
		
		o.x=x
		o.y=y
		
		return o
	end
}

runner = {
	x=0,y=maze.ynum-1,
	--0=n,1=e,2=s,3=w
	facing=1,
	running=false,
	c=8,
	
	forward=function(self,n)
		local propx=self.x
		local propy=self.y
	
		if self.facing==0 then
			propy-=n
		elseif self.facing==1 then
			propx+=n
		elseif self.facing==2 then
			propy+=n
		else
			propx-=n
		end
		
		local propcell=
			maze.xytoindex(propx,propy)
		
		if not propcell then	return false end
	
		--walk to propcell
		local atx=self.x
		local aty=self.y
		
		while not(atx==propx and
		 aty==propy) do
		
			if self.facing==0 then
				aty-=1
			elseif self.facing==1 then
				atx+=1
			elseif self.facing==2 then
				aty+=1
			else
				atx-=1
			end
		
			if not maze.cells[
				maze.xytoindex(atx,aty)
				].clear then
		
				return false
			end
			
		end
		
		self.x=propx
		self.y=propy
		return true
	end,
	
	rotateleft=function(self,n)
		self.facing-=n
		while self.facing<0 do
			self.facing+=4
		end
	end,
	
	rotateright=function(self,n)
		self.facing=(self.facing+n)%4
	end,
	
	draw=function(self)
		local xs,ys=
			maze.indextoscreen(self.x,self.y)
		if self.facing==0 then
			spr(2,xs,ys)
		elseif self.facing==1 then
			spr(1,xs,ys)
		elseif self.facing==2 then
			spr(2,xs,ys,1,1,false,true)
		else
			spr(1,xs,ys,1,1,true)
		end
	end
}
-->8
--helper functions

-- function kruskalmazegen(nx,ny)
-- 	--x,y=dimensions of maze
	
-- 	--make cell list
-- 	maze.cells=createcells(nx,ny)
	
-- 	--create list of all walls
-- 	maze.walls={}
-- 		--make horiz walls
-- 		for i=0,ny-2 do
-- 			for j=0,nx-1 do
-- 				local is=maze.xytoindex(j,i)
-- 				local ie=maze.xytoindex(j,i+1)
-- 				add(walls,cells[is],
-- 					cells[ie])
-- 			end
-- 		end
-- 		--make vert walls
-- 		for i=0,nx-2 do
-- 			for j=0,ny-1 do
-- 				local is=maze.xytoindex(i,j)
-- 				local ie=maze.xytoindex(i+1,j)
-- 				add(walls,cells[is],
-- 					cells[ie])
-- 			end
-- 		end
-- 	--make sets
	
	
-- 	return cells,walls
-- end

function createcells(dx,dy)
	cells={}
	for j=0,dy-1 do
		for i=0,dx-1 do
			add(cells,mazecell:new(i,j))
		end
	end
	return cells
end

function deepcopy(obj)
  if type(obj) ~= 'table' then return obj end
  local res = {}
  for k, v in pairs(obj) do res[copy1(k)] = copy1(v) end
  return res
end
__gfx__
00000000000000000000000066666666660000006666666600000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000008800066666666660000006666666600000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700008800000008800000000000660000006666666600000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000008800008888888800000000660000006666666600000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000008888008888888800000000660000006666666600000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700008888000000000000000000660000006666666600000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000008800000000000000000000660000006666666600000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000008800000000000000000000660000006666666600000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000888800008778000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000888700008888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000888700008888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000888800008888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
66666666666666666666666666666666666666666666666666666666665556666666666666666666666666666666666666666666666666666666666666666666
66666666666666666666666666666666655555555555555556666666665556222211111111111133330000000000000000000000000000000000000000000006
66666666666666666666666666666666655555555555555556666666665556222211111111111133330000000000000000000000000000000000000000000006
66666666666666666666666666666666655555555555555556666666665556222211111111111133330000000000000000000000000000000000000000000006
66666666666666666666666666666666655555555555555556666666665556222211111111111133330000000000000000000000000000000000000000000006
66666666666666666666666666666666655555555555555556666666665556000033333333111133330000000000000000000000000000000000000000000006
66666666666666666666666666666666655555555555555556666666665556000033333333111133330000000000000000000000000000000000000000000006
66666666666666666666666666666666655555555555555556666666665556000033333333111133330000000000000000000000000000000000000000000006
66666666666666666666666666666666655555555555555556666666665556000033333333111133330000000000000000000000000000000000000000000006
66666666666666666666666666666666655555555666666666666666665556333333333333222233333333333300000000000000000000000000000000000006
66666666666666666666666666666666655555555666666666666666665556333333333333222233333333333300000000000000000000000000000000000006
66666666666666666666666666666666655555555666666666666666665556333333333333222233333333333300000000000000000000000000000000000006
66666666666666666666666666666666655555555666666666666666665556333333333333222233333333333300000000000000000000000000000000000006
66666666666666666666666666666666655555555666666666666666665556000033331111222222222222333300000000000000000000000000000000000006
66666666666666666666666666666666655555555666666666666666665556000033331111222222222222333300000000000000000000000000000000000006
66666666666666666666666666666666655555555666666666666666665556000033331111222222222222333300000000000000000000000000000000000006
66666666666666666666666666666666655555555666666666666666665556000033331111222222222222333300000000000000000000000000000000000006
66666666655555555555555555555555555555555666666666666666665556000033331111111111112222333300000000000000000000000000000000000006
66666666655555555555555555555555555555555666666666666666665556000033331111111111112222333300000000000000000000000000000000000006
66666666655555555555555555555555555555555666666666666666665556000033331111111111112222333300000000000000000000000000000000000006
66666666655555555555555555555555555555555666666666666666665556000033331111111111112222333300000000000000000000000000000000000006
66666666655555555555555555555555555555555666666666666666665556000033333333333311112222333300000000000000000000000000000000000006
66666666655555555555555555555555555555555666666666666666665556000033333333333311112222333300000000000000000000000000000000000006
66666666655555555555555555555555555555555666666666666666665556000033333333333311112222333300000000000000000000000000000000000006
66666666655555555555555555555555555555555666666666666666665556000033333333333311112222333300000000000000000000000000000000000006
66666666655555555666666666666666666666666666666666666666665556333311111111111111112222333300000000000000000000000000000000000006
66666666655555555666666666666666666666666666666666666666665556333311111111111111112222333300000000000000000000000000000000000006
66666666655555555666666666666666666666666666666666666666665556333311111111111111112222333300000000000000000000000000000000000006
66666666655555555666666666666666666666666666666666666666665556333311111111111111112222333300000000000000000000000000000000000006
66666666655555555666666666666666666666666666666666666666665556333322222222222222222222333300000000000000000000000000000000000006
66666666655555555666666666666666666666666666666666666666665556333322222222222222222222333300000000000000000000000000000000000006
66666666655555555666666666666666666666666666666666666666665556333322222222222222222222333300000000000000000000000000000000000006
66666666655555555666666666666666666666666666666666666666665556333322222222222222222222333300000000000000000000000000000000000006
66666666655555555666666666666666666666666666666666666666665556333333333333333333333333333300000000000000000000000000000000000006
66666666655555555666666666666666666666666666666666666666665556333333333333333333333333333300000000000000000000000000000000000006
66666666655555555666666666666666666666666666666666666666665556333333333333333333333333333300000000000000000000000000000000000006
66666666655555555666666666666666666666666666666666666666665556333333333333333333333333333300000000000000000000000000000000000006
66666666655555555666666666666666666666666666666666666666665556222211111111111111111111000000000000000000000000000000000000000006
66666666655555555666666666666666666666666666666666666666665556222211111111111111111111000000000000000000000000000000000000000006
66666666655555555666666666666666666666666666666666666666665556222211111111111111111111000000000000000000000000000000000000000006
66666666655555555666666666666666666666666666666666666666665556222211111111111111111111000000000000000000000000000000000000000006
66666666655555555555555556666666666666666666666666666666665556222233333333333333331111000000000000000000000000000000000000000006
66666666655555555555555556666666666666666666666666666666665556222233333333333333331111000000000000000000000000000000000000000006
66666666655555555555555556666666666666666666666666666666665556222233333333333333331111000000000000000000000000000000000000000006
66666666655555555555555556666666666666666666666666666666665556222233333333333333331111000000000000000000000000000000000000000006
66666666655555555555555556666666666666666666666666666666665556222222222222222233331111000000000000000000000000000000000000000006
66666666655555555555555556666666666666666666666666666666665556222222222222222233331111000000000000000000000000000000000000000006
66666666655555555555555556666666666666666666666666666666665556222222222222222233331111000000000000000000000000000000000000000006
66666666655555555555555556666666666666666666666666666666665556222222222222222233331111000000000000000000000000000000000000000006
66666666666666666555555556666666666666666666666665555555565556000033333333333333331111000000000000000000000000000000000000000006
66666666666666666555555556666666666666666666666665555555565556000033333333333333331111000000000000000000000000000000000000000006
66666666666666666555555556666666666666666666666665555555565556000033333333333333331111000000000000000000000000000000000000000006
66666666666666666555555556666666666666666666666665555555565556000033333333333333331111000000000000000000000000000000000000000006
66666666666666666555555556666666666666666666666665555555565556000033333333111111111111000000000000000000000000000000000000000006
66666666666666666555555556666666666666666666666665555555565556000033333333111111111111000000000000000000000000000000000000000006
66666666666666666555555556666666666666666666666665555555565556000033333333111111111111000000000000000000000000000000000000000006
66666666666666666555555556666666666666666666666665555555565556000033333333111111111111000999999000000000000000000000000000000006
65555555555555555555555556666666666666666666666666666666665556000000003333333333333333000900009000000000000000000000000000000006
65555555555555555555555556666666666666666666666666666666665556000000003333333333333333000900009000000000000000000000000000000006
65588555555555555555555556666666666666666666666666666666665556000000003333333333333333000900009000000000000000000000000000000006
65588555555555555555555556666666666666666666666666666666665556000000003333333333333333000900009000000000000000000000000000000006
65588885555555555555555556666666666666666666666666666666665556000000000000000000000000000999999000000000000000000000000000000006
65588885555555555555555556666666666666666666666666666666665556000000000000000000000000000000000000000000000000000000000000000006
65588555555555555555555556666666666666666666666666666666665556000000000000000000000000000000000000000000000000000000000000000006
65588555555555555555555556666666666666666666666666666666665556000000000000000000000000000000000000000000000000000000000000000006
66666666666666666666666666666666666666666666666666666666665556000000000000000000000000000000000000000000000000000000000000000006
55555555555555555555555555555555555555555555555555555555555556666666666666666666666666666666666666666666666666666666666666666666
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
66656665555565556665666556656665555566656665555566656565665556655555555555555555555555555555555555555555555555555555555555555555
65655655555565556555656565555655555556555655555565656565656565555555555555555555555555555555555555555555555555555555555555555555
66655655555565556655666566655655555556555655555566556565656566655555555555555555555555555555555555555555555555555555555555555555
65655655555565556555656555655655555556555655555565656565656555655555555555555555555555555555555555555555555555555555555555555555
65655655555566656665656566555655555566655655555565655665656566555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555

