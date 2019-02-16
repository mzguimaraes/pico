pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
--eraticate
--by ben fried

day = 0
timeleft = 20
timeset = 20

p1={x=16,y=36,w=8,h=8,vx=0,
vy=0,rx=0,ry=0,s=1,f=false,t=0,
cheesecarry=false,kick=0,alive=true}

rat1={x=300,y=36,w=8,h=8,vx=0,
vy=0,rx=0,ry=0,s=1,f=false,t=0,
eating=false,speed = 0.6, kick=0,alive=true}

rat2={x=300,y=36,w=8,h=8,vx=0,
vy=0,rx=0,ry=0,s=1,f=false,t=0,
eating=false,speed = 0.6, kick=0,alive=true}

ratarrow1={x=0,y=rnd(70) + 30,w=8,h=8,vx=0,
vy=0,rx=0,ry=0,s=37,f=false,t=0,
cheesecarry=false,kick=0,alive=true}

ratarrow2={x=0,y=300 + 30,w=8,h=8,vx=0,
vy=0,rx=0,ry=0,s=37,f=false,t=0,
cheesecarry=false,kick=0,alive=true}




cheese={}
rats={}
spawns={}
sparks={}
gravity = 0.3


sparkcols={1,1,8,8,9,9,10,10,7,7,7}
map_w=16
map_h=16
timeuntilcheese=0
timebetweencheese=200
score=0


 for i=0,100 do  
  add(cheese,{
 x=0,y=0,vx=0,vy=0,rx=0,ry=0,
   grounded=true,t=0	
  })
  add(rats,{
   x=0,y=0,t=0
  })
  add(sparks,{x=0,y=0,life=0,
   vx=0,vy=0}
  )
 end
 
 
 
  --look in the map for spawns
 --if a spawn is found, that's a
 --cheese spawn point
	for col=0,map_w do
	 for row=0,map_h do
	  if mget(col,row)==16 then
	   add(spawns,{x=col*8,
	   y=row*8})
	  end
	 end
	end

function addcheese(x,y)
 for c in all(cheese) do
  --look for a dead bomb
  --and revive it at x,y
  if c.t <=0 then
   c.x=x
   c.y=y
   c.vx=0
   c.vy=0
   c.rx=0
   c.ry=0
  // c.grounded=false
   c.t=flr(rnd(timebetweencheese)
          +timebetweencheese)
   timebetweencheese-=1
   return
  end
 end
end

--all the collision stuff is
--on this tab

--true if p1 touching explosion e


--returns list of bombs in rect
--defined by x1,y1,x2,y2
function overlapcheese(x1,y1,x2,y2)
 local hits={}
 
 for c in all(cheese) do
 
	 if c.t > 0 then
   local touching=true
   --not gonna lie, i googled
   --this overlap test
   if 
   y2<c.y or y1>c.y+8 or
   x2<c.x or x1>c.x+8 then
  touching=false
   end
   if touching then
    add(hits,c) 

   end
  end 
 end
 return hits --list of bombs touched
end

function overlapmap(x,y)
--function returns true if there
--is a tile with flag n that
--overlaps a sprite at x,y

 --first we need to know
 --which cels it is touching
 local minmapx=flr((x+1)/8)
 local maxmapx=flr((x+7)/8)
 local minmapy=flr((y+1)/8)
 local maxmapy=flr((y+7)/8)
 
 --walls have flag 0
 if fget(mget(minmapx,minmapy),0) then
  return true
 elseif fget(mget(minmapx,maxmapy),0) then
  return true
 elseif fget(mget(maxmapx,minmapy),0) then
  return true
 elseif fget(mget(maxmapx,maxmapy),0) then
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

function bouncex(s)
 --reverse bomb velocity on bounce
 s.vx *=-0.7
 s.rx=0
 sfx(3)
end

function _ratarrows()

if day == 0 then

ratarrow1.x = 0
ratarrow1.y = rnd(70) + 30

