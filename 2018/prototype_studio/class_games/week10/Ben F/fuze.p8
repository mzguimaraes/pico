pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

--make it through different verses (universe,multiverse,locoverse)
--stars change color
--by collecting blue things you level up your ship
--ruby,sapphire,emerald, etc
--leveling up your ship makes it faster
--running into something decreases your ship level
--you have to spam z to revive yourself when you are at null
--the final ship level is called "peak"
--you win the game if you maintain peak for 1 minute
--if you get hit while in "null" you lose
--add cool particle effects
-- add sound effects
timetilltier = rnd(400)
timetillmeteor = rnd(timedifficulty)
overalltime = 0
tiertext = "sapphire"
tiercolor = 12
tier = 1
spacelevel = "universe"
spacex = 5000
spacey = 5000
spacetimer = 30
difficulty = 1
timedifficulty = 100

tierup={x=-500,y=100,vx=0,
vy=0,rx=0,ry=0,s=1, t=0,
grounded=false,kick=0,alive=true}

meteor1={x=-500,y=100,vx=0,
vy=0,rx=0,ry=0,s=1, t=0,
grounded=false,kick=0,alive=true}

actor = {} --all actors in world

fps = 30



function player(x, y)
 a={}
 a.x = x
 a.y = y
 a.dx = 0
 a.dy = 0

 a.spr = tier
 a.shadow = 500

 a.ox = 0
 a.oy = 0
 a.tx = x
 a.ty = y
 a.tduration = 0
 a.tcount = 0
 
 add(actor,a)
 
 return a
end

function _init()
  srand(42)
  
 -- make a bubble
 bubble = player(60,60)
 
 	timer = {}
	timer.t = 0
	timer.c = 0
	
	star = {}
	star.start = 0
	star.num = 120

	star_array = {}
	gen_stars()
end

function _update()

timetilltier = timetilltier - 1
timetillmeteor = timetillmeteor - 1
tierup.x = tierup.x - 1
overalltime = overalltime + 1
meteor1.x = meteor1.x - difficulty

if timetilltier <= flr(0) then

tierup.x = 130
tierup.y = rnd(120)
timetilltier = rnd(400)

end

spacetimer = spacetimer - 1

if spacetimer <= 0 then
spacex = 5000
spacey = 5000
end

if tier == 2 then
tiertext = "ruby"
tiercolor = 8

end

if tier == 3 then
tiertext = "emerald"
tiercolor = 11

end

if tier == 4 then
tiertext = "citrine"
tiercolor = 10

end

if tier == 5 then
tiertext = "topaz"
tiercolor = 14

end

if tier == 6 then
tiertext = "amethyst"
tiercolor = 2

end

if tier >= 17 then
tiertext = "null"
tiercolor = 6

end


if tier == 7 then
tiertext = "amber"
tiercolor = 9

end


if tier == 8 then
tiertext = "champagne"
tiercolor = 15

end


if tier == 9 then
tiertext = "peak"
tiercolor = 7

end

if overalltime == 500 then

spacex = 50
spacey = 50
spacelevel = "multiverse"
spacetimer = 50
color_flash = 1

difficulty = difficulty + 1
timedifficulty = timedifficulty - 5
end

if overalltime == 1500 then

spacex = 50
spacey = 50
spacelevel = "oververse"
spacetimer = 50
color_flash = 2

difficulty = difficulty + 1
timedifficulty = timedifficulty - 5
end

if overalltime == 3000 then



spacex = 50
spacey = 50
spacelevel = "uberverse"
spacetimer = 50
color_flash = 3

difficulty = difficulty + 1
timedifficulty = timedifficulty - 5
end

if overalltime == 4000 then



spacex = 50
spacey = 50
spacelevel = "hyperverse"
spacetimer = 50
color_flash = 4

difficulty = difficulty + 1
timedifficulty = timedifficulty - 5
end


if overalltime == 5000 then


spacex = 50
spacey = 50
spacelevel = "omniverse"
spacetimer = 50
color_flash = 5

difficulty = difficulty + 1
timedifficulty = timedifficulty - 5
end


if overalltime == 6500 then


spacex = 50
spacey = 50
spacelevel = "hyperverse"
spacetimer = 50
color_flash = 6

difficulty = difficulty + 1
timedifficulty = timedifficulty - 5
end

if overalltime == 7500 then


spacex = 50
spacey = 50
spacelevel = "cryptoverse"
spacetimer = 50
color_flash = 7

difficulty = difficulty + 1
timedifficulty = timedifficulty - 5
end

