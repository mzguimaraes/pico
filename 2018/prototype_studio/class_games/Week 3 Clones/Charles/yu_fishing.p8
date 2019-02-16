pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
--global vars determine the
--speed of various animations
waterstep = 0
waterupdatespeed = 25
waterf = 15
sharkupdatespeed = 15
hookupdatespeed = 5
movespeed = 0.75
score = 0
fishreset = 0

shark = {}
player = {}
--f = {}  --[x,y,xvel,yvel,pts]
fishes = {}
comp = {}


--initialize variables here
function _init()

	--set shark here
	shark["f"] = 0
	shark["s"] = 0
	shark["x"] = 49
	shark["y"] = 32
	shark["xvel"] = -0.33
	shark["flp"] = false
	
	--set player1 here
	player["f"] = 0
	player["s"] = 0
	player["x"] = 17
	player["hx"] = 17
	player["y"] = 25
	player["xvel"] = 0
	player["yvel"] = 0
	player["fish"] = false
	
	--set ai here
	comp["f"] = 0
	comp["x"] = 17
	comp["hx"] = 17
	comp["y"] = 25
	comp["xvel"] = 0
	comp["yvel"] = 0
	comp["fish"] = false
	--"generates" fish here
	for i=1,6 do
	 add(fishes,{x=49,y=36 + (11 * i),
	 xvel = 0.1 + rnd(0.3),yvel = 0.15,
	 c = false, points = i, fr = 0,
	 facing = true, yorig = 36 + (11 * i)})
	
	_rnddir(fishes[i])
	end
end

--updates once per frame
function _update60()
-------------------------------
--controls are handled here
-------------------------------
--player 1 x movement 
if btn(1,0) then
	 if player.x < 90 then
 		player.x += movespeed
 	end
elseif btn(0,0) then 
 if (player.x > 0) then
	 player.x -= movespeed
	end
end
 --the hook trails behind the rod
 if(player.hx > player.x + 0.05) then
 	player.hx -= movespeed/2
 elseif(player.hx < player.x - 0.05) then
 	player.hx += movespeed/2
 elseif (player.hx < player.x - 0.1 and player.hx > player.x + 0.1) then
 	player.hx = player.x
 end
 
 --if caught fish, the fish struggles
 if(player.fish == true) then
 	if (player.x < 90-player.xvel) and
 				(player.x > 0+player.xvel) then
 		player.hx += player.xvel
 		player.x += player.xvel
 	end
 	player.y += player.yvel
 	movespeed = 0.2
 end
 
--player y movement handled as normal
 if(btn(2,0)) then
 	if(player.y > 24) then
 		if(player.fish == false) then
				player.y -= movespeed
			else
				player.y -= movespeed/1.25
			end
		end
 elseif(btn(3,0)) then
 	if(player.y < 106) and
 	(player.fish == false) then
			player.y += movespeed
		end
 end

-------------------------------
--fish are controlled here
-------------------------------
 for f in all(fishes) do
 
 	--moves & aimates fish
 	if(f.fr > 20) then
 		f.fr = 0
 	end
 	f.fr += 1
  if(f.c == false) then
  	f.x += f.xvel
 	else
 		f.fr += 1
  end
  
  --changes direction of fish
  if(f.xvel > 0) then
  	f.facing = true else f.facing = false
  end
  
  if(f.x < 10) then
  	f.x = 10
 		f.xvel *= -1
 	elseif (f.x > 110) then
 		f.x = 110
 		f.xvel *= -1
 	end

-------------------------------
--caught fish are controlled below
-------------------------------
 	_checkbite(f)
  _checkshark(f)
 	if(f.c == true) then
	 	if(fishreset <= 0) then
 			f.xvel = -1+rnd(2)
 			fishreset = 15+rnd(45)
 			player.xvel = f.xvel
 			player.yvel = -0.2
 		else
 			fishreset-=1
 		end
 	end
 	if(f.y < 25) then
 		score += f.points
 		_resetfish(f)
 	end
 	
 	if(f.c == true) then
 		f.y = player.y
 		f.x = player.hx
 	end
 	
 end
