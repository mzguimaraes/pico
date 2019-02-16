pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

-- 321blue -- by ben fried

p1={x=16,y=16,w=8,h=8,vx=0,
vy=0,rx=0,ry=0,s=1,f=false,t=0,
grounded=false,kick=0,alive=true}

blast={x,y,s=34}
// blocks
screen = 7
--layer 1
l1text = "p"
l2text = "a"
l3text = "i"
l4text = "n"
l5text = "t"
l6text = " "
l7text = "i"
l8text = "t"
l9text = " "
l10text = "b"
l11text = "l"
l12text = "u"
l13text = "e"
lettersy = 50
pletter = 6
aletter = 6
iletter = 6
nletter = 6
tletter = 6
spletter = 6
i2letter = 6
t2letter = 6
sp2letter = 6
bletter = 6
lletter = 6
uletter = 6
eletter = 6

block1={x=0, y=110, colr=16}
block2={x=8, y=110, colr=16}
block3={x=16, y=110, colr=16}
block4={x=24, y=110, colr=16}
block5={x=32, y=110, colr=16}
block6={x=40, y=110, colr=16}
block7={x=48, y=110, colr=16}
block8={x=56, y=110, colr=16}
block9={x=64, y=110, colr=16}
block10={x=72, y=110, colr=16}
block11={x=80, y=110, colr=16}
block12={x=88, y=110, colr=16}
block13={x=96, y=110, colr=16}
block14={x=104, y=110, colr=16}
block15={x=112, y=110, colr=16}
block16={x=120, y=110, colr=16}


p1score = 1
finalscore = 0
difficulty = 200
gravity = 0.1
round = 1
touchables={}


--all the collision stuff is
--on this tab

--true if p1 touching explosion e










function create_particle(x,y)
 local spd=rnd(2)
 local a=rnd(1)
 
 local p={
  x=x,
  y=y,
  vx=spd*cos(a),
  vy=spd*sin(a),
  c=rnd(8)+8,
  t=5
 }

 add(particles,p)
 add(particles,p)
 add(particles,p)
end

--returns list of bombs in rect
--defined by x1,y1,x2,y2
function overlap(x1,y1,x2,y2)
 local hits={}
 
 for i in all(touchables) do
 
	 if i.t > 0 then
   local touching=true
   --not gonna lie, i googled
   --this overlap test
   if 
   y2<i.y or y1>i.y+8 or
   x2<i.x or x1>i.x+8 then
   touching=false
   end
   if touching then
    add(hits,i)
     
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
 // elseif p1.x >= block1.x and p1.x < block1.x + 5
//and p1.y == block1.y - 8 then
 // return true
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




function _update60()

if p1.x < 0 then
p1.x = 0
end

if p1.x > 120 then
p1.x = 120
end

-- light grey blocks

if p1.x >= block1.x - 3 and p1.x < block1.x +5
and p1.y >= block1.y - 5 and p1.y < block1.y + 3 and block1.colr == 16 then


p1.vy = -7
block1.colr = 5
blast.s=36
blast.x = p1.x
blast.y = p1.y - 7
pletter = 12

end

if p1.x >= block2.x - 3 and p1.x < block2.x +5
and p1.y >= block2.y - 5 and p1.y < block2.y + 3 and block2.colr == 16  then


p1.vy = -7
block2.colr = 5
blast.s=36
blast.x = p1.x
blast.y = p1.y - 7
aletter = 12

end

if p1.x >= block3.x - 3 and p1.x < block3.x +5
and p1.y >= block3.y - 5 and p1.y < block3.y + 3 and block3.colr == 16 then

create_particle(p1.x,p1.y)
p1.vy = -7
block3.colr = 5
blast.s=36
blast.x = p1.x
blast.y = p1.y - 7
iletter = 12

end

if p1.x >= block4.x - 3 and p1.x < block4.x +5
and p1.y >= block4.y - 5 and p1.y < block4.y + 3 and block4.colr == 16 then


p1.vy = -7
block4.colr = 5
blast.s=36
blast.x = p1.x
blast.y = p1.y - 7
nletter = 12

end

if p1.x >= block5.x - 3 and p1.x < block5.x +5
and p1.y >= block5.y - 5 and p1.y < block5.y + 3 and block5.colr == 16 then


p1.vy = -7
block5.colr = 5
blast.s=36
blast.x = p1.x
blast.y = p1.y - 7
tletter = 12

end


if p1.x >= block6.x - 3 and p1.x < block6.x +5
and p1.y >= block6.y - 5 and p1.y < block6.y + 3 and block6.colr == 16 then


p1.vy = -7
block6.colr = 5
blast.s=36
blast.x = p1.x
blast.y = p1.y - 7

end


if p1.x >= block7.x - 3 and p1.x < block7.x +5
and p1.y >= block7.y - 5 and p1.y < block7.y + 3 and block7.colr == 16 then


p1.vy = -7
block7.colr = 5
blast.s=36
blast.x = p1.x
blast.y = p1.y - 7

end

if p1.x >= block8.x - 3 and p1.x < block8.x +5
and p1.y >= block8.y - 5 and p1.y < block8.y + 3 and block8.colr == 16 then


p1.vy = -7
block8.colr = 5
blast.s=36
blast.x = p1.x
blast.y = p1.y - 7



end


if p1.x >= block9.x - 3 and p1.x < block9.x +5
and p1.y >= block9.y - 5 and p1.y < block9.y + 3 and block9.colr == 16 then


p1.vy = -7
block9.colr = 5
blast.s=36
blast.x = p1.x
blast.y = p1.y - 7

i2letter = 12

end


if p1.x >= block10.x - 3 and p1.x < block10.x +5
and p1.y >= block10.y - 5 and p1.y < block10.y + 3 and block10.colr == 16 then


