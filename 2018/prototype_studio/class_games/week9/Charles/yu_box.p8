pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
--game wrapper
-------------------------------
state = 0
testf = 0
shake = 0
score = 0
mapx = 0
mapy = 0

--move data
maxy = 94
miny = 47
movespeedx = 0.75
movespeedy = 0.5
gravity = 0.36

--player related variables
p1={x=8,y=64,gy = 64, w=12,h=15,vx=0,
vy=0,rx=0,ry=0,s=3,f=false,t=0,
jumping=false,i=0,flap = false, 
pt = 0, hurt = false,health = 5
, ht = 0, invuln = false,atype=1,
attack = false, flap = false}

e1 = {x=10,y=80, w=16,h=7,vx=0,
vy=0.2,rx=0,ry=0,s=48,f=false,t=0,
grounded = true,i = 0,atype=0,
hurt = false}

dislist = {p1,e1}

blood = {x=1000,y=1000,t = 0,s=140}
clouds= {}
cam = {x=0,y=0}



function _init()
	_spawncloud(10)
	_spawn(15)
end

function _update60()
	testf += 1
	
	--locks player to visible ground y
	if(p1.gy > maxy) then
		p1.gy = maxy
	elseif(p1.gy < miny) then
		p1.y = miny
	end
	
	--handle's player jumping trajectory
	if(p1.jumping == false) then
		p1.gy = p1.y
	else
		if(p1.y >= p1.gy) then
			p1.jumping = false
			p1.flap = false
			p1.hurt = false
		end
		
			p1.vy += gravity
		
	end
	
	if(p1.hurt == false) then
		--ymovement handled here
		if(btn(2,0)) and (p1.jumping == false)then
			p1.vy = -movespeedy
		elseif(btn(3,0)) and (p1.jumping == false)then
			p1.vy = movespeedy
		else
			if(p1.jumping == false) then
				p1.vy = 0
			end
		end
	
		--x movement handled here
 	if(p1.jumping == false) and
 	(p1.hurt == false) then	
 		if(btn(0,0)) then
				p1.vx = -movespeedx
			elseif(btn(1,0)) then
				p1.vx = movespeedx
			else
				p1.vx = 0
			end
		end
	
		if(btnp(4,0)) and 
		(p1.attack == false)then
			p1.t = -10
			p1.attack = true
		end
		
		if(btnp(5,0)) then
			if (p1.jumping==false) then
				p1.jumping = true
				p1.vy = -4.5
			else
				if(p1.flap == false) then
					p1.flap = true
					if(btn(1,0)) then
						p1.vx = 5*movespeedx
						p1.vy = -movespeedy
					elseif(btn(0,0)) then
						p1.vx = -5*movespeedx
						p1.vy = -movespeedy
					end
				end
			end
		end

	
		move(p1,p1.vx,p1.vy,nil,landonwall)
	
	--if hurt, alter here...
	else
		move(p1,p1.vx,p1.vy,nil,landonwall)
	
	end
end