if overalltime == 8500 then


spacex = 50
spacey = 50
spacelevel = "hexiverse"
spacetimer = 50
color_flash = 8

difficulty = difficulty + 1
timedifficulty = timedifficulty - 5
end

if overalltime == 10000 then


spacex = 50
spacey = 50
spacelevel = "versiverse"
spacetimer = 50
color_flash = 9

difficulty = difficulty + 1
timedifficulty = timedifficulty - 5
end

if overalltime == 12000 then


spacex = 50
spacey = 50
spacelevel = "kyberverse"
spacetimer = 50
color_flash = 10

difficulty = difficulty + 1
timedifficulty = timedifficulty - 5
end

if overalltime == 13000 then

spacex = 50
spacey = 50
spacelevel = "helioverse"
spacetimer = 50
color_flash = 11

difficulty = difficulty + 1
timedifficulty = timedifficulty - 5
end

if overalltime == 16000 then


spacex = 50
spacey = 50
spacelevel = "nitroverse"
spacetimer = 50
color_flash = 12

difficulty = difficulty + 1
timedifficulty = timedifficulty - 5
end

if timetillmeteor <= flr(0) and meteor1.x < 0 then

meteor1.x = 130
meteor1.y = rnd(120)
timetillmeteor = rnd(timedifficulty)

end

if tierup.x < 0 then


end

if tier >= 17 and tier <= 26 and btnp(4) then
tier = tier + 0.5
a.spr = flr(tier)
end

if tier >= 26 and btnp(4) then
tier = 1
a.spr = flr(tier)
end

if tier > 17 then
//tier = tier - 0.7
a.spr = flr(tier)
end


//tier up
--if a.x ==flr( tierup.x) and a.y ==flr( tierup.y) then
--tier = tier + 1
--tierup.y = 1000
--a.spr = tier
--end

if a.x >= tierup.x - 6 and
 a.x < tierup.x + 6
  and a.y >= tierup.y - 6 and a.y < tierup.y + 6 then
tier = tier + 1
tierup.y = 1000
a.spr = tier
 add(actor,a)
end


//hit meteor


if a.x >= meteor1.x - 10 and
 a.x < meteor1.x + 10
  and a.y >= meteor1.y - 10 and a.y < meteor1.y + 10 and tier > 1 and tier < 17 then

meteor1.y = 1000
tier = tier - 1
a.spr = tier

del(actor,a)
end


if a.x >= meteor1.x - 10 and
 a.x < meteor1.x + 10
  and a.y >= meteor1.y - 10 and a.y < meteor1.y + 10 and tier >= 16 then
//camera(150,0)
stop()
end


if a.x >= meteor1.x - 10 and
 a.x < meteor1.x + 10
  and a.y >= meteor1.y - 10 and a.y < meteor1.y + 10 and tier == 1 then

meteor1.y = 1000
tier = tier - 1
a.spr = tier

end

if tier == 0 then

tier = 17
a.spr = tier
end


  if btn(4) and bubble.tduration == 0 and tier > 0 and tier < 17 then
    set_tween_for_actor(bubble, random(15)*8, random(15)*8, 0.5)
  end
 foreach(actor, move_actor)
end

function _draw()
 cls()
  print(spacelevel,spacex,spacey,7)
 foreach(actor, draw_actor)
 star_ani()
	rectfill(0, 110, 128, 128, 0)
	spr(35,tierup.x,tierup.y) 
	spr(38,meteor1.x,meteor1.y,2,2)
   // print(timetilltier,5,50,50)
  // print(tier,3,100,100)
  print("tier: "..tiertext,0,0,tiercolor)
   print("game over",200,200,tiercolor)
 // print(spacelevel,spacex,spacey,7)
  
 if (bubble.tduration != 0) then
  
 else

 end
end

function random(n)
  return flr(rnd(n))
end

function draw_actor(a)
 local sx = a.x
 local sy = a.y
 local tx = a.tx
 local ty = a.ty

 if (tx > 0 or ty > 0) spr(a.shadow, tx, ty)

 spr(a.spr, sx, sy)
end

function set_tween_for_actor(a, x,y, d)
  a.tx = x
  a.ty = y
  a.tduration = flr(d * fps)
  a.dx = (a.tx - a.x)
  a.dy = (a.ty - a.y)

  a.ox = a.x
  a.oy = a.y
end