p1.vy = -7
block10.colr = 5
blast.s=36
blast.x = p1.x
blast.y = p1.y - 7

t2letter = 12

end

if p1.x >= block11.x - 3 and p1.x < block11.x +5
and p1.y >= block11.y - 5 and p1.y < block11.y + 3 and block11.colr == 16 then


p1.vy = -7
block11.colr = 5
blast.s=36
blast.x = p1.x
blast.y = p1.y - 7

end


if p1.x >= block12.x - 3 and p1.x < block12.x +5
and p1.y >= block12.y - 5 and p1.y < block12.y + 3 and block12.colr == 16 then


p1.vy = -7
block12.colr = 5
blast.s=36
blast.x = p1.x
blast.y = p1.y - 7


end

if p1.x >= block13.x - 3 and p1.x < block13.x +5
and p1.y >= block13.y - 5 and p1.y < block13.y + 3 and block13.colr == 16 then


p1.vy = -7
block13.colr = 5
blast.s=36
blast.x = p1.x
blast.y = p1.y - 7
bletter = 12

end

if p1.x >= block14.x - 3 and p1.x < block14.x +5
and p1.y >= block14.y - 5 and p1.y < block14.y + 3 and block14.colr == 16 then


p1.vy = -7
block14.colr = 5
blast.s=36
blast.x = p1.x
blast.y = p1.y - 7
lletter = 12


end

if p1.x >= block15.x - 3 and p1.x < block15.x +5
and p1.y >= block15.y - 5 and p1.y < block15.y + 3 and block15.colr == 16 then


p1.vy = -7
block15.colr = 5
blast.s=36
blast.x = p1.x
blast.y = p1.y - 7
uletter = 12

end

if p1.x >= block16.x - 3 and p1.x < block16.x +5
and p1.y >= block16.y - 5 and p1.y < block16.y + 3 and block16.colr == 16 then


p1.vy = -7
block16.colr = 5
blast.s=36
blast.x = p1.x
blast.y = p1.y-7
eletter = 12


end


-- dark grey blocks


if p1.x >= block1.x - 3 and p1.x < block1.x +5
and p1.y >= block1.y - 5 and p1.y < block1.y + 3 and block1.colr == 32 then


p1.vy = -7
block1.colr = 5
blast.s=36
blast.x = p1.x
blast.y = p1.y - 7
pletter = 12
block16.y = 1

end

if p1.x >= block2.x - 3 and p1.x < block2.x +5
and p1.y >= block2.y - 5 and p1.y < block2.y + 3 and block2.colr == 32  then


p1.vy = -7
block2.colr = 5
blast.s=36
blast.x = p1.x
blast.y = p1.y - 7
aletter = 12
block2.y = 1

end

if p1.x >= block3.x - 3 and p1.x < block3.x +5
and p1.y >= block3.y - 5 and p1.y < block3.y + 3 and block3.colr == 32 then

create_particle(p1.x,p1.y)
p1.vy = -7
block3.colr = 5
blast.s=36
blast.x = p1.x
blast.y = p1.y - 7
iletter = 12
block3.y = 1

end

if p1.x >= block4.x - 3 and p1.x < block4.x +5
and p1.y >= block4.y - 5 and p1.y < block4.y + 3 and block4.colr == 32 then


p1.vy = -7
block4.colr = 5
blast.s=36
blast.x = p1.x
blast.y = p1.y - 7
nletter = 12
block4.y = 1

end

if p1.x >= block5.x - 3 and p1.x < block5.x +5
and p1.y >= block5.y - 5 and p1.y < block5.y + 3 and block5.colr == 32 then


p1.vy = -7
block5.colr = 5
blast.s=36
blast.x = p1.x
blast.y = p1.y - 7
tletter = 12
block5.y = 1

end


if p1.x >= block6.x - 3 and p1.x < block6.x +5
and p1.y >= block6.y - 5 and p1.y < block6.y + 3 and block6.colr == 32 then


p1.vy = -7
block6.colr = 5
blast.s=36
blast.x = p1.x
blast.y = p1.y - 7
block6.y = 1

end


if p1.x >= block7.x - 3 and p1.x < block7.x +5
and p1.y >= block7.y - 5 and p1.y < block7.y + 3 and block7.colr == 32 then


p1.vy = -7
block7.colr = 5
blast.s=36
blast.x = p1.x
blast.y = p1.y - 7
block7.y = 1

end

if p1.x >= block8.x - 3 and p1.x < block8.x +5
and p1.y >= block8.y - 5 and p1.y < block8.y + 3 and block8.colr == 32 then


p1.vy = -7
block8.colr = 5
blast.s=36
blast.x = p1.x
blast.y = p1.y - 7
block8.y = 1



end


if p1.x >= block9.x - 3 and p1.x < block9.x +5
and p1.y >= block9.y - 5 and p1.y < block9.y + 3 and block9.colr == 32 then


p1.vy = -7
block9.colr = 5
blast.s=36
blast.x = p1.x
blast.y = p1.y - 7

i2letter = 12
block9.y = 1

end


if p1.x >= block10.x - 3 and p1.x < block10.x +5
and p1.y >= block10.y - 5 and p1.y < block10.y + 3 and block10.colr == 32 then


p1.vy = -7
block10.colr = 5
blast.s=36
blast.x = p1.x
blast.y = p1.y - 7

t2letter = 12
block10.y = 1

end

if p1.x >= block11.x - 3 and p1.x < block11.x +5
and p1.y >= block11.y - 5 and p1.y < block11.y + 3 and block11.colr == 32 then


p1.vy = -7
block11.colr = 5
blast.s=36
blast.x = p1.x
blast.y = p1.y - 7
block11.y = 1