function _draw()
	cls()
	palt(14,true)
	palt(0,false)
	
			--map & screen reset here
		_drawsky()
		cam.x = p1.x
		cam.y = 48
		
		--won't move camera past limits
		if(cam.x < 64) then
			cam.x = 64
		end
		if(cam.x > 750) then
			cam.x = 750
		end
		if(cam.y <0) then
			cam.y = 0
		end
		if(shake > 0) then
			shake-= 0.2
			_shakecam(shake)
		else
			shake = 0
		end
		
		_animplayer()
		camera(cam.x-64,cam.y-40)
		
		
		if(shake > 0) then
			shake -= 0.1
			if(shake < 0) then
				shake = 0
			end
			_shakecam(shake)
		end
		
		--map drawn after creatures
		map(mapx,mapy,0,16,256,256)
		
		spr(57,p1.x,p1.gy+10,2,1)
		
		_sort(dislist)
		for a in all(dislist) do
 		if(a) then
 			--if player is attacking...
 			if(a.atype == 1) and 
 			(a.attack == true) then
 				if(a.f == false) then
 					spr(a.s,a.x-10,a.y+(16-a.h),flr(a.w/8+0.5),flr(a.h/8+0.5),a.f)
 				else
 					spr(a.s,a.x+4,a.y+(16-a.h),flr(a.w/8+0.5),flr(a.h/8+0.5),a.f,a.hurt)
 				end
 			else
 				spr(a.s,a.x,a.y+(16-a.h),flr(a.w/8+0.5),flr(a.h/8+0.5),a.f,a.hurt)
 			end
 		
 				--if the target is an enemy...
 				if(a.atype == 0) then
 				
 					--if they walk out of range
 					if(a.y > maxy) or (a.y < miny)then
 						if(a.hurt == false) then
 							a.vy *= -1
 						end
 					end
 					if(a.hurt == true) then
 						a.vy += gravity
 					end
 				
 					--change direction
 					if(a.hurt == false)then
 						if(a.x > p1.x) then
 							a.vx = -movespeedx/2
  						a.f = false
 						elseif(a.x < p1.x) then
 							a.vx = movespeedx/2
 							a.f = true
 						else
 							a.vx = 0
 						end
 					end
 			
 					move(a,a.vx,a.vy,nil,landonwall)
 				

 					--if touching player...
 					if(_animcol(p1,a))then
 						if(p1.attack == true)then
 							a.hurt = true
 							blood.x = (a.x+p1.x)/2
 							blood.y = (a.y+p1.y)/2
 							blood.t = 0
 						 a.vx = -3
 							a.y-=1
 							a.vy = -3
 							a.s = 41
 							score+=10
 						elseif(a.hurt == false)and
 						(p1.hurt == false) then
 							p1.hurt = true
 							p1.jumping = true
 							shake = 2
 						
 							if(a.x > p1.x) then
 								p1.vx = -2
 								p1.y-=1
 								p1.vy = -5
 							else
 								p1.vx = 2
 								p1.y-=1
 								p1.vy = -5
 							end					
 						end
 					end
 					
 				--remove enemy when it falls out of bounds
 				if(a.y > 512) then
 					a.vy = 0
 					a.vx = 0
 					a.hurt = false
 					a = nil
 				end
 			end
 		end
 	end
 	
		--ui drawn last
			_drawui()
_animblood()
	
	if(testf >= 39) then
		testf = 0
	end
end

function _spawn(x)

	for i=0, x do
			add(dislist, {x=10+((40+rnd(10))*i),y=80, w=16,h=7,vx=0,
			vy=(rnd(3)-3)*0.1,rx=0,ry=0,s=48,f=false,t=0,
			grounded = true,i = 0,atype=0,
			hurt = false})

	end
end
-->8
--collision/movement data 
--collision/movement data 
--------------------------------
--checks if player is colliding
--with an animal
function _animcol(p,t)
	
	if(p.attack == false) then
		if(p.x < t.x+(t.w)) and (p.x + (p.w) > t.x)
		and(p.y+p.h > t.y) and (p.y < t.y + t.h) and
		(p.gy-t.y < 4) and (p.gy-t.y > -4)then
			return true	
		end
	else
		if(p.f == false) then
			if(p.x-10 < t.x+(t.w)) and (p.x-10 + (p.w) > t.x)
			and(p.y+p.h > t.y) and (p.y < t.y + t.h) and
			(p.y-t.y < 12) and (p.y-t.y > -12)then
				return true	
			end
		else
			if(p.x+2 < t.x+(t.w)) and (p.x+2 + (p.w) > t.x)
			and(p.y+p.h > t.y) and (p.y < t.y + t.h) and
			(p.y-t.y < 12) and (p.y-t.y > -12)then
				return true	
			end
		end
	end	
		
		return false
end