end

if day == 1 then

ratarrow1.x = 0
ratarrow1.y = rnd(70) + 30

end

end



function _update60()


if rat1.speed < 0.1 and day < 4 then

rat1.x = 500
rat1.speed = 0.6
ratarrow1.y = rnd(70) + 30
score = score + 1
timeleft = timeset

end

if rat1.speed < 0.1 and day == 4 then


rat2.speed = 0
timeleft = timeset

end


if rat1.speed < 0.1 and day > 3 then

rat1.x = 500



end

if rat2.speed < 0.1 and day > 3 then

rat2.x = 500



end

if rat1.speed <0.1 and rat2.speed
< 0.1 and day > 3 then

rat2.speed = 0.6
rat1.speed = 0.6
timeleft = timeset
score = score + 2
ratarrow2.y = rnd(70) + 30
ratarrow1.y = rnd(70) + 30

end

if rat1.eating == false then

rat1.x = rat1.x + rat1.speed

end

if rat2.eating == false then

rat2.x = rat2.x + rat2.speed

end

if day == 0 and timeleft <= 0.02 then

ratarrow1.x = 0

rat1.x = ratarrow1.x
rat1.y = ratarrow1.y

end

if day == 1 and timeleft <= 0.02 then

ratarrow1.x = 0
--ratarrow1.y = rnd(70) + 30

rat1.x = ratarrow1.x
rat1.y = ratarrow1.y
timeset = 15

end

if day == 2 and timeleft <= 0.02 then

ratarrow1.x = 0
--ratarrow1.y = rnd(70) + 30

rat1.x = ratarrow1.x
rat1.y = ratarrow1.y
timeset = 10

end

if day == 3 and timeleft <= 0.02 then

ratarrow1.x = 0
ratarrow2.x = 0
--ratarrow1.y = rnd(70) + 30

rat1.x = ratarrow1.x
rat1.y = ratarrow1.y
rat2.x = ratarrow2.x
rat2.y = ratarrow2.y
timeset = 10

end

if day == 4 and timeleft <= 0.02 then

ratarrow1.x = 0
ratarrow2.x = 0
--ratarrow1.y = rnd(70) + 30

rat1.x = ratarrow1.x
rat1.y = ratarrow1.y
rat2.x = ratarrow2.x
rat2.y = ratarrow2.y
timeset = 10

end

if day == 5 and timeleft <= 0.02 then

ratarrow1.x = 0
ratarrow2.x = 0
--ratarrow1.y = rnd(70) + 30

rat1.x = ratarrow1.x
rat1.y = ratarrow1.y
rat2.x = ratarrow2.x
rat2.y = ratarrow2.y
timeset = 10

end

if day == 6 and timeleft <= 0.02 then

ratarrow1.x = 0
ratarrow2.x = 0
--ratarrow1.y = rnd(70) + 30

rat1.x = ratarrow1.x
rat1.y = ratarrow1.y
rat2.x = ratarrow2.x
rat2.y = ratarrow2.y
timeset = 10

end

if day == 7 and timeleft <= 0.02 then

ratarrow1.x = 0
ratarrow2.x = 0
--ratarrow1.y = rnd(70) + 30

rat1.x = ratarrow1.x
rat1.y = ratarrow1.y
rat2.x = ratarrow2.x
rat2.y = ratarrow2.y
timeset = 8

end

if day == 8 and timeleft <= 0.02 then

ratarrow1.x = 0
ratarrow2.x = 0
--ratarrow1.y = rnd(70) + 30

rat1.x = ratarrow1.x
rat1.y = ratarrow1.y
rat2.x = ratarrow2.x
rat2.y = ratarrow2.y
timeset = 6

end

if day == 9 and timeleft <= 0.02 then

ratarrow1.x = 0
ratarrow2.x = 0
--ratarrow1.y = rnd(70) + 30

rat1.x = ratarrow1.x
rat1.y = ratarrow1.y
rat2.x = ratarrow2.x
rat2.y = ratarrow2.y
timeset = 4