end


if p1.x >= block12.x - 3 and p1.x < block12.x +5
and p1.y >= block12.y - 5 and p1.y < block12.y + 3 and block12.colr == 32 then


p1.vy = -7
block12.colr = 5
blast.s=36
blast.x = p1.x
blast.y = p1.y - 7
block12.y = 1


end

if p1.x >= block13.x - 3 and p1.x < block13.x +5
and p1.y >= block13.y - 5 and p1.y < block13.y + 3 and block13.colr == 32 then


p1.vy = -7
block13.colr = 5
blast.s=36
blast.x = p1.x
blast.y = p1.y - 7
bletter = 12
block13.y = 1

end

if p1.x >= block14.x - 3 and p1.x < block14.x +5
and p1.y >= block14.y - 5 and p1.y < block14.y + 3 and block14.colr == 32 then


p1.vy = -7
block14.colr = 5
blast.s=36
blast.x = p1.x
blast.y = p1.y - 7
lletter = 12
block14.y = 1


end

if p1.x >= block15.x - 3 and p1.x < block15.x +5
and p1.y >= block15.y - 5 and p1.y < block15.y + 3 and block15.colr == 32 then


p1.vy = -7
block15.colr = 5
blast.s=36
blast.x = p1.x
blast.y = p1.y - 7
uletter = 12
block15.y = 1
end

if p1.x >= block16.x - 3 and p1.x < block16.x +5
and p1.y >= block16.y - 5 and p1.y < block16.y + 3 and block16.colr == 32 then


p1.vy = -7
block16.colr = 5
blast.s=36
blast.x = p1.x
blast.y = p1.y-7
eletter = 12
block16.y = 1


end


--blue blocks


if p1.x >= block1.x - 3 and p1.x < block1.x +5
and p1.y >= block1.y - 5 and p1.y < block1.y + 3 and block1.colr == 5 then


p1.vy = -7


end

if p1.x >= block2.x - 3 and p1.x < block2.x +5
and p1.y >= block2.y - 5 and p1.y < block2.y + 3 and block2.colr == 5  then


p1.vy = -7


end

if p1.x >= block3.x - 3 and p1.x < block3.x +5
and p1.y >= block3.y - 5 and p1.y < block3.y + 3 and block3.colr == 5 then


p1.vy = -7


end

if p1.x >= block4.x - 3 and p1.x < block4.x +5
and p1.y >= block4.y - 5 and p1.y < block4.y + 3 and block4.colr == 5 then


p1.vy = -7


end

if p1.x >= block5.x - 3 and p1.x < block5.x +5
and p1.y >= block5.y - 5 and p1.y < block5.y + 3 and block5.colr == 5 then


p1.vy = -7


end


if p1.x >= block6.x - 3 and p1.x < block6.x +5
and p1.y >= block6.y - 5 and p1.y < block6.y + 3 and block6.colr == 5 then


p1.vy = -7


end


if p1.x >= block7.x - 3 and p1.x < block7.x +5
and p1.y >= block7.y - 5 and p1.y < block7.y + 3 and block7.colr == 5 then


p1.vy = -7


end

if p1.x >= block8.x - 3 and p1.x < block8.x +5
and p1.y >= block8.y - 5 and p1.y < block8.y + 3 and block8.colr == 5 then


p1.vy = -7




end


if p1.x >= block9.x - 3 and p1.x < block9.x +5
and p1.y >= block9.y - 5 and p1.y < block9.y + 3 and block9.colr == 5 then


p1.vy = -7


end


if p1.x >= block10.x - 3 and p1.x < block10.x +5
and p1.y >= block10.y - 5 and p1.y < block10.y + 3 and block10.colr == 5 then


p1.vy = -7


end

if p1.x >= block11.x - 3 and p1.x < block11.x +5
and p1.y >= block11.y - 5 and p1.y < block11.y + 3 and block11.colr == 5 then


p1.vy = -7


end


if p1.x >= block12.x - 3 and p1.x < block12.x +5
and p1.y >= block12.y - 5 and p1.y < block12.y + 3 and block12.colr == 5 then


p1.vy = -7



end

if p1.x >= block13.x - 3 and p1.x < block13.x +5
and p1.y >= block13.y - 5 and p1.y < block13.y + 3 and block13.colr == 5 then


p1.vy = -7


end

if p1.x >= block14.x - 3 and p1.x < block14.x +5
and p1.y >= block14.y - 5 and p1.y < block14.y + 3 and block14.colr == 5 then


p1.vy = -7



end

if p1.x >= block15.x - 3 and p1.x < block15.x +5
and p1.y >= block15.y - 5 and p1.y < block15.y + 3 and block15.colr == 5 then


p1.vy = -7


end

if p1.x >= block16.x - 3 and p1.x < block16.x +5
and p1.y >= block16.y - 5 and p1.y < block16.y + 3 and block16.colr == 5 then


p1.vy = -7



end

if blast.s < 47 then
blast.s = blast.s + 0.6
end

if blast.s >= 46 then
blast.x = 500
end

if
block1.colr == 5 and
block2.colr == 5 and
block3.colr == 5 and
block4.colr == 5 and
block5.colr == 5 and
block6.colr == 5 and
block7.colr == 5 and
block8.colr == 5 and
block9.colr == 5 and
block10.colr == 5 and
block11.colr == 5 and
block12.colr == 5 and
block13.colr == 5 and
block14.colr == 5 and
block15.colr == 5 and
block16.colr == 5 then