function overlapmap(x,y)
--function returns true if there
--is a tile with flag n that
--overlaps a sprite at x,y

 --first we need to know
 --which cels it is touching
 local minmapx=flr((x+8)/8)
 local maxmapx=flr((x+14)/8)
 local minmapy=flr((y+1)/8)
 local maxmapy=flr((y+7)/8)
 
 --walls have flag 0
 if fget(mget(minmapx+mapx-1,minmapy+mapy-1),0) then
  return true
 elseif fget(mget(minmapx+mapx,maxmapy+mapy-1),0) then
  return true
 elseif fget(mget(maxmapx+mapx,minmapy+mapy-1),0) then
  return true
 elseif fget(mget(maxmapx+mapx,maxmapy+mapy-1),0) then
  return true
 else
  return false
 end
end

--moves object by amtx,amty
--one pixel at a time
--stop moving if hit a wall
--and calls function if it
--touches on x or y

--based on matt thorson's 
--towerfall blog post
function move(s,amtx,amty,oncollidex,oncollidey)
 --increment move counter with move amount
 s.rx+=amtx
 s.ry+=amty


 --round to nearest pixel value
 local movex=flr(s.rx+0.5)
	local movey=flr(s.ry+0.5)
	
 if movex==0 and movey==0 then return end 

 s.rx-=movex
	
 local sign=sgn(movex)
 
 --move 1 pixel at a time unless
 --collision detected - then stop
 while movex~=0 do
  if overlapmap(s.x+sign,s.y)==false then
   --move 1 pixel
   s.x+=sign
   --decrement counter
   movex-=sign
  else
   --stop and do not move
   
   if oncollidex~=nil then
    oncollidex(s) 
   end
   break
   
  end
 end
 
 --now do the same in y
 s.ry-=movey
 sign=sgn(movey)
 
 if(overlapmap(s.x,s.y+sign)==false) then
 	s.grounded=false
 end
 
 while movey~=0 do
  if overlapmap(s.x,s.y+sign)==false then
   --move 1 pixel
   s.y+=sign
   --decrement counter
   movey-=sign
   s.grounded=false
  else
   --stop and do not move
   s.vy=0
   --call collide if we landed
   if oncollidey~=nil and sign==1 then
    oncollidey(s) end
   break
  end
 end
end

function landonwall(s)
 --sprite s hit wall with direction d
 s.grounded=true
end

--changes direction
function reversedir(s)
	s.vx*=-1
	
	if(s.vx > 0) then
		s.f = true
	else
		s.f = false
	end
	
	if(rnd(1) < 0.5) then
		jump(s)
	end
end

--causes the targt to jump
function jump(s)
	s.vy = -4
			if(s.vx > s.spd) then  
			s.vx = s.spd
		elseif(s.vx < -s.spd) then
			s.vx = -s.spd
		end
	if(s.vx > 0) then
		s.vx = s.spd
	end
	
	if(rnd(1) < 0.3) then
		reversedir(s)
	end
	
	if(s.vx > 0) then
		s.f = true
	else
		s.f = false
	end
end

--x = intesity of shaking
function _shakecam(x)
	cam.x += rnd(x)-rnd(x)
	cam.y += rnd(x)-rnd(x)
end
-->8
--sky draw/background info
-------------------------------
--draws a giant blue tile
function _drawsky()
	sspr(32,32,8,4,cam.x-64,cam.y-40,16*8,16*8)
	_drawsun()
	_drawclouds()
end

--draws a black box then info
function _drawui()
	--black boxes drawn here:
	sspr(32,64,4,4,cam.x-64,cam.y-40,16*8,6)
	sspr(32,64,4,4,cam.x-64,cam.y+64,16*8,16*4)

	--score display drawn here:
	print("score: "..tostr(score),cam.x-60,cam.y-40,7)
	
	--draws the player's health
	spr(34,cam.x-61,cam.y+68,1,1)
	line(cam.x-53,cam.y+70,
	cam.x-53+(p1.health*10),cam.y+70,8)
	line(cam.x-53,cam.y+71,
	cam.x-53+(p1.health*10),cam.y+71,8)
	line(cam.x-53,cam.y+72,
	cam.x-53+(p1.health*10),cam.y+72,8)
end

--draws the sun (moves it too)
function _drawsun()
	spr(66,cam.x-1,cam.y-20,2,2)
end