-------------------------------
--animations are updated below
-------------------------------
	shark.f += 1
	player.f += 1
	
	if(player.fish == true) then
		if(shark.xvel == 0.33) then
			shark.xvel = 0.72
		elseif(shark.xvel == -0.33) then
			shark.xvel = -0.72 		
		end
	else
		if(shark.xvel == 0.72) then
			shark.xvel = 0.33
		elseif(shark.xvel == -0.72) then
			shark.xvel = -0.33
		end
	end
	
	--updates the shark animation
	if(shark.f >= sharkupdatespeed) then
		shark.f = 0
		shark.s += 1
	end
	
	if(player.f >= hookupdatespeed) then
		player.f = 0
		player.s += 1
	end
	
	--resets shark animation back
	if(shark.s >= 4) then
		shark.s = 0
	end
	
	if(player.s >= 4) then
		player.s = 0
	end
	
	--sets vel and dir of shark
	shark.x += shark.xvel
	if(shark.x < 0) then
		shark.x = 0
		shark.xvel *= -1
		shark.flp = true
	elseif (shark.x > 98) then
		shark.x = 98
		shark.xvel *= -1
		shark.flp = false
	end
	
	waterf -= 1
	if(waterf <= 0) then
		_wateranim()
		waterf = 15
	end
-------------------------------
--end of animation updates
-------------------------------	
end

--draw sprites here
function _draw()

	--map & screen reset here
	cls()
 map(0,0,0,0,16,16)
 palt(11,true) 
 
 --player on dock & fishing line
 spr(9,4,2,2,2,false)
 line(12,11,player.x,11,8)
 line(player.x,12,player.hx,player.y-1,7)
 
 --score display here:
 p1 = "p1: " .. tostr(score)
 print(p1, 0,115,7)
 
 --shark sprite drawn here
 if(shark.s == 0) or (shark.s == 2) then
 	spr(64,shark.x, shark.y, 4, 2, shark.flp)
	elseif (shark.s == 1) then
		spr(96,shark.x, shark.y, 4, 2, shark.flp)
	elseif (shark.s == 3) then
		spr(68,shark.x, shark.y, 4, 2, shark.flp)
	end	
	
	--player 1 hook drawn here
	if(player.fish == false) then
		if(player.s == 0) then
			spr (1, player.hx-1,player.y,1,1)
		elseif(player.s == 1) or (player.s == 3) then
			spr (2, player.hx-1,player.y,1,1)
		elseif(player.s == 2) then
			spr (3, player.hx-1,player.y,1,1)
		end
	else
		spr (3, player.hx-1,player.y,1,1)
	end
	
	--draw fish here
	for f in all(fishes) do
		if(f.fr < 15) then
			spr(18,f.x,f.y,1,1,f.facing)
		else
			spr(34,f.x,f.y,1,1,f.facing)
		end
	end
end

--animates the water
function _wateranim()
	--frame 1
	if(waterstep == 0) then
		for i = 0, 16 do
			if(mget(i,3) == 37) then
				mset(i,3,38)
			elseif (mget(i,3) == 53) then
				mset(i,3,54)
			end
		end	
		waterstep = 1
	
	--frame 2
	elseif(waterstep == 1) then
		for i = 0, 16 do
			if(mget(i,3) == 38) then
				mset(i,3,39)
			elseif (mget(i,3) == 54) then
				mset(i,3,55)
			end
		end	
		waterstep = 2
	
	--frame 3
	elseif(waterstep == 2) then
		for i = 0, 16 do
			if(mget(i,3) == 39) then
				mset(i,3,40)
			elseif (mget(i,3) == 55) then
				mset(i,3,56)
			end
		end	
		waterstep = 3
	
	--frame 4/reset
	elseif(waterstep >= 3) then
		for j = 0, 16 do
			if(mget(j,3) == 40) then
				mset(j,3,37)
			elseif (mget(j,3) == 56) then
				mset(j,3,53)
			end
		end	
		waterstep = 0
	end
end

--checks fish for collision
function _checkbite(f)
	if(player.hx + 2 >= f.x) and
			(player.hx + 2 < f.x+6) then
			
			if(player.y + 2 >= f.y+2) and
			(player.y + 2 < f.y+6) then
			
				if(player.fish == false) then
					f.c = true
					player.fish = true
				end
			end
	end