//block1.colr = rnd(5) + 5
//block2.colr = rnd(5) + 5
//block3.colr = rnd(5) + 5
//block4.colr = rnd(5) + 5
//block5.colr = rnd(5) + 5
//block6.colr = rnd(5) + 5
//block7.colr = rnd(5) + 5
//block8.colr = rnd(5) + 5
//block9.colr = rnd(5) + 5
//block10.colr = rnd(5) + 5
//block11.colr = rnd(5) + 5
//block12.colr = rnd(5) + 5
//block13.colr = rnd(5) + 5
//block14.colr = rnd(5) + 5
//block15.colr = rnd(5) + 5
//block16.colr = 16

//round = round + 1
//camera(0,p1.y)
//lettersy = lettersy + 120
//block1.colr = 16
end


--levels

if round == 1 and

block1.colr == 5 and
block2.colr == 5 and
block3.colr == 5 and
block4.colr == 5 and
block5.colr == 5 and
block6.colr == 5 and
block7.colr == 5 and
block8.colr == 5 and
block9.colr == 5 and
block10.colr == 5 and
block11.colr == 5 and
block12.colr == 5 and
block13.colr == 5 and
block14.colr == 5 and
block15.colr == 5 and
block16.colr == 5 then

round = round + 1
camera(0,p1.y)
lettersy = lettersy + 110


pletter = 6
aletter = 6
iletter = 6
nletter = 6
tletter = 6
spletter = 6
i2letter = 6
t2letter = 6
sp2letter = 6
bletter = 6
lletter = 6
uletter = 6
eletter = 6

l1text = "h"
l2text = "i"
l3text = " "
l4text = "t"
l5text = "h "
l6text = "e "
l7text = "r"
l8text = "e"
l9text = " "
l10text = " "
l11text = " "
l12text = " "
l13text = " "



block1.y =220
block1.colr = 16
block2.y =220
block2.colr = 16
block3.y =220
block3.colr = 16
block4.y =220
block4.colr = 16
block5.y =212
block5.colr = 16
block6.y =212
block6.colr = 16
block7.y =212
block7.colr = 16
block8.y =220
block8.colr = 16
block9.y =220
block9.colr = 16
block10.y =220
block10.colr = 16
block11.y =220
block11.colr = 16
block12.y =220
block12.colr = 16
block13.y =220
block13.colr = 16
block14.y =220
block14.colr = 16
block15.y =220
block15.colr = 16
block16.y =220
block16.colr = 16

end

if round == 2 and

block1.colr == 5 and
block2.colr == 5 and
block3.colr == 5 and
block4.colr == 5 and
block5.colr == 5 and
block6.colr == 5 and
block7.colr == 5 and
block8.colr == 5 and
block9.colr == 5 and
block10.colr == 5 and
block11.colr == 5 and
block12.colr == 5 and
block13.colr == 5 and
block14.colr == 5 and
block15.colr == 5 and
block16.colr == 5 then

round = round + 1
camera(0,p1.y)
lettersy = lettersy + 110


pletter = 6
aletter = 6
iletter = 6
nletter = 6
tletter = 6
spletter = 6
i2letter = 6
t2letter = 6
sp2letter = 6
bletter = 6
lletter = 6
uletter = 6
eletter = 6

l1text = "b"
l2text = "a"
l3text = "b"
l4text = "y"
l5text = " "
l6text = "s"
l7text = "t"
l8text = "e"
l9text = "p"
l10text = "s"
l11text = " "
l12text = " "
l13text = " "



block1.y =330
block1.colr = 16
block2.y =330
block2.colr = 16
block3.y =322
block3.colr = 16
block4.y =322
block4.colr = 16
block5.y =330
block5.colr = 16
block6.y =330
block6.colr = 16
block7.y =322
block7.colr = 16
block8.y =322
block8.colr = 16
block9.y =330
block9.colr = 16
block10.y =330
block10.colr = 16
block11.y =322
block11.colr = 16
block12.y =322
block12.colr = 16
block13.y =330
block13.colr = 16
block14.y =330
block14.colr = 16
block15.y =322
block15.colr = 16
block16.y =322
block16.colr = 16

end

if round == 3 and

block1.colr == 5 and
block2.colr == 5 and
block3.colr == 5 and
block4.colr == 5 and
block5.colr == 5 and
block6.colr == 5 and
block7.colr == 5 and
block8.colr == 5 and
block9.colr == 5 and
block10.colr == 5 and
block11.colr == 5 and
block12.colr == 5 and
block13.colr == 5 and
block14.colr == 5 and
block15.colr == 5 and
block16.colr == 5 then

round = round + 1
camera(0,p1.y)
lettersy = lettersy + 110


pletter = 6
aletter = 6
iletter = 6
nletter = 6
tletter = 6
spletter = 6
i2letter = 6
t2letter = 6
sp2letter = 6
bletter = 6
lletter = 6
uletter = 6
eletter = 6


l1text = "s"
l2text = "t"
l3text = "i"
l4text = "l"
l5text = "l"
l6text = " "
l7text = "l"
l8text = "e"
l9text = "a"
l10text = "r"
l11text = "n"
l12text = "i"
l13text = "ng"



block1.y =440
block1.colr = 16
block2.y =437
block2.colr = 16
block3.y =434
block3.colr = 16
block4.y =431
block4.colr = 16
block5.y =428
block5.colr = 16
block6.y =425
block6.colr = 16
block7.y =422
block7.colr = 16
block8.y =419
block8.colr = 16
block9.y =416
block9.colr = 16
block10.y =413
block10.colr = 16
block11.y =410
block11.colr = 16
block12.y =407
block12.colr = 16
block13.y =404
block13.colr = 16
block14.y =401
block14.colr = 16
block15.y =398
block15.colr = 16
block16.y =395
block16.colr = 16

end


if round == 4 and