--draws the clouds (moves it too)
function _drawclouds()
	for c in all(clouds) do
	c.x -= 0.16
	
	if(c.c < 1) then
		spr(64,cam.x+c.x, cam.y+c.y,1,1)
	elseif(c.c <2) then
		spr(65,cam.x+c.x, cam.y+c.y,1,1)
	elseif(c.c < 3) then
		spr(80,cam.x+c.x, cam.y+c.y,1,1)
	else
		spr(81,cam.x+c.x, cam.y+c.y,1,1)
	end
	
	if(c.x < -72) then
		c.x = 160 + rnd(160)
		c.y = 6+rnd(30)
	end
end
end

--adjusts & picks player sprite
function _animplayer()
 
 --chooses player direction
 if(p1.vx > 0)then
 	p1.f = true
 elseif(p1.vx < 0) then
 	p1.f = false
 end
 	
		p1.t += 1

 		--idle animation here
 	if(p1.vx==0) and (p1.vy==0)then
 		p1.s = 13
 	else
 		
 		--walking animation here
 		if(p1.t < 10) then
 			p1.s = 3
 			p1.w = 15
 		elseif(p1.t < 20) then
 			p1.s = 35
 			p1.w = 15
 		elseif(p1.t < 30) then
 			p1.s = 37
 			p1.w = 15
 		elseif(p1.t < 40) then
 			p1.s = 5
 			p1.w = 15
 		end
 			
 			--animation timer reset
 		if(p1.t >= 39) then
 			p1.t = 0
 		end
 end
 
 if(p1.jumping== true) then
 	p1.s = 7
 end
 
 --attacking handled here
	if(p1.t < 0) then
 		p1.s = 10
 		p1.w = 24
 elseif(p1.t >= 0) then
 	p1.attack = false
 	p1.w = 15
 end
 
 if(p1.flap == true) then
 	p1.s = 39
 	p1.w = 15
 end
end
 

function _animblood()
	blood.t += 2
	
	if(blood.t < 10) then
		blood.s = 70
	elseif(blood.t < 20) then
		blood.s = 72
	elseif(blood.t < 30) then
		blood.s = 74
	elseif(blood.t < 40) then
		blood.s = 76
	elseif(blood.t < 50) then
		blood.s = 78
	else
		blood.s = 102
	end
	
	if(blood.s) then
		spr(blood.s,blood.x,blood.y,2,2)
	end
end

--adds clouds here
function _spawncloud(x)
 
 for i=0, x do
 	add(clouds, {x=-10+rnd(300), 
 	y=6+rnd(30),c = rnd(4)})
 	
 end
end

--sorts the display lsit
function _sort(l)
	
	local sorted = false
	
	--bubble sort
	while(sorted == false) do
		sorted = true
		
		for i=2,#l do
			if(l[i].y < l[i-1].y) then
				local temp = l[i-1];
				l[i-1] = l[i]
				l[i] = temp
				sorted = false
			end
		end
	end
