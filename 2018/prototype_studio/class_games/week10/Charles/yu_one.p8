pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
--game wrapper
-------------------------------
state = 0
mapx = 0
mapy = 0
cam = {x=64,y=40}
shake = 0

--check sounds
hitplay = false
dragplay = false
invulnplay = false
warning = false
abreak = false
musicp = false

--player variables here
p1 = {health = 50,attack = false,
invuln = false, x=20, y=40, 
hurt = false, armor = 50}
ac = true
f = 0
p = 0

--enemy variables here
eas = 0 --0 = nil, 1=wind-up, 2=attack
etimer = 0
ethresh = 50
e1 = {health = 50, attack = false,
tf = 0, tt = true,
af = 64+rnd(128), x = 50, y=32}
clouds = {}

ix = 0
ixoff = 0
iy = 0
tspeed = 1

--sets player initial position
function _init()
 
	ix = 60
	iy = p1.y
	_spawncloud(10)
end

--chooses which game state
function _update60()
	
	if(state == 0) then
		_up0()
		mapx = 15
	elseif(state == 1) then
	mapx = 0
	if(musicp == false) then
		music(1)
		musicp = true
	end
		_up1()
	elseif(state == 2) then
	if(musicp == true) then
		music(-1)
		musicp = false
	end
		_up2()
	elseif(state == 3) then
		if(musicp == true) then
		music(-1)
		musicp = false
	end
		_up3()
	elseif(state == 4) then
		if(musicp == true) then
		music(-1)
		musicp = false
	end
		_up4()
	end
end

--draws game objects here
function _draw()
	cls()
	palt(0,false)
	palt(10,true)

	
	--chooses gamesate
	if(state == 0) then
		_d0()
	elseif(state == 1) then
		_d1()
	elseif(state == 2) then
		_d2()
	elseif(state == 3) then
		_d3()
	elseif(state == 4) then
		_d4()
	end
end



-->8
--state 1: primary gameplay
-------------------------------

function _up1()
	
	--adjusts player position
	if(p1.attack) then
		if(p1.x < ix+ixoff+10) then
			p1.x += tspeed
		end
		if(p1.x > ix+ixoff+10) then
			p1.x = ix+ixoff+10
		end
	else
		if(p1.x > ix+ixoff) then
			if(ac) then
				p1.x -= tspeed
			else
				p1.x -= tspeed/2
			end
		end
		if(p1.x < ix+ixoff) then
			p1.x = ix+ixoff
		end
	end
	
	--adjusts dragon pos to match
	if(e1.x < ix+ixoff+26) then
		e1.x += tspeed
	elseif(e1.x > ix+ixoff+26) then
		e1.x = ix+ixoff+26
	end	
	
	ixoff = 50-e1.health
	
	--player dies
	if(p1.health < 0) then
		state = 4
	end
	
	--reduces camshake
	if(shake > 0) then
		shake-=0.33
	elseif(shake < 0) then
		shake = 0
	end
	
	if(p1.attack == true) then
		p1.invuln = false
	end
	if(p1.armor > 0) then
		abreak = false
	else
		if(abreak == false) then
			sfx(15)
			abreak = true
		end
	end
	

	--armor regenerates slowly
	--over time
	if(p1.armor > 0) and (p1.armor < 50)then
		if(e1.attack == false) or 
		(ac == false) then
			p1.armor += 0.0175
		end
	end
	if(p1.armor < 0) then
		p1.armor = 0
	end
	--if the enemy attacks, and the
	--player is not invincible
if(e1.attack)then 
	
	if(p1.invuln == false)then	
	
		--if the player is attacking
		if(ac==false) or (p1.armor == 0)
		or (p1.hurt) then
			p1.hurt = true
			shake = 3
			if(p1.armor > 0) then
				p1.health-=0.33
			else
				p1.health-=0.66
			end
			--extends hurt animation
			if(f > -2) then
				f=-30
			end
			
		--damages player armor here
		else	
			p1.armor -=0.6
		end
	--if player is invincible...
	else
		p1.armor += 0.33
		
		if(invulnplay == false) then
			sfx(2)
			invulnplay = true
		end
		
		--caps to max armor
		if(p1.armor > 50) then
			p1.armor = 50
		end
	end
end

	--player attacks when button
	--is held; blocks otherwise
	if(btn(5,0) or btn(4,0)) then
		
		--if the player wasn't attack
		--resets the animations
		if(ac ==true) 
		and (p1.hurt==false)then
			f=0
			invulnplay = false
		end
		if(p1.hurt == false) then
			ac = false
			p1.attack = true
		end
	else
		p1.attack = false
	end
	
	--"f" is used to time anims
	if(p1.attack == true) then
		--resets animation timer
		if(f >= 49) then
			f=0
		end
	
		--invuln ends after f=0
	elseif(p1.invuln == true) and
	(e1.attack == false)then
		if(f >= 0) then
			p1.invuln = false
		end
	end	
		
	--hurt timer functions similarly
	if(p1.hurt == true) then
		if(f >= 0) then
			p1.hurt = false
		end
	end
	
	--animation timer increments 
	if(ac == false) or
	(p1.invuln == true)or
	(p1.hurt == true)then
		f+=2
	end
	
	--can't attack when hurt
	if(p1.hurt == true) then
		ac = true
	end
end

--draws everything visible
function _d1()

	--print(""..tostr(f),10,10,7)
	--camera control handled here
	
	camera(cam.x-64,cam.y-40)
	map(mapx,mapy,0,0,256,256)
	cam.x = mapx+64
	cam.y = mapy+40

	_drawui()

	if(shake > 0) then
		_shakecam(shake)
		
	end

		
	--prince, begging in corner
	p+=1
	if(p%20 > 10) then
		spr(202,112,48,2,2)
	else
		spr(234,112,48,2,2)
	end
	if(p> 40) then
		p=0
	end

	--the boss monster here
		_dragon()
		
	--when attacking...
	if(ac == false) then
	
	--animation will play until end
		if(f < 10) then
			spr(18,p1.x,p1.y,3,3)
			hitplay = false
		elseif(f < 20) then
			spr(21,p1.x,p1.y,3,3)
		elseif (f < 30) then
			spr(8,p1.x,p1.y-8,3,4)
		elseif(f<40) then
			shake = 0.35
			spr(27,p1.x,p1.y,3,3)
		
		--final "attack" frame
		else
			spr(16,p1.x,p1.y,2,3)
			e1.health-=0.07
			
			--play hit sound
			if(hitplay == false) then
				sfx(0)
				hitplay = true
			end
			
			if(f >= 41) then
				--player is invulnerable when
 			--swapping from attack
 			if(p1.attack == false)
				and (ac == false) then
					p1.invuln = true
					ac = true
					f = -16
				end
			end
		end
		
	--when not attacking...
	else
	
		--determines which defense
		--sprite to use
		if(p1.invuln == true) then
			spr(80,p1.x,p1.y,2,3)
		elseif(p1.hurt == true) then
			if(f%10>5) then
				spr(82,p1.x-2,p1.y,2,3)
			else
				spr(84,p1.x-2,p1.y,2,3)
			end
		else
			if(e1.attack == false) then
				spr(30,p1.x,p1.y,2,3)
			else
				spr(220,p1.x,p1.y,2,3)
			end
		end	
	end
