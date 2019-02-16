pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
--snake pit--
--cloned by marcus zaeyen--
--by mike singleton--
player={f=0,x=0,y=0,dx=0,dy=0}
player.draw = function(self)
	local x,y=board2screenpos(self.x,self.y)
	if player.f%2==1 then
		spr(1,x,y)
	else
		spr(2,x,y)
	end
end

score=0--player score
--refresh/60 = refresh rate in hz
refresh=15

--establish grid
--will hold whatever obj is there
--could be snake, fruit, player
--2d array
board={}

function _init() 
	for i=1,boardx do
		board[i]={}
		for j=1,boardy do
			board[i][j]=nil
		end
	end

	initboard()

	
end

function tick()
	--animate player
	player.f+=1
	if player.f%2==0 then
		player.s=1
	else
		player.s=2
	end
	
	--move player+snakes
	
	--1.update x,y

	
	--2.check if this pos is taken
		--if so, resolve
		
	--3.update board array
	
end

timer = 0
function _update60()
	timer+=1
	if timer%refresh==0 then
		timer=0
		tick()
	end
	
	--player input
	if btn(⬅️) then
		player.dx = -1
	elseif btn(➡️) then
		player.dx = 1
	end
	if btn(⬆️) then
		player.dy = -1
	elseif btn(⬇️) then
		player.dy = 1
	end
end

function _draw()
	cls()
	--draw board contents
	for k,v in pairs(board) do
		if v ~= nil then
			v:draw()
		end
	end
end

--notes on snake movement:
--move to player if adj
--if not, pick target randomly (l,f,r)
--if target taken by other snake
	--(or fruit if not red)
	--pick again (b if no other valid)
--move there
--eat player(fruit if red)
-->8
--board utility functions--

--snake pit is 22x22, but 
--pico8 can't fit that all on
--one screen ¯\_(�⬇️░)_/¯
boardx = 16
boardy = 16

--x,y 1 indexed to match with
--lua's silliness

function board2screenpos(x,y)
	return (x-1)*8,(y-1)*8
end

function initboard()
	for j=1,boardx do
		for i=1,boardy do
			fruit={}
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
end

--occupancy tests
function istaken(x,y)
	return board[board2int(x,y)]==nil
end

function atpos(x,y)
	return board[board2int(x,y)]
end

__gfx__
00000000077777700777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000700770077007700700888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700700770077777777708000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000777777777700007708000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000707777077000000708000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700770000777700007708000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000777777777770077700888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000077777700777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
