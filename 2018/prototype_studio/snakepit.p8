pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
--snake pit--
--cloned by marcus zaeyen--
--by mike singleton--

--all the sprites in game are
--not transparent
palt(0,false)

player={f=0,x=0,y=0,
dx=0,dy=0,alive=true,t="player"}
player.draw = function(self)
	if not player.alive then return end
	local x,y=board2screenpos(self.x,self.y)
	if player.f%2==1 then
		spr(1,x,y)
	else
		spr(2,x,y)
	end
end

--create snakes
snakes={}

score=0--player score
highscore=0
--refresh/60 = refresh rate in hz
refresh=16

--establish grid
--will hold whatever obj is there
--could be snake, fruit, player
--1d array: use util funcs on tab1
board={}

function _init() 
	music(0)
	for i=1,boardx do
		board[i]={}
		for j=1,boardy do
			board[i][j]=nil
		end
	end

	initboard()
	
	snakes={}
	makesnake(2,2,8)
	makesnake(8,2,7)
	makesnake(14,2,12)
	makesnake(2,11,3)
	makesnake(8,11,1)

	score=0
	player.alive=true
	player.x=boardx-2
	player.y=boardy-4
	--board[board2int(boardx-2,boardy-2)]=player
	board[player.x][player.y]=player
end

--for player
function tick()
	if player.alive then
		player.f+=1
		--move player
		if (player.dx~=0 
			or player.dy~=0) then
			--stop("player moving"..player.f,0,120,7)
			moveplayer()
		end
	elseif btn(❎) then
		highscore=max(score,highscore)
		_init()
	end
end

function snaketick()
	for s in all(snakes) do
		s.f+=1
		s:move()
	end
end

timer = 0
function _update60()
	timer+=1
	if timer==refresh then
		timer=0
		tick()
	elseif timer==refresh/2 then
		snaketick()
	end
	
	--player input
	if btn(⬅️) and player.dx==0 
		and player.dy==0 then
		player.dx = -1
	elseif btn(➡️) and player.dx==0 
		and player.dy==0 then
		player.dx = 1
	elseif btn(⬆️) and player.dx==0 
		and player.dy==0 then
		player.dy = -1
	elseif btn(⬇️) and player.dx==0 
		and player.dy==0 then
		player.dy = 1
	end
end

function drawscore(score, x)
	local ppscore = tostr(score)
	local scorelen=#ppscore
	for i=1,(6-scorelen) do
		ppscore="0"..ppscore
	end
	print(ppscore,x,2)
	return ppscore
end

function _draw()
	cls()
	--draw board contents
	for i in all(board) do
		for k,v in pairs(i) do
			if v~=nil then
				v:draw()
				--stop(v.t..k,64,64)
			end
		end
	end
	
	--draw red top bar
	for x=0,128,8 do
		spr(16,x,0)
	end
	--print score and high score
	drawscore(score,1)
	drawscore(highscore,103)
end

function drawsnake(self)
	pal(8,self.c)
	--draw tail in reverse order
	--for i=#self.tail,1,-1 do
	--	drawtailbit(self.tail,i)
	--end
	
	local drx,dry = board2screenpos(self.x,self.y)
	local flipx, flipy
	local s=4
	
	if self.facing==0 then
		flipx=false flipy=false
	elseif self.facing==1 then
		s=20 flipx=false flipy=false
	elseif self.facing==2 then
		flipx=true flipy=false
	else
		s=20 flipx=false flipy=true
	end
	if self.f%3==0 then
		spr(s+1,drx,dry,1,1,flipx,flipy)
	else
		spr(s,drx,dry,1,1,flipx,flipy)
	end
	
	pal()
end

function drawtailbit(self)
	pal(8,self.snake.c)
	local x,y=board2screenpos(self.x,self.y)
	spr(36,x,y)
	pal(8,8)
 --todo
	-- pal(8,self.snake.c)
	-- local arrtail=self.snake.tail
	-- local x,y=board2screenpos(
	-- 	arrtail[self.i].x,
	-- 	arrtail[self.i].y)
	-- --choose correct sprite+orient
	-- local s
	-- local flipx=false
	-- local flipy=false
	-- local i=self.i
	-- if self.i==#self.snake.tail then
	-- 	--tail end
	-- 	if self.x==self.snake.tail[19].x then
	-- 		s=24
	-- 		if self.y<self.snake.tail[19].y then
	-- 			flipy=true
	-- 		end
	-- 	else
	-- 		s=8
	-- 		if self.x>self.snake.tail[19].x then
	-- 			flipx=true
	-- 		end
	-- 	end
	-- elseif i==1 then
	-- 	--front of tail
	-- 	if self.snake.y==self.snake.tail[2].y 
	-- 	and self.snake.x==self.snake.tail[2].x then
			
	-- 	end
	-- elseif self.snake.tail[i-1].y
	-- 	==self.snake.tail[i+1].y and
	-- 	self.snake.tail[i-1].x
	-- 	==self.snake.tail[i+1].x then
	-- 	s=23 
	-- elseif self.snake.tail[i-1].y
	-- 	==self.snake.tail[i+1].y then
	-- 	s=6
	-- elseif self.snake.tail[i-1].x
	-- 	==self.snake.tail[i+1].x then
	-- 	s=22
	-- else
	-- 	s=7
	-- end
	-- spr(s,x,y,1,1,flipx,flipy)
	-- pal(8,8)