block1.colr == 5 and
block2.colr == 5 and
block3.colr == 5 and
block4.colr == 5 and
block5.colr == 5 and
block6.colr == 5 and
block7.colr == 5 and
block8.colr == 5 and
block9.colr == 5 and
block10.colr == 5 and
block11.colr == 5 and
block12.colr == 5 and
block13.colr == 5 and
block14.colr == 5 and
block15.colr == 5 and
block16.colr == 5 then

round = round + 1
camera(0,p1.y)
lettersy = lettersy + 110


pletter = 6
aletter = 6
iletter = 6
nletter = 6
tletter = 6
spletter = 6
i2letter = 6
t2letter = 6
sp2letter = 6
bletter = 6
lletter = 6
uletter = 6
eletter = 6


l1text = "b"
l2text = "i"
l3text = "t"
l4text = " "
l5text = "b"
l6text = "y"
l7text = " "
l8text = "b"
l9text = "i"
l10text = "t"
l11text = ""
l12text = ""
l13text = ""



block1.y =550
block1.colr = 16
block2.y =547
block2.colr = 16
block3.y =544
block3.colr = 16
block4.y =541
block4.colr = 16
block5.y =538
block5.colr = 16
block6.y =535
block6.colr = 16
block7.y =532
block7.colr = 16
block8.y =529
block8.colr = 16
block9.y =529
block9.colr = 16
block10.y =532
block10.colr = 16
block11.y =535
block11.colr = 16
block12.y =538
block12.colr = 16
block13.y =541
block13.colr = 16
block14.y =544
block14.colr = 16
block15.y =547
block15.colr = 16
block16.y =550
block16.colr = 16

end



if round == 5 and

block1.colr == 5 and
block2.colr == 5 and
block3.colr == 5 and
block4.colr == 5 and
block5.colr == 5 and
block6.colr == 5 and
block7.colr == 5 and
block8.colr == 5 and
block9.colr == 5 and
block10.colr == 5 and
block11.colr == 5 and
block12.colr == 5 and
block13.colr == 5 and
block14.colr == 5 and
block15.colr == 5 and
block16.colr == 5 then

round = round + 1
camera(0,p1.y)
lettersy = lettersy + 110


pletter = 6
aletter = 6
iletter = 6
nletter = 6
tletter = 6
spletter = 6
i2letter = 6
t2letter = 6
sp2letter = 6
bletter = 6
lletter = 6
uletter = 6
eletter = 6


l1text = "i"
l2text = "l"
l3text = "l"
l4text = " "
l5text = "b"
l6text = "e"
l7text = " "
l8text = "r"
l9text = "i"
l10text = "g"
l11text = "h"
l12text = "t"
l13text = " back"



block1.y =600
block1.colr = 16
block2.y =597
block2.colr = 16
block3.y =594
block3.colr = 16
block4.y =591
block4.colr = 16
block5.y =588
block5.colr = 16
block6.y =585
block6.colr = 16
block7.y =582
block7.colr = 16
block8.y =629
block8.colr = 16
block9.y =629
block9.colr = 16
block10.y =582
block10.colr = 16
block11.y =585
block11.colr = 16
block12.y =588
block12.colr = 16
block13.y =591
block13.colr = 16
block14.y =594
block14.colr = 16
block15.y =597
block15.colr = 16
block16.y =600
block16.colr = 16

end


if round == 6 and

block1.colr == 5 and
block2.colr == 5 and
block3.colr == 5 and
block4.colr == 5 and
block5.colr == 5 and
block6.colr == 5 and
block7.colr == 5 and
block8.colr == 5 and
block9.colr == 5 and
block10.colr == 5 and
block11.colr == 5 and
block12.colr == 5 and
block13.colr == 5 and
block14.colr == 5 and
block15.colr == 5 and
block16.colr == 5 then

round = round + 1
camera(0,p1.y)
lettersy = lettersy + 110


pletter = 6
aletter = 6
iletter = 6
nletter = 6
tletter = 6
spletter = 6
i2letter = 6
t2letter = 6
sp2letter = 6
bletter = 6
lletter = 6
uletter = 6
eletter = 6


l1text = ""
l2text = ""
l3text = ""
l4text = ""
l5text = ""
l6text = ""
l7text = ""
l8text = ""
l9text = ""
l10text = ""
l11text = ""
l12text = ""
l13text = ""



block1.y =700
block1.colr = 16
block2.y =700
block2.colr = 16
block3.y =725
block3.colr = 16
block4.y =725
block4.colr = 16
block5.y =745
block5.colr = 16
block6.y =745
block6.colr = 16
block7.y =720
block7.colr = 16
block8.y =720
block8.colr = 16
block9.y =745
block9.colr = 16
block10.y =745
block10.colr = 16
block11.y =725
block11.colr = 16
block12.y =725
block12.colr = 16
block13.y =700
block13.colr = 16
block14.y =700
block14.colr = 16
block15.y =725
block15.colr = 16
block16.y =725
block16.colr = 16

end



if round == 7 and



block1.colr == 5 and
block2.colr == 5 and
block3.colr == 5 and
block4.colr == 5 and
block5.colr == 5 and
block6.colr == 5 and
block7.colr == 5 and
block8.colr == 5 and
block9.colr == 5 and
block10.colr == 5 and
block11.colr == 5 and
block12.colr == 5 and
block13.colr == 5 and
block14.colr == 5 and
block15.colr == 5 and
block16.colr == 5 then

round = round + 1
camera(0,p1.y)
//lettersy = lettersy + 110
screen = 0

pletter = 3
aletter = 5
iletter = 8
nletter = 12
tletter = 4
spletter = 8
i2letter = 5
t2letter = 2
sp2letter = 2
bletter = 8
lletter = 9
uletter = 11
eletter = 10