end


-->8
--enemy control code
--------------------------------
function _dragon()
-------------------------------
	--dragon head...
-------------------------------
	
	e1.af+=1
	
	--flame drawn before dragon
	if(e1.af > 40) then
		if(e1.af < 70) then
			if(dragplay == false) then
				sfx(1)
				dragplay = true
			end
			if(e1.af%10 > 5) then
				spr(134,e1.x-28,e1.y+8,4,3)
			else
				spr(138,e1.x-26,e1.y+8,3,3)
			end
		elseif(e1.af<66) then
			spr(138,e1.x-28,e1.y+8,3,3)
		elseif(e1.af<72) then
			spr(142,e1.x-30,e1.y+16,2,2)
		elseif(e1.af<78) then
			spr(174,e1.x-32,e1.y+16,2,2)
		else
			dragplay = false	
		end
	end
	
	if(e1.health <0) then
		e1.health = 0
	end
	
	--attack animation here...
	if(e1.af < 0) then
		if(p1.attack == true) and
		(f > 30)then
			spr(132,e1.x,e1.y,2,2)
		else
			spr(70,e1.x,e1.y,2,2)
		end
	--20+flr(rnd(8))
	--wind-up
	elseif (e1.af < 31) then
	
		--warning indicator
		if(warning == false) then
			sfx(3)
			warning = true
		end
		if(e1.af < 10) then
			spr(67,e1.x+4,e1.y-10,1,1)
		elseif(e1.af < 20) then
			spr(68,e1.x+4,e1.y-10,1,1)
		else
			spr(69,e1.x+4,e1.y-10,1,1)
		end
		spr(74,e1.x,e1.y,2,2)
		
	--attack
	elseif (e1.af <70) then
		e1.attack = true
		spr(76,e1.x,e1.y,2,2)
		
	--wind down
	else
		warning = false
		e1.attack = false
		spr(78,e1.x,e1.y,2,2)
	end
	
	if(e1.af > 85) then
		e1.af = -20 - rnd(206+e1.health)
	end
	-------------------------------
	--dragon wings...
	-------------------------------
	if(e1.tf%30 > 15) then
		spr(72,e1.x+16,e1.y,2,2)
	else
		spr(128,e1.x+16,e1.y,2,2)
	end
	-------------------------------
	--dragon claws...
	-------------------------------
	if(e1.attack == true) then
		spr(146,e1.x,e1.y+16,1,1)
	elseif(e1.af > -10) then
		spr(130,e1.x,e1.y+16,1,1)
	else
		spr(102,e1.x,e1.y+16,1,1)
	end
	
	-------------------------------
	--dragon torso...
	-------------------------------
	spr(103,e1.x+8,e1.y+16,1,2)
	spr(118,e1.x,e1.y+24,1,1)
	
	-------------------------------
	--dragon tail...
	-------------------------------
	if(e1.tt == true) then
		e1.tf += 1
	else
		e1.tf -= 1
	end
	
	--determines which way the tail
	--will swing
	if(e1.tf > 70) then
		e1.tt = false
	end
	if(e1.tf < -10) then
		e1.tt = true
	end
	
	--tail animation sprites
	if(e1.tf < 10) then
		spr(106,e1.x+16,e1.y+16,2,2)
	elseif(e1.tf < 20) then
		spr(108,e1.x+16,e1.y+16,2,2)
	elseif(e1.tf < 30) then
		spr(110,e1.x+16,e1.y+16,2,2)
	elseif(e1.tf < 40) then
		spr(160,e1.x+16,e1.y+16,2,2)
	elseif(e1.tf < 50) then
		spr(162,e1.x+16,e1.y+16,2,2)
	elseif(e1.tf < 60) then
		spr(164,e1.x+16,e1.y+16,2,2)
	else
		spr(104,e1.x+16,e1.y+16,2,2)
	end
	
	--when dragon is slain...
	if(e1.health <= 0) then
		state = 3
	end
end

--draws the training dummy
function _dummy()
	e1.af+=1
	
	--when the dummy is killed
	if(e1.health <= 0) then
		state = 2
	end
	
	e1.x = ix+26
	
	if(p1.attack == true) and
	(f > 30) then
		spr(209,e1.x,e1.y+8,1,3)
	else
		spr(208,e1.x,e1.y+8,1,3)
	end
	
	e1.health += 0.03
	if(e1.health > 50) then
		e1.health = 50
	end
end
-->8
--camera and ui control here
-------------------------------
--x = intesity of shaking
function _shakecam(x)
	cam.x += rnd(x)-rnd(x)
	cam.y += rnd(x)-rnd(x)
end

--draws a black box then info
function _drawui()
	--black boxes drawn here:
	--sspr(16,0,4,4,cam.x-64,cam.y-40,16*8,6)
	sspr(0,0,4,4,cam.x-64,cam.y+44,16*8,16*8)

	--score display drawn here:
	--print("score: "..tostr(score),cam.x-60,cam.y-40,7)
	
	--draws the player's health
		spr(64,cam.x-61,cam.y+58,1,1)

		--grey bit underneath
		--line(cam.x-53+(p1.health),cam.y+60,
	--cam.x-53+50,cam.y+60,5)
		line(cam.x-53,cam.y+61,
	cam.x-53+25,cam.y+61,1)
		line(cam.x-53,cam.y+62,
	cam.x-53+25,cam.y+62,1)
		--color display
		line(cam.x-53,cam.y+60,
	cam.x-53+(p1.health)/2,cam.y+60,8)
		line(cam.x-53,cam.y+61,
	cam.x-53+(p1.health)/2,cam.y+61,8)
		line(cam.x-53,cam.y+62,
	cam.x-53+(p1.health)/2,cam.y+62,8)
		print("hp",cam.x-52,cam.y+56,7)

	--draws player's armor
	if(p1.armor > 0) then
		spr(65,cam.x-61,cam.y+68,1,1)
	else
		spr(182,cam.x-61,cam.y+68,1,1)
	end
	--grey bit underneath
		--line(cam.x-53+(p1.armor),cam.y+70,
	--cam.x-53+50,cam.y+70,1)
		line(cam.x-53,cam.y+71,
	cam.x-53+25,cam.y+71,1)
		line(cam.x-53,cam.y+72,
	cam.x-53+25,cam.y+72,1)
	
	--color display
		line(cam.x-53,cam.y+70,
	cam.x-53+(p1.armor)/2,cam.y+70,13)
		line(cam.x-53,cam.y+71,
	cam.x-53+(p1.armor)/2,cam.y+71,13)
		line(cam.x-53,cam.y+72,
	cam.x-53+(p1.armor)/2,cam.y+72,13)
	print("dr",cam.x-52,cam.y+66,7)
	
	--draws enemy health here
	
	spr(66,cam.x+20,cam.y+58,1,1)
		
		--grey bit underneath
		line(cam.x+30,cam.y+61,
	cam.x+30+25,cam.y+61,1)
		line(cam.x+30,cam.y+62,
	cam.x+30+25,cam.y+62,1)
		--color display
		line(cam.x+30,cam.y+60,
	cam.x+30+(e1.health)/2,cam.y+60,3)
		line(cam.x+30,cam.y+61,
	cam.x+30+(e1.health)/2,cam.y+61,3)
		line(cam.x+30,cam.y+62,
	cam.x+30+(e1.health)/2,cam.y+62,3)
	print("boss",cam.x+31,cam.y+56,7)