end

if day == 10 and timeleft <= 0.02 then

ratarrow1.x = 0
ratarrow2.x = 0
--ratarrow1.y = rnd(70) + 30

rat1.x = ratarrow1.x
rat1.y = ratarrow1.y
rat2.x = ratarrow2.x
rat2.y = ratarrow2.y
timeset = 2

end

if rat1.x >= 150 and rat1.x < 155

then

stop()
end

if rat2.x >= 150 and rat2.x < 155

then

stop(score)
end

if timeleft > 0 and timeleft < 100 then
timeleft -=0.01
end

if timeleft < 0.001 then
timeleft = 100
day = day + 1

end
 --handle movement buttons
  if btn(➡️) then
   p1.vx=1
   p1.f=false 
  elseif btn(⬅️) then
   p1.vx=-1
   p1.f=true --flip if going left
  else p1.vx*=0.8 --slow to a stop
  end
  
  if btn(⬇️) then
   p1.vy=1
   p1.f=4 
  elseif btn(⬆️) then
   p1.vy=-1
   p1.f=3 --flip if going left
 else p1.vy*=0.8 --slow to a stop
  end
  
   --kick
  if btn(❎) then 
   p1.kick=2 --reset timer
   
   --get array of nearby bombs
   local cs=overlapcheese(p1.x,p1.y,
            p1.x+8,p1.y+8)
		 
		 --kick those bombs
		 for c in all(cs) do
		  --which side of p1 is bomb on
		  local d=sgn(c.x-p1.x)
		  c.vx=d*5+rnd(2) --push bomb
		  c.vy=-3-rnd(2)
		  if p1.f == true then
		   move(c,p1.vx - 5,p1.vy,bouncex,landonwall)
		  end
		  
		  if p1.f == false then
		   move(c,p1.vx + 5,p1.vy,bouncex,landonwall)
		  end
		  
		  if p1.f == 3 then
		   move(c,p1.vx,p1.vy - 5,bouncex,landonwall)
		  end
		  
		    if p1.f == 4 then
		   move(c,p1.vx,p1.vy + 5,bouncex,landonwall)
		  end
		  
		  

		 end
 --missed kick
  end
  
 move(p1,p1.vx,p1.vy,nil,landonwall)