l1text = "asd"
l2text = "bfdoij"
l3text = "sfd"
l4text = "3tg"
l5text = "zv"
l6text = "z"
l7text = "h"
l8text = "e"
l9text = "l"
l10text = "p"
l11text = "m"
l12text = "e"
l13text = "w3sm"



block1.y =810
block1.colr = 16
block2.y =810
block2.colr = 16
block3.y =810
block3.colr = 16
block4.y =810
block4.colr = 16
block5.y =810
block5.colr = 16
block6.y =1
block6.colr = 5
block7.y =1
block7.colr = 5
block8.y =810
block8.colr = 16
block9.y =810
block9.colr = 16
block10.y =810
block10.colr = 16
block11.y =810
block11.colr = 16
block12.y =810
block12.colr = 16
block13.y =1
block13.colr = 5
block14.y =1
block14.colr = 5
block15.y =810
block15.colr = 16
block16.y =810
block16.colr = 16

end

if round == 8 and



block1.colr == 5 and
block2.colr == 5 and
block3.colr == 5 and
block4.colr == 5 and
block5.colr == 5 and
block6.colr == 5 and
block7.colr == 5 and
block8.colr == 5 and
block9.colr == 5 and
block10.colr == 5 and
block11.colr == 5 and
block12.colr == 5 and
block13.colr == 5 and
block14.colr == 5 and
block15.colr == 5 and
block16.colr == 5 then

round = round + 1
camera(0,p1.y)
lettersy = lettersy + 110
screen = 7

pletter = 6
aletter = 6
iletter = 6
nletter = 6
tletter = 6
spletter = 6
i2letter = 6
t2letter = 6
sp2letter = 6
bletter = 6
lletter = 6
uletter = 6
eletter = 6


l1text = "m"
l2text = "y"
l3text = " "
l4text = "a"
l5text = "p"
l6text = "o"
l7text = "l"
l8text = "o"
l9text = "g"
l10text = "i"
l11text = "e"
l12text = "s"
l13text = ""



block1.y =920
block1.colr = 16
block2.y =895
block2.colr = 16
block3.y =870
block3.colr = 16
block4.y =845
block4.colr = 16
block5.y =920
block5.colr = 16
block6.y =920
block6.colr = 16
block7.y =920
block7.colr = 16
block8.y =895
block8.colr = 16
block9.y =870
block9.colr = 16
block10.y =845
block10.colr = 16
block11.y =910
block11.colr = 16
block12.y =910
block12.colr = 16
block13.y =910
block13.colr = 16
block14.y = 910
block14.colr = 16
block15.y =910
block15.colr = 16
block16.y =910
block16.colr = 16

end


if round == 9 and



block1.colr == 5 and
block2.colr == 5 and
block3.colr == 5 and
block4.colr == 5 and
block5.colr == 5 and
block6.colr == 5 and
block7.colr == 5 and
block8.colr == 5 and
block9.colr == 5 and
block10.colr == 5 and
block11.colr == 5 and
block12.colr == 5 and
block13.colr == 5 and
block14.colr == 5 and
block15.colr == 5 and
block16.colr == 5 then

round = round + 1
camera(0,p1.y)
lettersy = lettersy + 110


pletter = 6
aletter = 6
iletter = 6
nletter = 6
tletter = 6
spletter = 6
i2letter = 6
t2letter = 6
sp2letter = 6
bletter = 6
lletter = 6
uletter = 6
eletter = 6


l1text = "l"
l2text = "o"
l3text = "o"
l4text = "k"
l5text = "s"
l6text = " "
l7text = "l"
l8text = "i"
l9text = "k"
l10text = "e"
l11text = " "
l12text = "y"
l13text = "ou're getting it"



block1.y =1000
block1.colr = 16
block2.y =965
block2.colr = 16
block3.y =950
block3.colr = 16
block4.y =915
block4.colr = 16
block5.y =100
block5.colr = 16
block6.y =975
block6.colr = 16
block7.y =950
block7.colr = 16
block8.y =915
block8.colr = 16
block9.y =1000
block9.colr = 16
block10.y =975
block10.colr = 16
block11.y =950
block11.colr = 16
block12.y =915
block12.colr = 16
block13.y =1000
block13.colr = 16
block14.y = 950
block14.colr = 16
block15.y =915
block15.colr = 16
block16.y =1000
block16.colr = 16

end


if round == 10 and



block1.colr == 5 and
block2.colr == 5 and
block3.colr == 5 and
block4.colr == 5 and
block5.colr == 5 and
block6.colr == 5 and
block7.colr == 5 and
block8.colr == 5 and
block9.colr == 5 and
block10.colr == 5 and
block11.colr == 5 and
block12.colr == 5 and
block13.colr == 5 and
block14.colr == 5 and
block15.colr == 5 and
block16.colr == 5 then

round = round + 1
camera(0,p1.y)
lettersy = lettersy + 110


pletter = 6
aletter = 6
iletter = 6
nletter = 5
tletter = 6
spletter = 6
i2letter = 6
t2letter = 5
sp2letter = 6
bletter = 6
lletter = 6
uletter = 5
eletter = 6


l1text = "s"
l2text = "o"
l3text = "m"
l4text = "e"
l5text = "t"
l6text = "h"
l7text = "i"
l8text = "n"
l9text = "g"
l10text = " "
l11text = "n"
l12text = "e"
l13text = "w"