end

--draws a giant blue tile
function _drawsky()
	sspr(88,0,2,4,cam.x-64,cam.y-40,16*8,16*8)
	_drawclouds()
end


--draws the clouds (moves it too)
function _drawclouds()
	for c in all(clouds) do
		c.x -= 0.16
	
		if(c.c < 1) then
			spr(204,cam.x+c.x, cam.y+c.y,1,1)
		elseif(c.c <2) then
			spr(205,cam.x+c.x, cam.y+c.y,1,1)
		elseif(c.c < 3) then
			spr(242,cam.x+c.x, cam.y+c.y,2,1)
		else
			spr(190,cam.x+c.x, cam.y+c.y,1,1)
		end
	
		if(c.x < -72) then
			c.x = 160 + rnd(160)
			c.y = 0+rnd(20)
		end
	end
end

--adds clouds here
function _spawncloud(x)
 
 for i=0, x do
 	add(clouds, {x=-10+rnd(300), 
 	y=0+rnd(20),c = rnd(4)})
 	
 end
end
-------------------------------
--text display code here
-------------------------------
text = {}
started = false
mesfinished = false
cotimer = 0

tstarted = {}
tmesfinished = {}
tcotimer = {}
tcor = {}

--takes starting x,y pos, and 
--a string table, m
function _printmes(x,y,m,p)

	if(started == false) then
	
		cor = cocreate(_diag)
		coresume(cor,m,m[0],32)

		started = true
	end
	
	if(cotimer <=0) and
		(costatus(cor) ~= 'dead') then
			coresume(cor)
			cotimer = 2
	elseif(costatus(cor) == 'dead') then
			mesfinished = true
	end
	
	cotimer -= 1


--writes dialog here
	for i=1,m[0] do
 	if(text[i]) then
 	
 		if(p == true) then
 			if(i == 1) then
 				print(text[i],x,y+(7*i),8)
 			elseif(i == 2) then
 				print(text[i],x,y+(7*i),13)
 			else
 				print(text[i],x,y+(7*i),0)
 			end
 		else
 			print(text[i],x,y+(7*i),7)
 		end
 	end
	end
end

--co-routine for printing dialog
function _diag(m,n,l) 
	
	--while there are lines left to print...
	for i=1,n do
	
		--for each character in the line...
		for j=1,l do		
			text[i] = sub(m[i],1,j)
	
 		
			yield()
		end
	end
	mesfinished = true
	yield()
end


-->8
--state 0: tutorial scene
-------------------------------
function _up0()
	
	--adjusts player position
	if(p1.attack) then
		if(p1.x < ix+10) then
			p1.x += tspeed
		end
		if(p1.x > ix+10) then
			p1.x = ix+10
		end
	else
		if(p1.x > ix) then
			if(ac) then
				p1.x -= tspeed
			else
				p1.x -= tspeed/2
			end
		end
		if(p1.x < ix) then
			p1.x = ix
		end
	end
	
	--player dies
	if(p1.health < 0) then
		p1.health = 0
	end
	
	--reduces camshake
	if(shake > 0) then
		shake-=0.33
	elseif(shake < 0) then
		shake = 0
	end
	

	--armor regenerates slowly
	--over time
	if(p1.armor > 0) and (p1.armor < 50)then
		if(e1.attack == false) or 
		(ac == false) then
			p1.armor += 0.01
		end
	end
	if(p1.armor < 0) then
		p1.armor = 0
	end
	--if the enemy attacks, and the
	--player is not invincible
if(e1.attack)then 
	
	if(p1.invuln == false)then	
	
		--if the player is attacking
		if(ac==false) or (p1.armor == 0)
		or (p1.hurt) then
			p1.hurt = true
			shake = 5
			p1.health-=0.5
			--extends hurt animation
			if(f > -2) then
				f=-30
			end
			
		--damages player armor here
		else	
			p1.armor -=0.5
		end
	--if player is invincible...
	else
		p1.armor += 0.1
		
		--caps to max armor
		if(p1.armor > 50) then
			p1.armor = 50
		end
	end
end

	--player attacks when button
	--is held; blocks otherwise
	if(btn(5,0) or btn(4,0)) then
		
		--if the player wasn't attack
		--resets the animations
		if(ac ==true) 
		and (p1.hurt==false)then
			f=0
		end
		if(p1.hurt == false) then
			ac = false
			p1.attack = true
		end
	else
		p1.attack = false
	end
	
	--"f" is used to time anims
	if(p1.attack == true) then
		--resets animation timer
		if(f >= 49) then
			f=0
		end
	
		--invuln ends after f=0
	elseif(p1.invuln == true) and
	(e1.attack == false)then
		if(f >= 0) then
			p1.invuln = false
		end
	end	
		
	--hurt timer functions similarly
	if(p1.hurt == true) then
		if(f >= 0) then
			p1.hurt = false
		end
	end
	
	--animation timer increments 
	if(ac == false) or
	(p1.invuln == true)or
	(p1.hurt == true)then
		f+=2
	end
	
	--can't attack when hurt
	if(p1.hurt == true) then
		ac = true
	end
end


function _d0()
	--print(""..tostr(f),10,10,7)
	_drawsky()
	--camera control handled here
	camera(cam.x-64,cam.y-40)
	map(mapx,mapy,0,0,256,256)
	spr(198,64,4,4,4)
	
	_drawui()
	cam.x = mapx+64
	cam.y = mapy+40
	_dummy()
	if(shake > 0) then
		_shakecam(shake)
	end
	
	print("kill the dummy to begin!",
	30,78,13)
		print("kill the dummy to begin!",
	30,77,7)
	
	--when attacking...
	if(ac == false) then
	
	--animation will play until end
		if(f < 10) then
			spr(18,p1.x,p1.y,3,3)
			hitplay = false
		elseif(f < 20) then
			spr(21,p1.x,p1.y,3,3)
		elseif (f < 30) then
			spr(8,p1.x,p1.y-8,3,4)
		elseif(f<40) then
			spr(27,p1.x,p1.y,3,3)
		
		--final "attack" frame
		else
			spr(16,p1.x,p1.y,2,3)
			e1.health-=2
			--play hit sound
			if(hitplay == false) then
				sfx(0)
				hitplay = true
			end
			shake = 1
			
			if(f >= 48) then
				--player is invulnerable when
 			--swapping from attack
 			if(p1.attack == false)
				and (ac == false) then
					p1.invuln = true
					ac = true
					f = -12
				end
			end
		end
		
	--when not attacking...
	else
	
		--determines which defense
		--sprite to use
		if(p1.invuln == true) then
			spr(80,p1.x,p1.y,2,3)
		elseif(p1.hurt == true) then
			if(f%10>5) then
				spr(82,p1.x-2,p1.y,2,3)
			else
				spr(84,p1.x-2,p1.y,2,3)
			end
		else
			spr(30,p1.x,p1.y,2,3)
		end	
	end
	
	--tutorial message bottom
	print("<you", 58,87,12)
	print("foe>", 80,87,14)