end
-->8
--board utility functions--

--snake pit is 22x22, but 
--pico8 can't fit that all on
--one screen ¯\_(�⬇️░)_/¯
boardx = 16
boardy = 15

--x,y 1 indexed to match with
--lua's silliness

function board2screenpos(x,y)
	return (x-1)*8,y*8
end

function initboard()
	for i=1,boardx do
		for j=1,boardy do
			fruit = {}
			fruit.x=i
			fruit.y=j
			fruit.t="fruit"
			fruit.draw = function(self)
				local x,y=board2screenpos(self.x,self.y)
				spr(3,x,y)
			end
			--add(board, fruit)
			board[i][j]=fruit
		end
	end
	--create snake holes
	makesnakehole(2,2)
	makesnakehole(boardx-2,2)
	makesnakehole(8,2)
	makesnakehole(2,boardy-4)
	makesnakehole(8,boardy-4)
end

--creates a 2x3 hole with
--top left corner (x,y)
function makesnakehole(x,y)
	for i=0,1 do
		for j=0,2 do
			board[x+i][y+j]=nil
		end
	end
end

function isvalid(p,x,y)
		if x>boardx or x<1 or
		y>boardy or y<1 then
		--stop("oob", 60,120,7)
		return false
	end
	
	if board[x][y]==nil then 
		return true
	end
	
	if p==player then
		return _pisvalid(x,y)
	elseif p.t=="snake" then
		return _snakeisvalid(p,x,y)
	else
		stop("invalid mover "..p, 60,120,7)
	end
end

function _snakeisvalid(p,x,y)
	local occ = board[x][y]
	if occ.t=="tail" then
		if occ.c==p.c then
			return true
		else
			return false
		end
	end
	
	--red snake can move anywhere
	if p.c==8 then return true end
	
	if occ.t=="player" then
		return true
	end
	return false --fruit
end

function _pisvalid(x,y)	
	local occ = board[x][y]
	if occ.t=="tail" then
		--stop("tail",60,120,7)
		return false 
	end
	return true
end

--facing:e,s,w,n=0,1,2,3
function makesnake(x,y,c)
	newsnake={
 	x=x, y=y, t="snake",
 	f=flr(rnd(3)),
		tail={},
		draw=drawsnake,
		move=snakemove,
		c=c,
		facing=0
	}
	--build tail
	for i=1,20 do
		tail={
			x=newsnake.x,
			y=newsnake.y,
			t="tail",
			draw=drawtailbit,
			snake=newsnake,
			i=i
		}
		add(newsnake.tail,tail)
	end
	board[x][y]=newsnake
	add(snakes,newsnake)
	return newsnake
end

-->8
--movement functions--

function moveplayer()
	--1. store current pos
	local oldx = player.x
	local oldy = player.y
	
	--2. check new pos valid
	local x=player.x+player.dx
	local y=player.y+player.dy
	player.dx=0 
	player.dy=0
	if not isvalid(player,x,y) then
		--stop("not valid", 60,120,7)
		return
	end
	--3. remove fruit/eat player
	local occ=board[x][y]
	if occ~=nil then
		if occ.t=="fruit" then
			board[x][y]=nil
			score+=10
			sfx(00)
		elseif occ.t=="snake" then
			player.alive=false
			return
		end
	end
	--4. update board entries
	player.x=x
	player.y=y
	board[x][y]=player
	board[oldx][oldy]=nil
	
	--stop(player.dx..player.dy, 64,64)
end

--notes on snake movement:
--pick target randomly (l,f,r)
	--weighted towards f
--if target taken by other snake
	--(or fruit if not red)
	--pick again (b if no other valid)