end

--places the fish back
function _resetfish(f)
	f.c = false
	f.y = f.yorig
	f.x = 49
	player.fish = false
	player.xvel = 0
	player.yvel = 0
	f.xvel = 0.1 + rnd(0.3)
	movespeed = 0.75
	_rnddir(f)
end

--checks if shark got fish
function _checkshark(f)
if(f.y +4 > shark.y) and
		(f.y +2 < shark.y+8) then
		
	if(shark.flp == false) then
		if(f.x+4 > shark.x) and
		(f.x < shark.x + 24) then
			_resetfish(f)
		end
	else
		if(f.x+4 > shark.x+8) and
		(f.x < shark.x + 32) then
			_resetfish(f)
		end
	end
	end
end

--gives fish a random direction
function _rnddir(f)
	if(rnd(3) > 1.5)then
		f.xvel *= -1
	end
end


__gfx__
00000000b5bbbbbbb6bbbbbbb7bbbbbb6666666666666666000000000000000000000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000
000000005b5bbbbb6b6bbbbb7b7bbbbb6666666666666666000000000000000000000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000
007007005b5bbbbb6b6bbbbb7b7bbbbb6666666666666666000000000000000000000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000
00077000b5bbbbbbb6bbbbbbb7bbbbbb6666666666666666000000000000000000000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000
00077000b5b5bbbbb6b6bbbbb7b7bbbb6666666666666666000000000000000000000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000
00700700bb5bbbbbbb6bbbbbbb7bbbbb6666666666666666000000000000000000000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000
00000000bbbbbbbbbbbbbbbbbbbbbbbb6666666666666666000000000000000000000000bb44bbbbbbbbbbbbbb00bbbbbbbbbbbb000000000000000000000000
00000000bbbbbbbbbbbbbbbbbbbbbbbb6666666666666666000000000000000000000000b4444bbbbbbbbbbbb0000bbbbbbbbbbb000000000000000000000000
0000000000000000bbbbbbbb66666666666666666666666600000000000000000000000044ffbbbbbbbbbbbb0044bbbbbbbbbbbb000000000000000000000000
0000000000000000bbbbbbb76666666666666666666666660000000000000000000000004ffffbd8bbbbbbbb04444bdcbbbbbbbb000000000000000000000000
0000000000000000b7777b77444444444444444444444444000000000000000000000000b4ff433ffbbbbbbbb04402244bbbbbbb000000000000000000000000
00000000000000007377777b444444444444444444444444000000000000000000000000b333333fbbbbbbbbb2222224bbbbbbbb000000000000000000000000
00000000000000007777777b444444444444444444444444000000000000000000000000b33333811bbbbbbbb22222c00bbbbbbb000000000000000000000000
0000000000000000b7777b77664444666644446666666666000000000000000000000000bb33331111bbbbbbbb22220000bbbbbb000000000000000000000000
0000000000000000bbbbbbb7664444666644446666666666000000000000000000000000bbb33111115bbbbbbbb22000005bbbbb000000000000000000000000
0000000000000000bbbbbbbb664444666644446666666666000000000000000000000000bbbb111b1155bbbbbbbb000b0055bbbb000000000000000000000000
0000000000000000bbbbbbb766666666ccddddcc11111111cccccccccccccccc1111111100000000000000000000000000000000000000000000000000000000
0000000000000000bbbbbb7766666666ccddddcc1111111111111111cccccccccccccccc00000000000000000000000000000000000000000000000000000000
0000000000000000b7777b7b66666666ccddddcc111111111111111111111111cccccccc00000000000000000000000000000000000000000000000000000000
0000000000000000737777bb66666666ccddddcccccccccc11111111cccccccccccccccc00000000000000000000000000000000000000000000000000000000
0000000000000000777777bb66666666ccddddcc11111111cccccccc11111111cccccccc00000000000000000000000000000000000000000000000000000000
0000000000000000b7777b7b66666666ccddddcccccccccc11111111cccccccc1111111100000000000000000000000000000000000000000000000000000000
0000000000000000bbbbbb7766666666ccddddcccccccccccccccccc11111111cccccccc00000000000000000000000000000000000000000000000000000000
0000000000000000bbbbbbb766666666ccddddcc1111111111111111cccccccc1111111100000000000000000000000000000000000000000000000000000000
000000000000000000000000111111111100001111222211ccddddccccddddcc1122221100000000000000000000000000000000000000000000000000000000
00000000000000000000000011111111110000111122221111222211ccddddccccddddcc00000000000000000000000000000000000000000000000000000000
0000000000000000000000001111111111000011112222111122221111222211ccddddcc00000000000000000000000000000000000000000000000000000000
0000000000000000000000001111111111000011ccddddcc11222211ccddddccccddddcc00000000000000000000000000000000000000000000000000000000
000000000000000000000000111111111100001111222211ccddddcc11222211ccddddcc00000000000000000000000000000000000000000000000000000000
0000000000000000000000001111111111000011ccddddcc11222211ccddddcc1122221100000000000000000000000000000000000000000000000000000000
0000000000000000000000001111111111000011ccddddccccddddcc11222211ccddddcc00000000000000000000000000000000000000000000000000000000
00000000000000000000000011111111110000111122221111222211ccddddcc1122221100000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbb5bbbbbbbbbbbbbbbbbbbbbbbbbbbbb55bbbbbbbbbbbbbb5bbb0000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbb55bbbbbbbbbbbbbbbbbbbbbbbbbbbb555bbbbbbbbbbbbbb5bbb0000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbb555bbbbbbbbbbbbb5bbbbbbbbbbbbb5555bbbbbbbbbbbb555bbb0000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbb5555bbbbbbbbbbb55bbbbbbbbbbbbb55555bbbbbb5bbbb555bbbb0000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbb55555bbbbbb5bbb555bbbbbbbbbbbb5555555bbbb55bbb5555bbbb0000000000000000000000000000000000000000000000000000000000000000
bbbbb55555555555bbbb55bbb55bbbbbbbbbb55555555555bb555bb5555bbbbb0000000000000000000000000000000000000000000000000000000000000000
bbb55555555555555bb555bb55bbbbbbbbb555555555555555555b5555bbbbbb0000000000000000000000000000000000000000000000000000000000000000
b5555555555555555555555555bbbbbbbb555555555555555555555555bbbbbb0000000000000000000000000000000000000000000000000000000000000000
55585555555555555555555555bbbbbbb5855555555555555555555555bbbbbb0000000000000000000000000000000000000000000000000000000000000000
bdddddd55555555dddddddbb55bbbbbbbddd555555555555dddddb5555bbbbbb0000000000000000000000000000000000000000000000000000000000000000
bbddddddddd5555ddddbbbbbb55bbbbbbbddddddd555555ddddbbbb5555bbbbb0000000000000000000000000000000000000000000000000000000000000000
bbbbdddddddd555dbbbbbbbbb555bbbbbbbbdddddd5555ddbbbbbbbb5555bbbb0000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbb55bbbbbbbbbbb55bbbbbbbbbbbbbbb555bbbbbbbbbbb555bbbb0000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbb5bbbbbbbbbbbbb5bbbbbbbbbbbbbbb55bbbbbbbbbbbb555bbb0000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb5bbbbbbbbbbbbbb5bbb0000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb5bbb0000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbb5bbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbb55bbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbb555bbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbb5555bbbbbbbbb5bbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbb55555bbbbbbbb55bbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbb5555555555bbbbb5bb55bbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbb55555555555555bbb55b55bbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bb55555555555555555555555bbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b555555555555555555555555bbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b555885555555555dddddddb55bbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bdddddddddd5555dddddbbbb55bbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbddddddddd555ddbbbbbbbb5bbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbb55bbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbb5bbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000001010101000000000000000000000000020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
2323232323230505232323232323232300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2304052323230505232323232323232300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1314052323230505232323232323131300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3535252525252525252525252525353500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3434333333333333333333333333343400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3434333333333333333333333333343400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3434333333333333333333333333343400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3434333333333333333333333333343400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3434333333333333333333333333343400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3434333333333333333333333333343400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3434333333333333333333333333343400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3434333333333333333333333333343400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3434333333333333333333333333343400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3434333333333333333333333333343400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