block1.y =1120
block1.colr = 16
block2.y =1120
block2.colr = 16
block3.y =1120
block3.colr = 16
block4.y =1120
block4.colr = 32
block5.y =1120
block5.colr = 32
block6.y =1112
block6.colr = 16
block7.y =1112
block7.colr = 16
block8.y =1112
block8.colr = 16
block9.y =1112
block9.colr = 16
block10.y =1112
block10.colr = 32
block11.y =1104
block11.colr = 32
block12.y =1104
block12.colr = 16
block13.y =1104
block13.colr = 16
block14.y = 1104
block14.colr = 16
block15.y =1104
block15.colr = 32
block16.y =1104
block16.colr = 32

end


if round == 10 and



block1.colr == 5 and
block2.colr == 5 and
block3.colr == 5 and
block4.colr == 5 and
block5.colr == 5 and
block6.colr == 5 and
block7.colr == 5 and
block8.colr == 5 and
block9.colr == 5 and
block10.colr == 5 and
block11.colr == 5 and
block12.colr == 5 and
block13.colr == 5 and
block14.colr == 5 and
block15.colr == 5 and
block16.colr == 5 then

round = round + 1
camera(0,p1.y)
lettersy = lettersy + 110


pletter = 6
aletter = 6
iletter = 6
nletter = 5
tletter = 6
spletter = 6
i2letter = 6
t2letter = 5
sp2letter = 6
bletter = 6
lletter = 6
uletter = 5
eletter = 6


l1text = "y"
l2text = "o"
l3text = "u"
l4text = " "
l5text = "a"
l6text = "r"
l7text = "e"
l8text = " "
l9text = "a"
l10text = " "
l11text = "f"
l12text = "a"
l13text = "st learner"



block1.y =1230
block1.colr = 32
block2.y =1230
block2.colr = 32
block3.y =1230
block3.colr = 32
block4.y =1230
block4.colr = 32
block5.y =1230
block5.colr = 32
block6.y =1205
block6.colr = 32
block7.y =1205
block7.colr = 32
block8.y =1180
block8.colr = 32
block9.y =1180
block9.colr = 32
block10.y =1205
block10.colr = 32
block11.y =1205
block11.colr = 32
block12.y =1230
block12.colr = 16
block13.y =1230
block13.colr = 16
block14.y = 1230
block14.colr = 16
block15.y =1230
block15.colr = 32
block16.y =1230
block16.colr = 32

end
	if p1.alive then
  p1.vy+=gravity+0.2
  
  --handle movement buttons
  if btn(➡️,0) then
   p1.vx=1
   p1.f=false 
  elseif btn(⬅️,0) then
   p1.vx=-1
   p1.f=true --flip if going left
  else p1.vx*=0.8 --slow to a stop
  end
  
  --jump if grounded
  if btnp(🅾️,0) and p1.grounded then
   p1.vy=-6
   sfx(4)
 
  else p1.vy*=0.9
  end 
  
  --kick
 
  
  --move and collide the player
  --according to its velocity
  move(p1,p1.vx,p1.vy,nil,landonwall)

 end
   
 --update bombs


-- for b in all(bombs) do
--  if b.t > 0 then
--   b.vy+=gravity
 --  if b.grounded then b.vx*=0.9 end
 --  move(b,b.vx,b.vy,bouncex,landonwall)
 
-- end
  
-- end
 

 




  
  --handle movement buttons
 
  
 
  
  --kick
  if btnp(❎,1) then 
   p2.kick=2 --reset timer
   
   --get array of nearby bombs
   local bs=overlap(p2.x,p2.y,
            p2.x+8,p2.y+8)
		 
		 --kick those bombs
		 for i in all(ts) do
		  --which side of p1 is bomb on
		  local d=sgn(i.x-p2.x)
		  i.vx=d*5+rnd(2) --push bomb
		  i.vy=-3-rnd(2)
		 end
		 if #ts>=1 then 
		 	 
		  sfx(1)
		  
		 else sfx(0)
	
		  
  end
  
  
  
  --move and collide the player
  --according to its velocity
  
 


--for e in all(explosions) do
  --if e.t==3 then --new explosion
   --local bs = overlapbombs(e.x-8,e.y-8,e.x+16,e.y+16)
   --for b in all(bs) do
   -- b.t=1 --chain explode
    --sfx(6)
   --end
   
   
    
   
   
   
 
 end
 end
   

 -- end
 
  
  
 
 



function _draw()
 cls(screen)
 --handle player animation
 p1.t+=1 --timer increases
 if p1.t>11 then p1.t=0 end
 

 
 --set sprite for player
 if p1.alive==false then
  p1.s=48 --blood frame
 elseif p1.kick>0 then
  p1.kick-=0.25
  p1.s=17+flr(p1.kick) --kick frames
 elseif p1.grounded==false then
  if p1.vy < 0 then
   p1.s=1 --jumping up
  else
   p1.s=1 --falling
  end


 else
  p1.s=1 --idle frame
 end
 
 
 --set sprite for player 2

 
  
 
 --draw player
 spr(p1.s,p1.x,p1.y,1,1,p1.f)
 spr(block1.colr,block1.x,block1.y,1,1,p1.f)
spr(block2.colr,block2.x,block2.y,1,1,p1.f)
spr(block3.colr,block3.x,block3.y,1,1,p1.f)
spr(block4.colr,block4.x,block4.y,1,1,p1.f)
 spr(block5.colr,block5.x,block5.y,1,1,p1.f)
 spr(block6.colr,block6.x,block6.y,1,1,p1.f)
spr(block7.colr,block7.x,block7.y,1,1,p1.f) 
 spr(block8.colr,block8.x,block8.y,1,1,p1.f)
 spr(block9.colr,block9.x,block9.y,1,1,p1.f)