--move there
--eat player(fruit if red)
function snakemove(snake)
	--store old pos
	local oldx=snake.x
	local oldy=snake.y
	--pick target square
	
	--enum-y thing
	local f,r,b,l=0,1,2,3
	local target
	--get all valid squares
	--pick one at random (bias towards f)
	--if l,f,r invalid, use b
	local potentials={}
	
	if isvalid(snake,adjrelsnake(snake,f)) then
		add(potentials,f)
	end
	if isvalid(snake,adjrelsnake(snake,l)) then
		add(potentials,l)
	end
	if isvalid(snake,adjrelsnake(snake,r)) then
		add(potentials,r)
	end

	if #potentials==0 then
		add(potentials,b)
	end
	
	--bias towards f
	--not effecient code but idgaf
	if isvalid(snake,adjrelsnake(snake,f))
		and rnd()>.5 then
		target=f
	else
		target=potentials[flr(rnd(#potentials))+1]
	end

	--update tail bits
	local oldendx=snake.tail[#snake.tail].x
	local oldendy=snake.tail[#snake.tail].y
	for i=#snake.tail,2,-1 do
		snake.tail[i].x=snake.tail[i-1].x
		snake.tail[i].y=snake.tail[i-1].y
		board[snake.tail[i].x][snake.tail[i].y]=snake.tail[i]		
	end
	snake.tail[1].x=oldx
	snake.tail[1].y=oldy
	board[oldx][oldy]=snake.tail[1]
	board[oldendx][oldendy]=nil

	--move to target
	--clear target space if taken
	local newx,newy=adjrelsnake(snake,target)
	snakeeat(snake,newx,newy)
	snake.x=newx
	snake.y=newy
	snake.facing+=target
	snake.facing=snake.facing%4
	board[newx][newy]=snake
	--board[oldx][oldy]=snake.tail[1]		

end

function snakeeat(snake,x,y)
	local occ=board[x][y]
	if occ==nil then return end
	if occ.t=="player" then
		player.alive=false
		board[x][y]=nil
	elseif occ.t=="fruit" and 
		snake.c==8 then
		board[x][y]=nil
	end
end

--returns tile to direction d
--of snake, relative to snake's
--orientation
--takes d from {0,1,2,3}
function adjrelsnake(snake,d)
	--in picoland, sin varies 0..1
	--let's use that 
	local adj=(d+snake.facing)/4
	local x=snake.x+cos(adj)
	local y=snake.y-sin(adj)
	return x,y
end
__gfx__
00000000077777700777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000700770077007700700888800888888808888000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700700770077777777708000080800888808008800088888888000008880000088800000000000000000000000000000000000000000000000000000000
00077000777777777700007708000080888880008888888088888888000888888888888800000000000000000000000000000000000000000000000000000000
00077000707777077000000708000080888000008088888088888888000888888888888800000000000000000000000000000000000000000000000000000000
00700700770000777700007708000080800000008000000088888888008888880000088800000000000000000000000000000000000000000000000000000000
00000000777777777770077700888800888888808888888000000000008888800000000000000000000000000000000000000000000000000000000000000000
00000000077777700777777000000000000000000000000000000000008888000000000000000000000000000000000000000000000000000000000000000000
88888888000000000000000000000000088888800888888000888800008888000088880000000000000000000000000000000000000000000000000000000000
88888888000000000000000000000000080880800808008000888800008888000088880000000000000000000000000000000000000000000000000000000000
88888888000000000000000000000000080880800808808000888800080888800088880000000000000000000000000000000000000000000000000000000000
88888888000000000000000000000000088800800888808000888800888088880008800000000000000000000000000000000000000000000000000000000000
88888888000000000000000000000000088800800088808000888800888808880008800000000000000000000000000000000000000000000000000000000000
88888888000000000000000000000000088000800008808000888800888008880008800000000000000000000000000000000000000000000000000000000000
88888888000000000000000000000000088000800008808000888800088888800008800000000000000000000000000000000000000000000000000000000000
88888888000000000000000000000000000000000000000000888800008888000008800000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000008888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000088888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000888888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000888888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000888888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000888888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000088888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000008888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000806040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100001f1201f1201f1201e1201c1201912017120161201412011120101200e1200c1200a120091200712006120061200612007120091200c1200e1200f12011120131201412016120191201c1201e12020120
0111000003050030501b6300000006050060501b6300000008050080501b630000000a0500a0501b6300000003050030501b6300000006050060501b6300000008050080501b630000000a0500a0501b63000000
0111000000003000031b6330000300003036031b6330000300003036031b6330000300003036031b6330000300003036031b6330000300003036031b6330000300003036031b6330000300003036031b63300003
011100002273000700227302273222732227322273222732227322273222732227322273222732227321b7301e7301b7001b7301b7321b7321b7321b7321b7321b7321b7321b7321b7321b7321b7321b7321b732
011100002573000000257302573225732257322573225732257322573225732257322573225732000002573027730000002773027732277322773227732277322773227732277322773227732277322773227732
01110000080500805004630000000b0500b0501b630000000d0500d0501b630000000f0500f0501b6300000008050080501b630000000b0500b0501b630000000d0500d0501b630000000f0500f0501b63000000
011100000a0500a0500f6500a0500a0500a0500f6500a05008050080500f6500805008050080500f6500805006050060500f6500605006050060500f6500605005050050500f6500505005050050500f65005050
01110000297202972229722297222972229722297222972229722297222972229722297222972229722297222e7202e7202e7202e7202e7202e7202e7202e7202e7222e7222e7222e7222e7222e7222e7222e722
011100002673026732267322673226732267322673226732267322673226732267322673226732267322673226722267222672226722267222672226722267222672226722267222672226722267222672226722
011000002a7202a7202a7202a72000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
00 41014244
00 41014244
01 41014203
00 41014403
00 41054404
00 41010403
00 41060807
02 41014449
00 41464847