end
-->8
--state 2: initial message display
------------------------------
m1 ={"sir knight,"," ",
"as i am certain you are aware",
"the prince was recently kid-",
"-napped, and is currently",
"being held captive my a fier-",
"-some dragon.", "",
"we need a hero; maybe that",
"hero is you!",
"","yours,","the king"}
m1[0] = 20

delay = 15
set = false

function _up2()
	cam.x = 0
	cam.y = 0
	mapx = 0
	
	if(delay <= 0) then
		if(set == true) and
		(btn(5,0) == false) and 
		(btn(4,0) == false) then
			sfx(4)
			e1.health = 50
 		ix = 12
 		p1.x = 12
			text = {}
			started = false
			mesfinished = false
 		cotimer = 0
 		set = false
 		delay = 35
			state = 1
		end
		
		--moves into main gameplay
		if(btn(5,0) or btn(4,0)) and
		(set == false)then
			set = true
			delay = 15
		end
	else
		delay-=1
	end
end

function _d2()
cls()
_printmes(16,1,m1, false)
print("press 'x' to continue",26,110,13)
end
-->8
--state 3: victory message display
------------------------------
m2 ={"seeing his chance, the",
"prince stabbed the dragon in",
"the back as soon as it was",
"close enough.","",
"eternally grateful and quite",
"infatuated with this brave",
"knight, he began to court",
"them, and soon they were wed."}

m2[0] = 20

function _up3()
	cam.x = 0
	cam.y = 0
	mapx = 0
	
	if(delay <= 0) then
		if(set == true) and
		(btn(5,0) == false) and 
		(btn(4,0) == false) then
		p1 = {health = 50,attack = false,
invuln = false, x=20, y=40, 
hurt = false, armor = 50}
			e1 = {health = 50, attack = false,
tf = 0, tt = true,
af = 64+rnd(128), x = 50, y=32}
 		sfx(4)
 		ix = 60
 		p1.x = ix
			text = {}
			started = false
			mesfinished = false
 		cotimer = 0
 		set = false
 		delay = 15
 		shake = 0
			state = 0
		end
		
		--moves into main gameplay
		if(btn(5,0) or btn(4,0)) and
		(set == false)then
			set = true
			delay = 15
		end
	else
		delay-=1
	end
end

function _d3()
cls()
print("victory!", 48,14,3)
print("victory!", 48,13,11)
_printmes(16,22,m2, false)
print("press 'x' to continue",24,110,13)
end
-->8
--state 4: game over
------------------------------
m3 ={"though they fought bravely,",
"the knight proved no match",
"for the mighty dragon.","",
"as the knight died in fiery",
"agony, so too did all hope",
"for the young prince, and",
"his doomed kingdom."}

m3[0] = 20

function _up4()
	cam.x = 0
	cam.y = 0
	mapx = 0
	
	if(delay <= 0) then
		if(set == true) and
		(btn(5,0) == false) and 
		(btn(4,0) == false) then
		p1 = {health = 50,attack = false,
invuln = false, x=20, y=40, 
hurt = false, armor = 50}
			e1 = {health = 50, attack = false,
tf = 0, tt = true,
af = 64+rnd(128), x = 50, y=32}
 		sfx(4)
 		ix = 60
 		p1.x = ix
			text = {}
			started = false
			mesfinished = false
 		cotimer = 0
 		set = false
 		delay = 15
 		shake = 0
			state = 0
		end
		
		--moves into main gameplay
		if(btn(5,0) or btn(4,0)) and
		(set == false)then
			set = true
			delay = 15
		end
	else
		delay-=1
	end
end