end
__gfx__
00000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee4eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee00000000
00000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee888eeeeeeeeeeeee88eeeee44eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee00000000
00700700eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee884eeeeeeeeeeeee884eeee445eeeeeeeeeeeeeeeeeeeeeeeeee4eeeeeeeeeeeeeeeeeeeeeeeee00000000
00077000eeeeeeeeeeeeeeeeee888eeeeeeeeeeee88044eeeeeeeeeee84044ee4445eeeeeeeeeeeeeeeeeeeeeeeeee44eeeeeeeeeeeeeeeeeeeeeeee00000000
00077000eeeeeeeeeeeeeeeee884eeeeeeee11eee94444eeeeeeeeeee94444444454eeeeeeeeeeeeeeeeeeeeeeeeee44eeeeeeeeeeeeeeeeeeeeeeee00000000
00700700ee88eeeeeeeeeeee88044eeeeee1111eee4444eeeee111eeee4444444445eeeeeeeeeeeeeeeeeeeeeeeee4454eeeeeeeeee888eeeeeeeeee00000000
00000000e8777eeeeeeeeeee94444eeeeee1ee1eee4444eeee11111eeee44444555eeeeeeeeeeeeeeeeee888eeee44454e111eeeee844eeeeeeeeeee00000000
00000000e7077eeeeeeeeeeee44444eeee11ee1eee4444444441ee1eeeee144444eeeeeeeeeeeeeeeeee8844444444544411111ee84044eeeeeee11e00000000
eee77eeea77c7eeeeeeeeeeeee4444444441eeeeee4444454511ee1eeeeee114441eeeeeeeeeeeeeeee8804444444444541eeee1e944444eeeee111100000000
eef777eee77776eee6eeeeeeee4444454511eeeeee154444541eeeeeeeeee1144411eeeeeeeeeeeeee9944444444555551eeeeeeee444444eeee11e100000000
eef777eeee77766666eeeeeeee154444541eeeeeeee15544441eeeeeeeeeee144411eeeeeeeeeeeeeeeeeeeee114444441eeeeeeeee4444444441ee100000000
eff7777eee77766666eeeeeeeee15555541eeeeeeeee114441eeeeeeeeeeeee99901eeeeeeeeeeeeeeeeeeeeee11444111eeeeeeeee4444554451eee00000000
eff7777eee77777666eeeeeeeeee111444eeeeeeeeeee0444eeeeeeeeeeeeeeee09111e1eeeeeeeeeeeeeeeeeee144410eeeeeeeeee454444551eeee00000000
efff777eee77776666eeeeeeeeeee00499eeeeeeeeeee0009eeeeeeeeeeeeeeeee9ee11eeeeeeeeeeeeeeeeeeeee44900eeeeeeeeee15555511eeeee00000000
effffffeeee776666eeeeeeeeeeeeee0ee9eeeeeeeeeeeee90eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee9ee0eeeeeeeeee144411eeeeee00000000
eeffffeeeeee6999eeeeeeeeeeeee00ee99eeeeeeeeeeee99eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee99ee00eeeeeeeeeee4999eeeeeee00000000
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee888eeeeeeeeee44444eeeeeeeee0000000000000000000000000000000000000000
eeeeeee4eeeeeeeee88e88eeeee888eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee488eeeeeeee4444544eeeeeeee0000000000000000000000000000000000000000
eee4eee4eee4eeee8788888eee884eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee4404eeeeeeee4f45444eeeeeeee0000000000000000000000000000000000000000
eeee4e444e4eeeee8788888ee88044eeeeeeee11ee888eeeeeeeeeeeeeee444449eeeeee0fff4444eeeeeeee0000000000000000000000000000000000000000
ee4e444444e4eeeee87888eee94444eeeeeee1eee884eeeeeeeeeeeeeee44444eeeeeeeeeeff4554eeeeeeee0000000000000000000000000000000000000000
eee44444444eeeeeee888eeeee4444eeeee111ee88044eeeeeeeeeeeeee444444444444e4fff4444eeeeeeee0000000000000000000000000000000000000000
4f4444444444f4eeeee8eeeeee4444eeee111eee94444eeeeee11eeeeee44454444554ee44445444eeeeeeee0000000000000000000000000000000000000000
efffff444ffffeeeeeeeeeeeee4444444441eeeee44444eeee1111eeeee4455545544eeee444454eeeeeeeee0000000000000000000000000000000000000000
eeeeeeeeeeeeeeeeeeaaeeeeee4444454511eeeeee4444444441111eeee44445511eeeeeeeeeeeeeeeeeeeee0000000000000000000000000000000000000000
eeeee4eeeeeeeeeeeaaaaeeeee154444541eeeeeee444445451eee1eeeee44444449eeeeeeeeeeeeeeeeeeee0000000000000000000000000000000000000000
eeee4e4e4e4eeeeeea0aaeeeeee15554441eeeeeee154444541eee1eeeeee4444449eeeeeeeeeeeeeeeeeeee0000000000000000000000000000000000000000
eee4444444eeeeee9aaaaaeeeeee111444eeeeeeeee15555541eeee1eeeeeee444490eeeeeeeeeeeeeeeeeee0000000000000000000000000000000000000000
eeef44444444eeeeeaaaaaaaeeeeee0999eeeeeeeeee144440eeeeeeeee1eeee111099eeeeeeeeeeeeeeeeee0000000000000000000000000000000000000000
eeefffff44444eeeeeaaaaaaeeeeee0009eeeeeeeeeee44900eeeeeeeee1eeeee11eeeeeeee5555555555eee0000000000000000000000000000000000000000
e5f0fffffff44eeeeeaaaaaaeeeeeeee0e9eeeeeeeeeeee9ee0eeeeeeeee1ee11eeeeeeee55555555555555e0000000000000000000000000000000000000000
eeffffffffff44eeeeeaaaaeeeeeeee00eeeeeeeeeeee99ee00eeeeeeeeee111eeeeeeeeeee5555555555eee0000000000000000000000000000000000000000
eeeeeeeeeeeeeeeeaeeeeaaaaaaeeeeacccccccc33333733eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eee77eeeeeeeeeeeeeeaaaaaaaaaaeeecccccccc33333b33eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee8eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
ee7767eeee77eeeeeeaaaaaaaaaaaaeecccccccc33b33333eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee78eeeeeeeeee8eeeeeeee7eeeeeeeeeeeeeeeeee
7776666eeeeeeeeeeaaaaaaaaaaaaaaecccccccc33333333eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee87eee2eeeeeeee2eeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeee7eeeaaaaaaaaaaaaaaecccccccc33733333eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee888eeeeeeeeeeeeeeeeeeee8eeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeaaaaaaaaaaaaaaaacccccccc33b33333eeeeeeeeeeeeeeeeeeeeeeee8eeeeeeeeeeeeee22eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeee66eeeeeeeeeaaaaaaaaaaaaaaaacccccccc33333333eeeeeeeeeeeeeeeeeeeeeee887eeeeeee87eeeeeeeee2eeeeeeeeeeeeeeeeeeee2eeeeeeeeeeeee8
eeeeeeeeeeeeeeeeaaaaaaaaaaaaaaaacccccccc33333333eeeeeeeeeeeeeeeeeeeeeee288eeeeeee888eeee8eeeee8eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeaaaaaaaaaaaaaaaa3333333333333333eeeeeeeeeeeeeeeeeeeeeeee8eee8eeeeeee2eeeee2eeee8eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eee7777eeee777eeaaaaaaaaaaaaaaaa3333333333b33333eeeeeee887eeeeeeeeeeeeee2ee228eeeeeeeeeeeeeeeeeee8eeeeeeeeeeeeeeeeeeeeeeeeeeeeee
e7777777ee77777eaaaaaaaaaaaaaaaa3336666333b333b3eeeeeee888eeeeeeee2287eeee2eeeeee82e2eeeeeeeeeeeeee2eeeeeeeeee8eeeeeeeeeeeeeeeee
77677667ee77667eeaaaaaaaaaaaaaae33dd6663333333b3eeeeeeee2eeeeeeeee2288ee8e2eeeeee8eeeeeeeeee8eeee8eeeeeeeeeeeeeeeeeeeeeeeeeeeeee
e776677eeee76667eaaaaaaaaaaaaaae3dddddd63b3333b3eeeee87eee78eeeeee22228eeee8887eeeee8eeeeeeee88eeeeeeeeeeeeeee8eeeeeeeeeeeeeeeee
ee777eee77776666eeaaaaaaaaaaaaee3333333333333333eeeee888e888eeeeeeeeee2eee2ee28ee8eeeeeeeee8eeeeeeeee8eeeeeeeeeeeeeeeeeeeeeeee2e
eeeeeeeeeeeeeeeeeeeaaaaaaaaaaeee3333333333333333eeeeee28e82eeeeeeeeeeee2eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee2eeeeeeeeee8eee
eeeeeeeeeeeeeeeeaeeeeaaaaaaeeeea3333333333333333eeeeeee222eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
5555555555666666b3b3b6b3633b333bdddddddd33333333eeeeeeeeeeeeeeee0000000000000000000000000000000000000000000000000000000000000000
56666666656dddd633636b3636363633dddddddd333b3333eeeeeeeeeeeeeeee0000000000000000000000000000000000000000000000000000000000000000
56dddddd65dddddd663dddd365d3ddd3dddddddd333b33b3eeeeeeeeeeeeeeee0000000000000000000000000000000000000000000000000000000000000000
5dddddddd5dddddd3dd3dd3dd5ddddd3dddddddd3b333733eeeeeeeeeeeeeeee0000000000000000000000000000000000000000000000000000000000000000
5dddddddd5dddddd5d3dddddd5dddddddddddddd3b333b33eeeeeeeeeeeeeeee0000000000000000000000000000000000000000000000000000000000000000
5ddddddd555555555ddddddd55555555dddddddd3b333b33eeeeeeeeeeeeeeee0000000000000000000000000000000000000000000000000000000000000000
5dddd555666656665dddd55566665666dddddddd33333333eeeeeeeeeeeeeeee0000000000000000000000000000000000000000000000000000000000000000
55555666ddd656dd55555666ddd656dddddddddd33333333eeeeeeeeeeeeeeee0000000000000000000000000000000000000000000000000000000000000000
566656ddddd55ddd566656ddddd55dddeeeeeeee33333333eeeeeeeeeeeeeeee0000000000000000000000000000000000000000000000000000000000000000
56d65dddddd56ddd56d65dddddd56dddeeeeeeee33333333eeeeeeeeeeeeeeee0000000000000000000000000000000000000000000000000000000000000000
5ddd5dddddd5dddd5ddf5ddddfd5ddfdeeeeeeee33333333eeeeeeeeeeeeeeee0000000000000000000000000000000000000000000000000000000000000000
55555dddddd5ddddf5555ddfddd5ddddee3eeee333333333eeeeeeeeeeeeeeee0000000000000000000000000000000000000000000000000000000000000000
566665ddddd5dddddfff6ddddddfdddf33ee3e3e33333333eeeeeeeeeeeeeeee0000000000000000000000000000000000000000000000000000000000000000
5dddd5ddddd5ddddfdfdfffdfdfdfdfd3333333333333333eeeeeeeeeeeeeeee0000000000000000000000000000000000000000000000000000000000000000
5dddd5ddddd5ddd5ffdfdfffdfdfffdf3333333333333333eeeeeeeeeeeeeeee0000000000000000000000000000000000000000000000000000000000000000
5dddd55555555555ffffffffffffffff3333333333333333eeeeeeeeeeeeeeee0000000000000000000000000000000000000000000000000000000000000000
11111111188111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101010100000000000000000000000001010101000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474000000000000000000000000000000000000
4575757575755575757575557575757575757575754575757575757575757575755575757575757575757575757575457575757575756575757575757575757565757575756575557575757575756575757575757575755575757575757575757575754575757575754575757575000000000000000000000000000000000000
7575657575457575757575757575757555757575757575756575757575757545757575757575756575757555757575757555756575754575756575756575757575755475757575757575657575757575754575657575657575757575457575755575757575557575757575557575000000000000000000000000000000000000
7575757575757565756575755575757575755475557575754575757575557575755475755575757575757575757575657575757565757575757575757575756575757575757545757575757575457575757555757565757575657575756575757575457575755475457575754575000000000000000000000000000000000000
7575657554757575757575757575756575757575757575757575757575757575757575757575547575756575757575757575757554755575755575757555757575757555757575755475757575757575757575757575757575757554757575757575757575755475757554757575000000000000000000000000000000000000
7575757575757575757575757575547575757575754575757575755475757575657575757575757575757575757575757575757575757575757575757575757554757575757575757575755475754575757575757575757575757575757575757575757575757575757575757575000000000000000000000000000000000000
7575757575757575457575757575757575757575757575757575757575757575757575757575757575757575757575557575757575757575757575757575757575757575757575757575757575757575757555757554757575757575757575755575757575757575757575757575000000000000000000000000000000000000
7575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575755575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575757575000000000000000000000000000000000000