function move_actor(a)
 if (flr(a.tduration) > 0) then
   local easing = 1

   a.x = ease_in_out_cubic(a.tcount, a.ox, a.dx, a.tduration)
   a.y = ease_in_out_cubic(a.tcount, a.oy, a.dy, a.tduration)
 
   a.tcount += 1
 
   if (a.tcount >= a.tduration) then
     a.dx = 0
     a.dy = 0
     a.ox = 0
     a.oy = 0
     a.tx = 0
     a.ty = 0
     a.tduration = 0
     a.tcount = 0
   end
   
 else
   a.x += a.dx
   a.y += a.dy
 end
end

function pow(a,b)
  return a ^ b
end

sqrt0 = sqrt
function sqrt(n)
  if (n <= 0) return 0
  if (n >= 32761) return 181.0
  return sqrt0(n)
end

-- order of steepness
-- linear, sine, quad, cubic, quartic, quintic, expo, circ

function linear(t,b,c,d)  -- simple linear tweening - no easing, no acceleration
  return c*t/d + b
end


function ease_in_quad(t,b,c,d)  -- quadratic easing in - accelerating from zero velocity
  t /= d
  return c*t*t + b
end

function ease_out_quad(t,b,c,d)  -- quadratic easing out - decelerating to zero velocity
  t /= d
  return -c * t*(t-2) + b
end

function ease_in_out_quad(t,b,c,d)  -- quadratic easing in/out - acceleration until halfway, then deceleration
  t /= d/2
  if (t < 1) return c/2*t*t + b
  t -= 1
  return -c/2 * (t*(t-2) - 1) + b
end


function ease_in_cubic(t,b,c,d)  -- cubic easing in - accelerating from zero velocity
  t /= d
  return c*t*t*t + b
end

function ease_out_cubic(t,b,c,d)  -- cubic easing out - decelerating to zero velocity
  t /= d
  t -= 1
  return c*(t*t*t + 1) + b
end

function ease_in_out_cubic(t,b,c,d)  -- cubic easing in/out - acceleration until halfway, then deceleration
  t /= d/2
  if (t < 1) return c/2*t*t*t + b
  t -= 2
  return c/2*(t*t*t + 2) + b
end


function ease_in_quartic(t,b,c,d) -- quartic easing in - accelerating from zero velocity
  t /= d
  return c*t*t*t*t + b
end

function ease_out_quartic(t,b,c,d) -- quartic easing out - decelerating to zero velocity
  t /= d
  t -= 1
  return -c * (t*t*t*t - 1) + b
end

function ease_in_out_quartic(t,b,c,d) -- quartic easing in/out - acceleration until halfway, then deceleration
  t /= d/2
  if (t < 1) return c/2*t*t*t*t + b
  t -= 2
  return -c/2 * (t*t*t*t - 2) + b
end


function ease_in_quintic(t,b,c,d) -- quintic easing in - accelerating from zero velocity
  t /= d
  return c*t*t*t*t*t + b
end

function ease_out_quintic(t,b,c,d) -- quintic easing out - decelerating to zero velocity
  t /= d
  t -= 1
  return c*(t*t*t*t*t + 1) + b
end

function ease_in_out_quintic(t,b,c,d) -- quintic easing in/out - acceleration until halfway, then deceleration
  t /= d/2
  if (t < 1) return c/2*t*t*t*t*t + b
  t -= 2
  return c/2*(t*t*t*t*t + 2) + b
end


--to fix
function ease_in_sine(t,b,c,d) -- sinusoidal easing in - accelerating from zero velocity
  return c * (1 - cos(t/d/4)) + b
end

function ease_out_sine(t,b,c,d) -- sinusoidal easing out - decelerating to zero velocity
  return c * -sin(t/d/4) + b
end

function ease_in_out_sine(t,b,c,d) -- sinusoidal easing in/out - accelerating until halfway, then decelerating
  return c/2 * (1 - cos(t/d/2)) + b
end


--to fix
function ease_in_expo(t,b,c,d) -- exponential easing in - accelerating from zero velocity
  return c * pow(2, 10 * (t/d - 1)) + b
end

--requires higher precision
function ease_out_expo(t,b,c,d) -- exponential easing out - decelerating to zero velocity
  return c * (-pow(2, -10 * t/d) + 1) + b
end

--requires higher precision
function ease_in_out_expo(t,b,c,d) -- exponential easing in/out - accelerating until halfway, then decelerating
  t = t/(d/2)
  if t<1 then
    return c/2*2^(10*(t-1))+b
  end
  t = t-1
  return c/2*(-2^(-10*t)+2)+b
end


function star_ani()
	local x_move = {}