spr(block10.colr,block10.x,block10.y,1,1,p1.f)
spr(block11.colr,block11.x,block11.y,1,1,p1.f)
spr(block12.colr,block12.x,block12.y,1,1,p1.f)
spr(block13.colr,block13.x,block13.y,1,1,p1.f)
spr(block14.colr,block14.x,block14.y,1,1,p1.f)
spr(block15.colr,block15.x,block15.y,1,1,p1.f)
spr(block16.colr,block16.x,block16.y,1,1,p1.f)
spr(blast.s,blast.x,blast.y,2,2,p1.f)


print(l1text,35,lettersy,pletter)
print(l2text,39,lettersy,aletter)
print(l3text,43,lettersy,iletter)
print(l4text,47,lettersy,nletter)
print(l5text,51,lettersy,tletter)
print(l6text,55,lettersy,spletter)
print(l7text,59,lettersy,i2letter)
print(l8text,63,lettersy,t2letter)
print(l9text,67,lettersy,sp2letter)
print(l10text,71,lettersy,bletter)
print(l11text,75,lettersy,lletter)
print(l12text,79,lettersy,uletter)
print(l13text,83,lettersy,eletter)
 --draw bombs
 for b in all(bombs) do
  b.t-=1 --update timer
  if b.t>0 then
 	 --set frame from timer
  	local f=32+flr(b.t/timebetweenbombs*2)
  	spr(32,b.x,b.y)
  	if (f>32) then 
  	 emitspark(b.x+7,b.y+2,1)
  	end
  elseif b.t==0 then
   addexplosion(b.x,b.y)
  end
 end 
 
 --draw the tilemap

  palt(0,t)
 map(0,0,0,0,16,16)

 --draw sparks
 for s in all(sparks) do
  if s.life>0 then  
   --first update positions
   s.vy+=gravity
   s.x+=s.vx
   s.y+=s.vy
   --draw a pixel
   pset(s.x,s.y,sparkcols[s.life])
   s.life-=1 --update life
  end
 end
 
 --draw explosions
 for e in all(explosions) do
  if e.t >0 then
   e.t -=1 --update the timer
   spr(23+e.t*3,e.x-8,e.y-8,3,3)
  end
 end
 
 --draw text

end
__gfx__
0000000000111100000000000000000000000000cccccccc33333333222222228888888899999999dddddddd0000000000000000000000000000000000000000
0000000001cccc10000555500005555000000000cccccccc33333333222222228888888899999999dddddddd0000000000000000000000000000000000000000
007007001cccccc100055f0000055f0000000000cccccccc33333333222222228888888899999999dddddddd0000000000000000000000000000000000000000
000770001cccccc10005ff000005ff0000000000cccccccc33333333222222228888888899999999dddddddd0000000000000000000000000000000000000000
000770001cccccc1000fff00000fff0000000000cccccccc33333333222222228888888899999999dddddddd0000000000000000000000000000000000000000
007007001cccccc10066f6600006f60000000000cccccccc33333333222222228888888899999999dddddddd0000000000000000000000000000000000000000
0000000001cccc100f06660f000f660000000000cccccccc33333333222222228888888899999999dddddddd0000000000000000000000000000000000000000
0000000000111100000666000006f60000000000cccccccc33333333222222228888888899999999dddddddd0000000000000000000000000000000000000000
66666666000000000001110000011600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66666666000000000010001000001100000000000000000000500000000000000000000000000000000000000000000000000000000000000000000000000000
66666666000000000f00000f00011f000000000011110000005fff00000000000000000000000000000000000000000000000000000000000000000000000000
6666666600000000000000000000000047777771111111114755ff11111001110000000000000000000000000000000000000000000000000000000000000000
6666666600000000000000000000000047777111111111114755f111111111110000000000000000000000000000000000000000000000000000000000000000
66666666000000000000000000000000477771111111111447777111111111140000000000000000000000000000000000000000000000000000000000000000
66666666000000000000000000000000444444444444411444444444444444440000000000000000000000000000000000000000000000000000000000000000
66666666000000000000000000000000440000000000004444000000000000440000000000000000000000000000000000000000000000000000000000000000
555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c0000000000000010
5555555500000000000000000000000000000000000000000000000000000000000000000000000000000000000c000000000000000000000000000000000000
5555555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c000000000000000000000000000000
555555550000000000000000000000000000000000000000000000000000000000000000000c0000000000000000c00000000000000000000000000000000000
555555550000000000000000000000000000000000000000000000000000000000000000000c000000c000000000000000000000000000000000000000000000
55555555000000000000000000000000000000000000000000000c00000000000000cc0000000000000000000000000000000000000000000000000000000000
5555555500000000000000000000000000000000000000000000cc00c00000000000000000000000000000000000000000000000000000000000000000000000
555555550000000000000000000000000000000cc000000000000000cc0000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000cc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000cc0000c0000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000c000cc0000000000000000cc0000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000c00000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000c00000000c000000c00000000000c0000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000c00000000000000000c00000000000000000000100000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c0000000000c000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100
__gff__
0000000000030303030303000000000003000000030303030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000070717273707172737071727300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000040414243000000004041424340414243000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000050515253000000005051525350515253000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f0f000f60616263000000006061626360616263000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f0f0f0f707172730f0000007071727370717273000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4041424340414243404142434041424340414243404142430000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5051525350515253505152535051525350515253505152530000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6061626360616263606162636061626360616263606162630000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7071727370717273707172737071727370717273707172730000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4041424340414243404142434041424340414243000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5051525350515253505152535051525350515253000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6061626360616263606162636061626360616263000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7071727370717273707172737071727370717273000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4041424340414243404142434041424300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5051525350515253505152535051525300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6061626360616263606162636061626300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7071727370717273707172737071727300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4041424300000000404142434041424300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5051525300000000505152535051525300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6061626300000000606162636061626300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7071727300000000707172737071727300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