--rat eats cheese
 local cs=overlapcheese(rat1.x,rat1.y,
            rat1.x+16,rat1.y+16)
		 
		 --kick those bombs
		 for c in all(cs) do
		  --which side of p1 is bomb on
		  local d=sgn(c.x-rat1.x)
		  c.vx=d*5+rnd(2) --push bomb
		  c.vy=-3-rnd(2)
		 
		 c.x = rnd(100)
		 c.y = rnd(70) + 30
		  rat1.speed = rat1.speed - 0.2
		  
		  end
		  
		  
		   local cs=overlapcheese(rat2.x,rat2.y,
            rat2.x+16,rat2.y+16)
		 
		 --kick those bombs
		 for c in all(cs) do
		  --which side of p1 is bomb on
		  local d=sgn(c.x-rat2.x)
		  c.vx=d*5+rnd(2) --push bomb
		  c.vy=-3-rnd(2)
		 
		 c.x = rnd(100)
		 c.y = rnd(70) + 30
		  rat2.speed = rat2.speed - 0.2
		  
		  end
		  
		 



 end
 
  --update cheese
 timeuntilcheese-=1
 if timeuntilcheese <=0 then
   timeuntilcheese=rnd(200)+10
   --find a spawn point
 --  local i=flr(rnd(#spawns))
  -- local s=spawns[i+1]
   addcheese(rnd(100),rnd(70)+30)
    addcheese(rnd(100),rnd(70)+30)
     addcheese(rnd(100),rnd(70)+30)
      addcheese(rnd(100),rnd(70)+30)
       addcheese(rnd(100),rnd(70)+30)
        addcheese(rnd(100),rnd(70)+30)
 end
 for c in all(cheese) do
  if c.t > 0 then
   c.vy+=gravity
   if c.grounded then c.vx*=0.9 end
   
    move(c,c.vx,c.vy,bouncex,landonwall)

end
end


 




function _draw()
 cls(13)

 --handle player animation
 p1.t+=1 --timer increases
 if p1.t>11 then p1.t=0 end
 
 --set sprite for player
 if p1.alive==false then
 // p1.s=48 --blood frame
 elseif p1.kick>0 then
  p1.kick-=0.25
//  p1.s=17+flr(p1.kick) --kick frames

 elseif flr(abs(p1.vx)+abs(p1.vy))>0 then
  p1.s=5+flr(p1.t/6.5) --walk animation
 else
  p1.s=1 --idle frame
 end
  
 
 --draw player/cheese
 spr(p1.s,p1.x,p1.y,2,2,p1.f)
 spr(ratarrow1.s,ratarrow1.x,ratarrow1.y,2,2,ratarrow1.f)
  spr(84,rat1.x,rat1.y,4,3,rat1.f)
   spr(ratarrow2.s,ratarrow2.x,ratarrow2.y,2,2,ratarrow2.f)
  spr(84,rat2.x,rat2.y,4,3,rat2.f)
  
  --draw cheese
 for c in all(cheese) do
--  c.t-=1 --update timer
--  if c.t>0 then
 	 --set frame from timer
  --	local f=32+flr(c.t/timebetweencheese*2)
  	spr(29,c.x,c.y)

  
 end
 
 --draw the tilemap
 map(0,0,0,0,map_w,map_h,1)
 
 --draw score
 print("dead rats: "..score,0,120,7)
  print("day: "..day,55,120,7)
    print("time: "..flr(timeleft),85,120,7) 
end

 
 
 


-->8
--all object spawning on this tab

--add an inactive cheese and reset it
function addcheese(x,y)
 for c in all(cheese) do
  --look for a dead bomb
  --and revive it at x,y
  if c.t <=0 then
   c.x=x
   c.y=y
   c.vx=0
   c.vy=0
   c.rx=0
   c.ry=0
   c.grounded=false
   c.t=flr(rnd(timebetweencheese)
          +timebetweencheese)
   timebetweencheese-=1
   return
  end
 end
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000555500000000000000000000000000005500000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000005577500000000000555550000000000055550000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000005767500000000000576750000000000057655000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000005576500000000000557650000000000055765000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000565670000000056656566000000000005656700000000000000000000000000000000000000000000000000000000000000000000000000
00000000000055567666070000005556766607000000556666660700000000000000000000000000000000000000000000000000000000000000000000000000
00000000000ee567776677600000e56707667760000ee56777667760000000000000000054556555f055455f6666556665556666550000000000000000000000
000ccc0000e66676066700000000e670006700000ee6667000660000000000000000000005505505555056556666556665666666595000000000000000000000
00cc0cc000e07650005600000000e655055600000e0550000005500000000000000000005f555f5f5644555655666666656666669a9500000000000000000000
0cc800c000e05000000500000000ee0565000000e05500000000550000000000000000005565f56555555f4065666666565566665a5950000000000000000000
0c0080c00ee050000005000000000ee050000000e00000000000000000000000000000005f5505555645655565666655666666665a9a95000000000000000000
0c00cc000e00000000000000000000e0000000000000000000000000000000000000000005455f5055505405666666566666666655aa59500000000000000000
0cccc0000000000000000000000000000000000000000000000000000000000000000000545f55565f5556556666666666666666595a9a950000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000546550554565455f6666666666666556559aaa950000000000000000
00000000000000000000000000000000000000008822200000000000000000000000000005554546f55565656666666665565555550000000000000000000000
00000000000000000000000000000000000000008822220000000000000000000000000064556555550455505666666666555665597000000000000000000000
000000000000000000000000000000000000000028822220000000000000000000000000555055656555565555566666666566656f7700000000000000000000
0000000000000000000000000000000000000000228822222000000000000000000000000f55455545f545546656666666666666667770000000000000000000
00000000000000000000000000000000000000000222822222000000000000000000000055556505655055f56656666666666666566796000000000000000000
0000000000000000000000000000000000000000000282222200000000000000000000005505555f555556566666666666556666666f69500000000000000000
000000000000000000000000000000000000000000022888222200000000000000000000f55545554f5f55556666666666656666596af6650000000000000000
000000000000000000000000000000000000000000002288222200000000000000000000566505f505565505666666666665566655faa6950000000000000000
00000000000000000000000000000000000000000000022888822200000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000228888200000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000002288222200000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000222822222000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000002288222200000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000022882222000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000002228822220000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000002288822200000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000eeee00000000000000000000000000000000000000000
00000000000000000000000000000000000000000000e00000000000000000000000000000000000eee000ee0000000000000000000000000000000000000000
000000000000000000000000000000000000000000ee00000000000000000000000000000000eeeee000000ee000000000000000000000000000000000000000
0000000000000000000000000000000000000000eee0000000000555500000000000000000eee000005550000000000000000000000000000000000000000000
0000000000000000000000000000000000000000e00000555555550050000000000000000ee00000055055000000000000000000000000000000000000000000
000000000000000000000000000000000000000e0000555444f4500050000000000000000e005500050005555000000000000000000000000000000000000000
0000000000000000000000000000000000000ee0005554444ff5500555000000000000000ee55444455555055500000000000000000000000000000000000000
0000000000000000000000000000000000000e05550044444444455555f550000000000055e044444444455555f0000000000000000000000000000000000000
000000000000000000000000000000000000ee550044440004445555585f55500000000500444400044455555850000000000000000000000000000000000000
00000000000000000000000000000000000555540444400444444555088554450000005504444004444445550885000000000000000000000000000000000000
000000000000000000000000000000000005e555444404444444455500544455000000f54444044f444445550055550000000000000000000000000000000000
0000000000000000000000000000000000555555444444400044f55554444450000000f5444444f55544f5555455550000000000000000000000000000000000
000000000000000000000000000000000055f55555544450555ff55444404500000000555554555f555ff5540444550000000000000000000000000000000000
000000000000000000000000000000000055ff555005555550005544044ff0000000005555555555555555444404450000000000000000000000000000000000
000000000000000000000000000000000555555000555ff555500554444f000000000005f55055555555055554fff40000000000000000000000000000000000
000000000000000000000000000000000000555055555f0005555555555000000000000f450055550005555555544f0000000000000000000000000000000000
000000000000000000000000000000000000555005554000005555000450000000000005f4005550000000550004400000000000000000000000000000000000
00000000000000000000000000000000000555005554000000055550004000000000000554504455000005550000000000000000000000000000000000000000
00000000000000000000000000000000004540005544000000055554000000000000000055504445550004450000000000000000000000000000000000000000
00000000000000000000000000000000000040000400000000040405000000000000000005505544450005440000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000554550000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000005500000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000000000000000000000000000000101000000000000000000000000000001010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
1c1b1c1b1c1b1c1b1c1b1c1b1c1b1c1b1c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2c2b2c2b2c2b2c2b2c2b2c2b2c2b2c2b2c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1c1b1c1b1c1b1c1b1c1b1c1b1c1b1c1b1c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2c2b2c2b2c2b2c2b2c2b2c2b2c2b2c2b2c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
292a292a292a292a292a292a2a292a191a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
292a292a292a292a292a2929292a19292a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
191a191a1a1a191a191a191a191a292a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
292a292a292a292a292a292a292a191a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
191a191a191a192a191a191a191a191a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
292a292a292a292a292a292a292a292a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
191a191a191a191a191a191a191a191a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
292a292a292a292a292a292a292a292a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