function _d4()
cls()
print("game over", 44,16,2)
print("game over", 44,15,8)
_printmes(16,25,m3, false)
print("press 'x' to continue",24,110,13)
end
__gfx__
0000000011111111000000005000500005500550ddd5ddd555555555566656ddaaaaaaaaaaaaaaaaaaaaaaaacccccccc11112211111111111111111111111111
0000000011111111000000000000000000505000d555ddd55666666656d65dddaaaaaaaaaaaaaaaaaaaaaaaacccccccc11112211112111111111111111111111
00700700111111110000000000000000550550555ddd555556dddddd5ddd5dddaaaaaaaaaaaaaaaaaaaaaaaacccccccc11188881112111111111111111111111
00077000111111110000000000000000505050505dddddd55ddddddd55555dddaaaaaaaaaaaaaaaaaaaaaaaacccccccc11117611112221211112222111111111
00077000111111110000000000000000050505055ddddd5d5ddddddd566665ddaaaaaaaaaaaaaaaaaaaaaaaacccccccc11117611111111111111111211111211
0070070011111111000000000000000050050050d55555dd5ddddddd5dddd5ddaaaaaaaaaaaaaaaaaaaaaaaacccccccc11117611112111111111111211222221
0000000011111111000000000000000005005005555555555dddd5555dddd5ddaaaaaaaaaaaaaaaaaaaaa777cccccccc11117611212111111112222211111111
000000001111111100000000000000005000500055505550555556665dddd555aaaaaaaaaaaaaaaaaaaa7777cccccccc11117611111111111111111211111111
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa77777aaaaaa777777aaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa777777aaaa7777777777aaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa7777777aa7777779877777aaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaa8896aaaaaaaaaaaaaa896aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa77777777a77777d6668aaaa7aaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaa88a6666aaaaaaaaaaaa86666aaaaaaaaaaaaaaaaaaaa896aaaaaaa777777777a7777755668aaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaa8896aaaaaaaaaaaaaaaaaaaa6655aaaaaaaaaaaa86665aaaaaaaaaaaaaaaaaaaa6866aaaaa7777777777aa777dddd6a8aaaaa7aaaaaaaaaaa896aaaaaaaa
aaa8a6666aaaaaaaaaaaaaaaaaaad6666aaaaaaaaaaaa8666aaaaaaaaaaaaaaaaaaaa6688aaaa77777777777aaa77dddddaaaaaaaa7aaaaaaaaa86666aaaaaaa
aaaa86555aaaaaaaaaaaaaaaaaaaaddd6aaaaaaaaaaaaadddaaaaaaaaaaaaaaaaaaaad666aaa7777aa777777aaaad665556daaaaaaaaaaaaaaaa86555aaaaaaa
aa7aad6666aa7aaaaaaaaaaaaad6655aaaaaaaaaaaaa6665aaaaaaaaaaaaaaaaaaaaaddddaa8877aaa77777aaaaddd4555dddaaaaaaaaaaaaaaa8d6666aa555a
a7aaaaddd6aaa7aaaaaaaaaaaddd4d66aaaaaaaaaaaddd4d6aaaaaaaaaaaaaaaaaaaad66000ff8aaa777777aaaaa44455544aaaaaaaaaaaaaaaa8addd6aa566a
7aad6655aaaaaaaaaaaaaaaaaa444dd6faaaaaaaaaaa44fd66aaaaaaaaaaaaaaaaaadd6dd0fffaaaa777777aaaaaff5555ffaaaaaaaaaaaaaaad6655aa7a566a
7addd4d66faaaaaaaaaaaaaaafff5ddffaaaaaaaaaaa5fffd60aaaaaaaaaaaaaaaaaa44fffffaaaaa777777aaaaaaf5555faaaaaaaaa7aaaaaddd4d66770566a
77a444d66faaaaaaaaaaaaaaaffaadfffaaaaaaaaaaaaafffd0aaaaaaaaaaaaaaaaaaa4fffaaaaaa777777aaaaaaaa5555aaaaaaaaaa7aaaaaa444dd7770566a
777ff5dd6faaaaaaaaaa7aaaffaaffffaaaaaaaaaaaaaa5fff00aaaaaaaaaaaaaaaaaa55daaaaaaa777777aaaaaaaa4444aaaaaaaaaaaaaaaaaff5d777005d6a
a777f55ddfaaaaaaaaa7aaaafffffff4aaaaaaaaaaaaaa442ff8aaaaaaaaaaaaaaaaaa555aaaaaa7777777aaaaaaaa5555aaaaaaaaaaaaaaaaaff5777aaa5d6a
aa777855ffaaaaaaaaaaaaaffffff555aaaaaaaaaaaaa5555ff87aaaaaaaaaaaaaaaaa444aaaaaa777777aaaaaaaaa5555aaaaaaaaaaaaaaaaaff887aaaa5dda
aaa78ffffaaaaaaaa7aaaa888ffa0555d6aaaaaa7aaaa555558877aaaaaaaaaaaaaaaa5555aaaa777777aaaaaaaaa555500aaaaaaaaaaaaaaaaafff8aaaaa5da
aaaa8fff0aaaaaaaa7aaaa7778aa00554d6aaaaaaaaaa0055557777aaaaaaaaaaaaaaa55555aa777777aaaaaaaaaa555000aaaaaaaaaaaaaaaaa2ff50aaaaa5a
aaaa5552200aaaaaaaaaaa777aaa000455aaaaaaaaaaa000a5557777aaaaaaaaaaaaaa0555d6a7777aaaaaaaaaaaa6440000aaaaaaaaaaaaaaa25555000aaaaa
aaaa4550000aaaaa7aaaa777aaaaa0555aaaaaaaa7aaa000aa4d67777aaaaaaaaaaaa000044d777aaaaaaaaaaaaaad55a000aaaaaaaaaaaaaaaa4550000aaaaa
a555546aa000aaaa7aaa7777aaaaa555aaaaaaaaaa7aa000a55daa7777aaaaaaaaaa0000aa477aaaaaaaaaaaaaaa555aa000aaaaaaaaaaaaa555546aa000aaaa
55555d6aa000aaaa77a7777aaaaa555aaaaaaaaaaaaa0000555aa7777777aaaaaaa0000aaa75aaaaaaaaaaaaaaaa555aaa000aaaaaaaaaaa55555d6aa000aaaa
55aaaaaaaa000aaaa77777aaaaaa0555aaaaaaaaaaaa07777777777777777aaaaa000aa7aa555aaaaaaaaaaaaaaa555aaa000aaaaaaaaaaa55aaaaaaaa000aaa
555aaaaaaa0000aaaa777aaaaaaa000aaaaaaaaaaaaa0000777777777777aaaaaa0000aaaa5555aaaaaaaaaaaaaaaa5aa0000aaaaaaaaaaa555aaaaaaa0000aa
a88a88aa5555555aa33a33aaa777777aaeeeeeeaa888888aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa6a7aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
8888888a5666665a3333333aa777777aaeeeeeeaa888888aaaaaaaaa6a7aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa6a7aaaaaaaaaaaaaaaaaaaaaaaaaa6a7aaaaaa
8e88888a56ddd65a3b33333aaa7777aaaaeeeeaaaa8888aaaaaaaaaaa6a7aaaaaa7aaaaaa0aaaaaaaaaaaaabbbb77aaaaaaaa6aa7aaaaaaaaaaaaaaa6a7aaaaa
8e88888a56ddd65a3b33333aaa7777aaaaeeeeaaaa8888aaaaaaaabbbb77aaaaaa76aaa000aaaaa3aaaaaabbbb776aaaaaaaaa6aa7aaaaaaaaaaabbbb77aaaaa
a8e888aaa56d65aaa3b333aaaaa77aaaaaaeeaaaaaa88aaaaaaaabbbb776aaaa0ab330000aaaa33daaaaaabb8b66aaaaaaaabbbb77aaaaaaaaaabbbb776aaaaa
aa888aaaaa565aaaaa333aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabbbb66aaaaa00b3333333333ddaaaaabbb8bb55aaaaaaabbbb776aaaaaaaaaabb8b66aaaaaa
aaa8aaaaaaa5aaaaaaa3aaaaaaa77aaaaaaeeaaaaaa88aaaaaaaab0bb55aaaa00b33ddddddddddaaaaab0bbbbb355aa0aaabb8b66aaaaaa0aabbb8bb55aaaaa0
aaaaaaaaaaaaaaaaaaaaaaaaaaa77aaaaaaeeaaaaaa88aaaaaabbb0bb35aaaa003dd33dddddddaaaaaabbb3b33535aa0abbb8bb55aaaaaa0ab0bbbbb355aaaa0
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaab0bbb33535a000b3dddd3dddddaaaaaaaa33aa33355500b0bbbbb355555000abbbbb3353555000
aaaaaaaaaaaaaaaaaaa8aaaaaaaaaaaaaaaeaaaaaaaaaaaaaabbb333535555333ddddd3ddddaaaaaaaaaaaaaa3335333bbbbb33535355533aa33333535555533
aaaaaaaaaaaaaaaaaa8aaaaaaaaaaaaaaaeaaaaaaaaaaaaaaaa333a335353553ddddddd3ddaaaaaaaaaaaaaaa3335553aaaae33355553553aaa333aa53553553
aaaaaaaaaaaaaaaaa8aa666aaaaaaaaaaeaaeeeaaaaaaaaaaaaaaaaa3355bbb3ddddddd3daaaaaaaaaaaaaaaa355bbb3aeaee3353535bbb3aaaaaaaaa335bbb3
aaaaaaaaaaaaaaaaa8d6566aaaaaaaaaaeee8eeaaaaaaaaaaaaaaaaaa33bbb3b5d00aaa6aaaaaaaaaaaaaaaaaa3bbb3baaeea33aa33bb33baaaaaaaaa33bb33b
aaaaa677aaaaaaaaa8dd566aaaaaaaaaaeee8eeaaaaaaaaaaaaaaaaaa3bbb333500000aaaaaaaaaaaaaaaaaaaabbb333aaaa33aaa3bbb333aaaaaaaaaabbb333
aaaa67777aaaaaaaaa9dddaaaaaa0aaaaaeeeeaaaaaa8aaaaaaaaaaaaabbb333550000aaaaaaaaaaaaaaaaaaaabbb333aaaaaaaaaabbb333aaaaaaaaaabbb333
aaaa67666aaaaaaaaaaddd5aaaa00aaaaaaeeeeaaaa88aaaaaaaaaaaaabb333555000aaaaaaaaaaaaaaaaaaaaabb3335aaaaaaaaaabb3335aaaaaaaaaabb3335
aaaa677777aa777aaa666550000000aaaaeeeee8888888aaaaaaaaaaab33333555500aaaaaaaaaaa55500aaaaaaaaaaa55500aaaaaaaaaaa55500aaaaaaaaaaa
aaaa6a7777aa777aaddd4d660000aaaaaeeeeeee8888aaaaaaaaabbbb33333553350aaaaaaaaaaaa3350aaaaaaaaaaaa3350aaaaaaaaaaaa3350aaaaaaaaaaaa
aaa77777aa7a777aaa444d66aaaaaaaaaaeeeeeeaaaaaaaaaaabbbbb333335535335aaaaaaaaaaaa5335aaaaaaaaaaaa5335aaaaaaaaaaaa5335aaaaaaaaaaaa
aa7777777776777aaaaffdd6aaaaaaaaaaaeeeeeaaaaaaaaabbbb33333aab3353333aaaaaaaaaaaa3333aaaaaaaaaaaa3333aaaaaaaaaaaa3333aaaaaaaaaaaa
aaa777777776777aaaaaffddafaaaaaaaaaaeeeeaeaaaaaaa76b3aaaaaaab33335335aaaaaaaaaaa35335aaaaaaaaaaa35335aaaaaaaaaaa35335aaaaaaaaaaa
aaa777777766777aaaaa5fffffaaaaaaaaaaeeeeeeaaaaaaa763aaaaaaaabbbb33333aaaaaaaa33a33333aaaaaaaaaaa33333aaaaaaaaaaa33333aaaaaaaaaaa
aaa777777aaa777aaaa5444ffffaaaaaaaaeeeeeeeeaaaaaa76aaaaaaaaabbb3b33333aaaaaaaa33b33333aaaaaaaaaab333333aaaaaaaaab33333333333aaaa
aaa77777aaaa777aaaa555555aaaaaaaaaaeeeeeeaaaaaaaaa76aaaaaaabbb3333333333aaaaaa333333333aaaaaaaaa3533333333aaaaaa335333333333333a
aaaa7777aaaaa77aaaaa55555d6aaaaaaaaaeeeeeeeaaaaaaaaaaaaaaabbb333353333333aaaa33335333333aaaaaaaa353333333333aaaa3533333333333333
aaaa77776aaaaa7aaaaaa5554ddaaaaaaaaaaeeeeeeaaaaaaaaaaaaaabbbb333355333333333333a355333333aaaaaaa3553333333333aaa3553333333333333
aaaa7777666aaaaaaaaaaaa445daaaaaaaaaaaaeeeeaaaaaaaaaaaaaabbb3333555533333333333a5555333333aaaaaa55553333553333aa5555333355533333
aaaa7776666aaaaaaaaaaa5550aaaaaaaaaaaaeee8aaaaaaaaaaaaaaabbb333300005535333333aa00005533333aaaaa00005555a55333aa00005535aa55333a
a777777aa666aaaaaaaaa555000aaaaaaaaaaeee888aaaaaaaaaaaaaab33333aa000000aaaaaaaaaa3000053333aaaaaa000000aa55333aaa0000000a553333a
7777777aa666aaaaaaaaa555550aaaaaaaaaaeeeee8aaaaaaaaaaaaaabb333aaaa00000aaaaaaaaa3a000055333aaaaaaa03000a55333aaaaa000003a333aaaa
77aaaaaaaa666aaaaaaaaaaaa000aaaaaaaaaaaaa888aaaaaaaaaaaabb33aaaaaaa00000aaaaaaaa33333333333aaaaaaaa033333333aaaaaaa00000333aaaaa
777aaaaaaa6666aaaaaaaaaaa0000aaaaaaaaaaaa8888aaaaaaaa7bbb3336aaaaaa000000aaaaaaa3333333333aaaaaaaaa0003333aaaaaaaaa000000aaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaa55666666aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaccaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaacaaaa
aa7aaaa0aaaaaaaaaaaaabbb656dddd6aaaaaaa6aaa7aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaccaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaacaaacc
aa76aa00aaaaaa3aaa7bbbbb65ddddddaaaaaaaa6aaa7aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaccaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaccccaaaaaaaaa
0ab33000aaaaa33aa763bb33d5ddddddaaaaaabbbba77aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaacccaaaaaaaaaaaaaaaaaaaaaacccaacaaaaaacccccaaaaaacaa
0bb3333333333ddaa666333ad5ddddddaaaaabbbbb766aaaaaaaaaaaaaaaaaaaaaaaaaaaacaaacccaaaaaaaaccaaaaaaaaaaaaccaaaaaaaaaccccaacaaaaacaa
0333ddddddddddaaa66333aa55555555aaaaabb0bb66aaaaaaaaaaaaaaaacaaaaaaaaaaacaaacccaaaaaaaaaaccaaaaaaaaacacaaaaaaaaaacccaaaaaaaaccaa
b3dd33dddddddaaaa6aaaaaa66665666aaaaab0cc55aaaa0aaaaaaaaacaaaaaaaaaaaaaacaacccaaaaaaaaaacccaaaaaaaaaaaaaaaaaaaaaccccaaaaaaaacaaa
bddddd3dddddaaaaaaaaaaaaddd656ddaaaabbbbb35aaaa0aaaaaaaccaaaaaaaaaaaaaaaaccccaaaaaaaaaacaaaaaaaaaccacaaaaaaaaaaac7caaaaaaaaacaaa
3dddddd3dddaaaaaaaa7bbbaddd55dddaaabb0b33535a000aaaaaaccaaaaaaaaaaaaaaaacccccaaaaaaaaaaaaaaaaaaaccaaaaaaaaaaaaaacccaaaaaaaaccaaa
ddddddd3ddaaaaaaaa763bbbddd56dddaaabbb3353555533aaaaacccaaaaaaaaaaaaaaaccc7ccaaaaaaaaaaaaaaaaaacccaaaaaaaaaaaaaac7ccaaaacaaccaac
dddddddd3aaaaaaaaa66633bddd5ddddaaaab33a35353553aaaacccaaaaaaaaaaaaaaaccccccaaaaaaaaaaaaaaaaaaccccaaaaaaaaaaaaaac7ccaaacaaaccaaa
5dddaaaa6aaaaaaaaa663333ddd5ddddaaaaaaaa3355bbb3aaaacccaaaaaaaaaaaaaaccc7cccaaaaaaacccaaaaaaaccccaaaaaaaaaaaaaaac7ccccccaaacccca
5000aaaaaaaaaaaaaa6aaa33ddd5ddddaaaaaaaaa33bbb3baaaaccccaaaaaaaaaaaaccc7ccccaaaaaacccaaaaaaaccc7caaaaaaaaaaaaaaac7777ccaaaacccca
500000aaaaaaaaaaaaaaaaaaddd5ddddaaaaaaaaa3bbb333aaaaccccaaaaaaaaaaaccc7ccccaaaaaaaccaaaaaaaccccccaaaaaaaaaaaaaaacc77cccaaaacccca
550000aaaaaaaaaaaaaaaaaaddd5ddd5aaaaaaaaaabbb333aaaacccccaaaaaaaaccccc7ccccaaaaaacccaaaaacccc7ccaaaaaaaaaaaaaaaaacccccaaaaaaacca
55000aaaaaaaaaaaaaaaaaaa55555555aaaaaaaaaabb3335aaaacccccaaaaaacccccc7cccccaaaaaaccaaaaaccccc7ccaaacccaaaaaaaaaaaaaaaaaaaaaaaaaa
55500aaaaaaaaaaa55500aaaaaaaaaaa55500aaaaaaaaaaaaaaacccccccccccccccc77cccccaaaaaaccaaaaccccc7cccaaccaaaaaaaaaaaaaaaaaaaaaaaaaaca
3350aaaaaaaaaaaa3350aaaaaaaaaaaa3350aaaaaaaaaaaaaaacccccccccccccccc77ccccccaaaaaacccccccccc77c7caaaaaaaaaaaaaaaaaaacccaaaaaaaaaa
5335aaaaaaaaaaaa5335aaaaaaaaaaaa5335aaaaaaaaaaaaaaccacccccc7cccccc77cc7ccccaacaaaccccccc7777cc7caaaaaaaccccaaaaaaaacccccaaaacaaa
3333aaaaaaaaaaaa3333aaaaaaaaaaaa3333aaaaaaaaaaaaaaccacccc77cccccc77cc7cccccaaaaaaacccccc777cccccaaaaaacaaaccaaaaaaacaaacaaaaaaaa
35335aaaaaaaaaaa35335aaaaaaaaaaa35335aaaaaaaaaaaacccccccc77cccc7777c7cccccccaacaaacccccc7ccccacccaaaaaaaaaccaaaaaaca7aaaaacaacaa
33333aaaaaaaaaaa33333aaaaaaaaaaa33333aaaaaaaaaaaaccccccc777777777ccc7cc7ccccccaaaaacccccccccaccccaaaaaaaaacaaaaaaaaaaaaaaaaaaaaa
b33333aaaaaaaaaab33333aaaaaaaaaab33333aaaaa3aaaaaccccccc77777777cccc777cccccccaaaaacccccccccacccccaaaaaaacaaaaaaaacaaaaaaaaaaaaa
33533333333aaaaa35333333aaaaaaaa33333333aaaa333aaaccccccc7777ccccccc777ccccaaaaaaaaaccccaaaacccccccaaaaaaaaaaaaaaaaa7aaaaaaaaaaa
35333333333333aa353333333aa3aaaa353333333aaaa3335555a55a11111991199111111111111100000000bbbbbbbb333333333bbb3bbbaaaaaaaaaaaaacaa
355333333333333a3553333333a3333a3553333333333533599a995a11199991199991111999999100000000bbbbbbbb33333333b333b333aaaaaaaaaaaaaaaa
555533335553333a555533333335533a5555333333333333595a595a11999991199999111999999100000000bbbbbbbb333333333b3b3b3baaaaaa7aaaacaaaa
00005535a335333a000055353333333a000055353333333a5955a95a11999991199999111999999100000000bbbbbbbb3333333333333333aaaaaaaaaaacaaaa
a000000aaa3333aaa00000033333333aa000000aaa3333aaa595a5aa19999991199999911999999100000000bbbbbbbb3333333333333333aaaaaaaaaaacaaaa
aa00000aaaaaaaaaaa00000aa33333aaaa00000aaaaaaaaaaa5a5aaa19999991199999911999999100000000bbbbbbbb3333333333333333aaaaaaaaaaacca7a
aaa00000aaaaaaaaaaa00000aaaaaaaaaaa00000aaaaaaaaaa5a5aaa19999991199999911999999100000000bbbbbbbb3333333333333333aaaaaaaaaaacccaa
aaa000000aaaaaaaaaa000000aaaaaaaaaa000000aaaaaaaaaaaaaaa11111111111111111111111100000000bbbbbbbb3333333333333333aaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaabb5665bbaaaaaaa33aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa0000000000000000
aaaaaaaaaaaaaaaaaaaaaaaabbb5665baaaaaa3333aaaaaaaa888aaaaa888aaa88aaa88aa8888aaaaaaaaaaa99aaaaaaaaaaaaaaaaa77aaa0000000000000000
aaaaaaaaaaaaaaaaaaaaaaaabbbb55bbaaaaa333333aaaaaaa8888a8a88888aa88aaa88a888888aaaaaaa999aaaaaaaaaaa777aaaa7767aa0000000000000000
aaaaaaaaaaaaaaaaaaaaaaaabbbbbbbbaaaa33333333aaaaa88aa88a888a888a88aaa88a88aaaaaaaaaa99999aaaaaaaaa77777a7776666a0000000000000000
aaaaaaaaaaa8aaaaaaaaaaaabbbbbbbbaaa3333333333aaaa88aaaa988aaa88a88aaa88a88aaaaaaaaa9af099aaaaaaaaa77667aaaaaaaaa0000000000000000
aaaaaaaaaa898aaaaaaaaaaabbbbbbbbaa333333333333aaa888aa2288aaa88a888a888a88888aaaaaaaaf0f9aaaaaaaaaa76667aaaaaaaa0000000000000000
ababaabaaab8aaaaaaa55aaabbbbbbbbaaaaa333333aaaaaaa8888228888888a888a888a88888aaaaff0aff89aaaaaaa77776666aaaaa66a0000000000000000
baababaa7aabbaaaaa5665a5bbbbbbbbaaaa33333333aaaaaaaa88828888888aa88a88aa88aaaaaaaffe0a5555aaaaaaaaaaaaaaaaaaaaaa0000000000000000
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa3333333333aaa8aaaa88288aaa88aa88888aa88aaaaaaaaaee05e2aa5aaaaaaaaaaaaaaaaaaaa0000000000000000
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa333333333333aaa888888288aaa88aa88888aa888888aaaaaeeee22aaaaaa5aaaaaaaaaaaaaaaa0000000000000000
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa33333333333333aaa888a2288aaa88aaa888aaaa8888aaaaaaae22255aaa5aaaaaaaaaaaaaaaaaa0000000000000000
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa3333333333aaaaaaaaa222aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaddd6aaaaaaaaaaaaaaaaaaaaa0000000000000000
a988aaaaaaaaaaaaaaaaaa9a999aaaaaaa333333333333aaaaaaaa282aaaaaaaaaaaaaaaaaaaaaaaaaaaaaadd66aaaaaaaaaaaaaaaaaaaaa0000000000000000
a668aaaaaaaa6698aaaaa9949999aaaaa33333333333333aaaaaa88e88aaaaaaaaaaaaaaaaaaaaaaaaaaaaa7766000aaaaaaaaaaaaaaaaaa0000000000000000
66668aaaaaaa5668aaaaa9499499aaaa3333333333333333aaa888888888aaaaaaaaaaaaaaaaaaaaaaaaaa777666666aaaaaaaaaaaaaaaaa0000000000000000
5666aaaaaaa5668aaaaaa9494949aaaaaaaaaa3333aaaaaaaaaaa76767aaaa7a7aaa777aaaaaaaaaaaaaaa7777666666aaaaa896aaaaaaaa0000000000000000
566aaaaaaaa4686aaaaaa9499499aaaa3aa6aaaddaaa6aa3aaaaa77677aaaa7a7aaa7aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa86666aaaaaaa0000000000000000
a466aaaaaa74aaaaaaaaaa94999aaaaa33666adddda66633aaaaa77677aaaa777aaa77aaaaaaaaaaaaaaaaaa99aaaaaaaaaa86555aa555aa0000000000000000
7644daaaa77766aaaaa9a999a9a999aa33366dddddd66333aaaaa77677aaaa7a7aaa7aaaaaaaaaaaaaaaa999aaaaaaaaaaaa8d66667566aa0000000000000000
7644daaaa77664daaa9949999949999a3333dddddddd3333aa11111677aaaa7a7aaa777aaaaaaaaaaaaa99999aaaaaaaaaad66cdd77566aa0000000000000000
77ddaaaaa776644aaa9499499499499a33333dddddd33333aaa1177177aaaaaaaaaaaaaaaaaaaaaaaaa9aff99aaaaaaaaaddd4d6777566ca0000000000000000
776aaaaaa777ddaaaa9494949494949a333333dddd333333aaa1177717aaaaaaaaaaaaaaaaaaaaaaaaaaaf0f9aaaaaaaaaa444d77705d6ca0000000000000000
776aaaaaa776aaaaaa9499499499499a3336dddddddd6333aaa1177717aaaaaaaaaaaaaaaaaaaaaaaaaaaff89aaaaaaaaaaff5777005d6cc0000000000000000
766aaaaaa776aaaaaaa94999a94999aa3333dddddddd3333aaa1177717aaaa1aaaaaaaaaaaaaaaaaaaaaaa5555aaaaaaaaaf8777aaa5cccc0000000000000000
666aaaaaa666aaaaaaaaaaaaaaaaaaaa33333dddddd33333aaa1177171a11aaa1a1aaa111aa11aaaaa00005e2aa5aaaaaaaff888acacdcca0000000000000000
666aaaaaaa4aaaaaaaaaaa777aaaaaaa333333dddd333333a1a11116711a1a1a11a1a1aaaa1aa1aaaffeeeee2aaaaaa5aaafffffaaaa5daa0000000000000000
a4aaaaaaaa4aaaaaaaaaa77777777aaa3333333dd33333331aa1177671aaaa1a1aa1a1aaaa111aaaaffe2e2255aaa5aaaaaa2ff50aaaa5aa0000000000000000
a4aaaaaaaa4aaaaaaaaa7777766677aa33333dddddd333331aa1177671aaaa1a1aa1a1aaaa1aaaaaaaaaaaaddd6aaaaaaaaa555500aacaaa0000000000000000
a4aaaaaaa4aaaaaaaa7777776666677a333333dddd333333a111177671aaaa1a1aa1aa111aa111aaaaaaaaadd66aaaaaaaaa455000aaaaaa0000000000000000
a4aaaaaaa4aaaaaaa7777776666666773333333dd3333333aaaaa77777aaaaaaaaaaaaaaaaaaaaaaaaaaaaa7766000aa5555546a00aaaaaa0000000000000000
a4aaaaaaa4aaaaaa77767666666666673333333333333333aaaaaa777aaaaaaaaaaaaaaaaaaaaaaaaaaaaa777666666a5555566a000aaaaa0000000000000000
a4aaaaaaa4aaaaaaaaaaaaaaaaaaaaaa33666adddda66633aaaaaaa7aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa7777666666555aaaaa0000aaaa0000000000000000
__map__
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f010101b7b801010101b7b801010d0100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01010e01b9b901010101b9b9010f010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f0e0101b9b901010101b9b9010e0f0100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01010d01b9b901010101b9b901010e0100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010fb9b90101010db9b9010d010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01010101b9b901010101b9b901010101e5e4e5c5000000000000d2d300c4e4e5e4e500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010101010101010101010101010c0101f5f4f5d5c0c1c0c2c0c0e2e3c1d4f4f5f4f500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06070607060607070606070706060706bbbbbbbbbbbbbbc3bbbbbbbbbbbbbbbbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05070705050705070505070505070505bdbdbdbdbdbdbdbdbdbdbdbdbdbdbdbdbdbd00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04040404040404040404040404040404bcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0303030303030303030303030303030300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
00010000112500a250042500315001150000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010d00001d650206501d6501f6501b6501f6501c6501e6501c6401c63019620106100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000500002a550275502d5502a5502e5502c550305502e550325500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000400000e7200c730107400f7501375012750177501a7501d7500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000002f0502f020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000000c0530000000000000003c6550000000000000000c0530000000000000003c6550000000000000000c053000000c053000003c6550000000000000000c0530000000000000003c655000000000000000
011000000274002720027100274002720027100274002720027100274002720027100274002710027400271002740027200271002740027200271002740027200271002740027200271002740027200274002720
0110000002740027200e71002740027200e71002740027200e71002740027200e710027400e710027400e71002740027200e71002740027200e71002740027200e71002740027200e71002740027200274002720
01100000000000000002740027200e71002740027200e710027400272002740027200271002740027200e7100274002720027400272002740027200e71002740027200e710027400272002740027200274002720
011000002654026520325132654026520325132654026520325102654026525000002654032513265403251026540265203251326540265203251326540265202654026520325132654026520325132654026520
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002452025520265302753028540295402a5502b550
011000001f54026520325132654026520325132654026520325102654026525000001f54032513265403251026540265203251326540265203251326540265202654026520325132654026520325131f52000000
010f00001c5441c5201a5441a5201c5441c5201c5101c5101f5441f5202354423520235102351000000000000000000000215442152021510215101f5441f52021544215201f5441f52000000000000000000000
011000000e7430000002743000000e7430000002743000000e7430000002743000000e7430000002743000000e7430000002743000000e7430000002743000000e7430000002743000000e743000000274300000
011000001c544005041a544005041c544005041f54400504235440050421544005041f5440050421544005041f544005041c544005041a544005041c544005041f5440050421544005041f544005041f54400304
00030000376503a65035650306502d3502b3500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
00 01424344
01 05060a44
00 05070944
00 05080944
00 05070b44
02 05080944
03 0d0e4344