//	local color_flash = 7
	for y = 1, 10 do
	    for x = 1, 10 do
		  x_move = (star_array[y][x]) - timer.t    
		  local y_pos = {}		  
		  	
			if  (x_move > 0) then
				 y_pos = star_array[x][y] + (timer.t / 10)
				x_move = x_move * (x_move / 100)
				
		//		if  (x_move < 130) then
		//			color_flash = 7
		//		end
			if  (x_move > 130) then
				x_move =  200 - (x_move / 2)
					
					color_flash = 5
				end
			end
			
			if  (x_move <0) then
				y_pos = star_array[x][y] - (timer.t / 10)
						x_move =  200 - (x_move * 3)
					
					color_flash = 5
				if  (x_move < 130) then
				//	color_flash = 5
				end
				if  (x_move > -200) then
		
	x_move =  200 - (x_move / 2)
					
					color_flash = 5
				end
			end

			pset(x_move, y_pos,  color_flash)
	    end
	end
//	if timer.t <= 250 then
		timer.t = timer.t + 1
//		end
	if timer.t == 120 then
	timer.t = 0
	//	timer.t =  0
//		gen_stars()
	
			//	x_move =  200 - (x_move / 2)
					
					color_flash = 5
	end
end

function gen_stars()
	for row = 1, star.num do
	    star_array[row] = {}
	
	    for column = 1, star.num do
		    star.rand = rnd(star.num)
			star.rand = flr(star.rand)
			
	        star_array[row][column] = star.rand
	   end
	end
end


__gfx__
0000000000ccc7000088870000bbb70000aaa70000eee70000ddd7000099970000fff70000777700007777000077770000777700007777000077770000000000
000000000c000070080000700b0000700a0000700e0000700d000070090000700f00007007000070070000700700007007000070070000700700007000000000
00700700c000000780000007b0000007a0000007e0000007d000000790000007f000000770000007700000077000000770000007700000077000000700000000
00077000c000000c80000008b000000ba000000ae000000ed000000d90000009f000000f70000007700000077000000770000007700000077000000700000000
000770001000000c200000083000000b9000000a8000000e1000000d400000094000000f70000007700000077000000770000007700000077000000700000000
007007001000000c200000083000000b9000000a8000000e1000000d400000094000000f70000007700000077000000770000007700000077000000700000000
00000000010000c002000080030000b0090000a0080000e0010000d004000090040000f007000070070000700700007007000070070000700700007000000000
000000000011cc00002288000033bb000099aa000088ee000011dd00004499000044ff0000777700007777000077770000777700007777000077770000000000
000000000066670000666700006667000066670000666700006667000066670000c6670000cc670000ccc7000000000000000000000000000000000000000000
000000000600007006000070060000700600007006000070060000700c0000700c0000700c0000700c0000700000000000000000000000000000000000000000
000000006000000760000007600000076000000760000007c0000007c0000007c0000007c0000007c00000070000000000000000000000000000000000000000
0000000060000006600000066000000660000006c0000006c0000006c0000006c0000006c0000006c000000c0000000000000000000000000000000000000000
0000000050000006500000065000000610000006100000061000000610000006100000061000000c1000000c0000000000000000000000000000000000000000
00000000500000065000000610000006100000061000000610000006100000061000000c1000000c1000000c0000000000000000000000000000000000000000
00000000050000600100006001000060010000600100006001000060010000c0010000c0010000c0010000c00000000000000000000000000000000000000000
00000000005566000055660000156600001166000011c6000011cc000011cc000011cc000011cc000011cc000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000006660000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000f569966000000000000000000000000000000000000000000000000000000
000000000000000000000000000c77700000000000000000005550005560000000ff044996000000000000000000000000000000000000000000000000000000
00000000000000000000000000cc677700000000000000000050005fff6000000005005556000000000000000000000000000000000000000000000000000000
0000000000000000000000000015661c00000000000000000555550499f007700000000555555000000000000000000000000000000000000000000000000000
0000000000000000000000000015511c000000000000000005ff550049f567600000f00f5fff0060000000000000000000000000000000000000000000000000
0000000000000000000000000011ccc00000000000000000055555500f056660000f49995f900960000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000005000550005550000f4499955499560000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000059ff055555500000055449955555500000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000005499000005555000005ff555055f000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000004900ff005000000559f05000ff000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000400499000000005990ff5000ff00000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000ff5550f000000000054009ff5500000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000055550000000000540099955ff000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000050000000000005550555fff0000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000f000000000000000000000000000000000000000000000000000000
