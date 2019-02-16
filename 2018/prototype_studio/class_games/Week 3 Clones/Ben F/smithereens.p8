pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- kareen -- by ben fried


p1health = 10
p2health = 10
p1power = 0
p1launchpower = 0
p1firing = false
--set up a player object
p1={x=10,y=96,w=8,h=8,vx=0,
vy=0,rx=0,ry=0,s=21,f=false,t=0,
grounded=false,kick=0,alive=true}

--set up a catapult object
p1pult={x=14,y=96,w=8,h=8,vx=0,
vy=0,rx=0,ry=0,s=22,f=false,t=0,
grounded=false,kick=0,alive=true}

p1wall={x=24,y=96,w=8,h=8,vx=0,
vy=0,rx=0,ry=0,s=1,f=false,t=0,
healh=10,healthvis,kick=0,alive=true}


--set up a player 2 object
p2={x=110,y=96,w=8,h=8,vx=0,
vy=0,rx=0,ry=0,s=5,f=false,t=0,
grounded=false,kick=0,alive=true}


--set up a catapult 2 object
p2pult={x=106,y=96,w=8,h=8,vx=0,
vy=0,rx=0,ry=0,s=6,f=false,t=0,
grounded=false,kick=0,alive=true}


map_w = 16
map_h = 16

p1walls={}
p1balls={}
p2walls={}
p2balls={}


function _init()

cls()

pal (0)

 for i=0,100 do  
  add(p1walls,{
   x=0,y=0,vx=0,vy=0,rx=0,ry=0,
   grounded=false,t=0
  })
  
     
  add(p1balls,{
   x=0,y=0,vx=0,vy=0,rx=0,ry=0,
   launched=false,glide=false,falling=false,t=0
  })
  
     
  add(p2walls,{
   x=0,y=0,vx=0,vy=0,rx=0,ry=0,
   grounded=false,t=0
  })
  
     
  add(p2balls,{
   x=0,y=0,vx=0,vy=0,rx=0,ry=0,
   grounded=false,t=0}
  )

end


end


function _update()

if btn(🅾️,0) == true and p1power < 100
and p1firing == false then

p1power=p1power + 1

else 




end

if btn(🅾️,0) == false and p1power > 0 then

p1firing = true

end

end


function _draw()

cls()
palt(0,true)

map(0,0,0,0,map_w,map_h)


 spr(p1.s,p1.x,p1.y,1,1,p1.f)
 spr(p2.s,p2.x,p2.y,1,1,p2.f)
 spr(p1pult.s,p1pult.x,p1pult.y,1,1,p1pult.f)
 spr(p2pult.s,p2pult.x,p2pult.y,1,1,p2pult.f)
 sspr(p1health,8,p1health + 10,16,p1wall.x,p1wall.y)
 print(p1power,50,50,7)
end
__gfx__
00000000000000000000000000000000000000000000000000000007000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000077000000000000000000000000000000000000000000000000000000000000000000000000
0070070000000000000000000000000000070000000000cc00000770000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000007777000000000c00007700000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000007770000000cccc07777700000000000000000000000000000000000000000000000000000000000000000000000000
0070070000000000000000000000000000077000000000cc07000700000700000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000cc77000070777777700000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000ccc70000077700077770000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000007000000000000000bbbbbbbbcbbbbbbbcccccccc00000000bbbbbbbc000000000000000000000000
0000000000000000000000000000000000000000000000007700000000000000bbbbbbbbccbbbbbbcccccccc00000000bbbbbbcc000000000000000000000000
0000000000000000000000000000000000007000880000000770000000000000bbbbbbbbcccbbbbbcccccccc00000000bbbbbccc000000000000000000000000
0000000000000000000000000000000000777700800000000077000000000000bbbbbbbbccccbbbbcccccccc00000000bbbbcccc000000000000000000000000
0000000000000000000000000000000000077700888800000077777000000000bbbbbbbbcccccbbbcccccccc000cc00cbbbccccc000000000000000000000000
0000000000000000000000000000000000077000880000000070007000007000bbbbbbbbccccccbbccccccccccccccccbbcccccc000000000000000000000000
0000000000000000000000000000000000000000880000000700007707777777bbbbbbbbcccccccccccccccccccccccccccccccc000000000000000000000000
0000000000000000000000000000000000000000888000007700000777770007bbbbbbbbcccccccccccccccccccccccccccccccc000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000ffffffff5000000000000000000000000000000000000005ffffffff0000000000000000000000000000000000000000000000000000000000000000
00000000ffffffff555000000000000000000000000000000000055fffffffff0000000000000000000000000000000000000000000000000000000000000000
00000000ffffffffff500000000000000000000000000000000005ffffffffff0000000000000000000000000000000000000000000000000000000000000000
00000000ffffffffff555000000000000000000000000000000555ffffffffff0000000000000000000000000000000000000000000000000000000000000000
00000000ffffffffff0f55005500000000000000000000550055f0ffffffffff0000000000000000000000000000000000000000000000000000000000000000
00000000ffffffff5fff55500f50000000000000000005f00555fff5ffffffff0000000000000000000000000000000000000000000000000000000000000000
00000000ffffffff0fff0f5055050000000000000000505505f0fff0ffffffff0000000000000000000000000000000000000000000000000000000000000000
00000000ffffffffffffff5500f500000000000000005f0055ffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
__label__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000097f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000a777e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000b7d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007777077770077700777700000777700c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07707700770077000770770000070070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07777700770077000770770770777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07700000770077000770770000770070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07700007777077770777700000777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66606660066006600000666000006660000066000000660066000660000000000000000000000000000000000000000000000000000000000000000000000000
60600600600060600000606000006060000006000000060006006000000000000000000000000000000000000000000000000000000000000000000000000000
66600600600060606660666000006060000006000000060006006000000000000000000000000000000000000000000000000000000000000000000000000000
60000600600060600000606000006060000006000000060006006060000000000000000000000000000000000000000000000000000000000000000000000000
60006660066066000000666000006660060066600600666066606660000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06000660060000006660666066006060000066006660000060006660606066606000066066606660600066600000066066606660666006600000600060006660
60006000006000000060606006006060000006006060000060006000606060606000606060006000600060000000600060606660600060000000600060006060
60006000006000006660606006006660666006006660000060006600060066606000606066006600600066000000600066606060660066600000600060006660
60006000006000006000606006000060000006006060000060006000606060606000606060006000600060000000606060606060600000600000600060006000
06000660060000006660666066600060000066606660000066606660606060606660660060006000666066600000666060606060666066000000666066606000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66606060666066600000606066606000666000006660066066600000606066606000666000000000000000000000000000000000000000000000000000000000
06006060606060000000606060006000606000006000606060600000606060006000606000000000000000000000000000000000000000000000000000000000
06006660666066000000666066006000666000006600606066000000666066006000666000000000000000000000000000000000000000000000000000000000
06000060600060000000606060006000600000006000606060600000606060006000600000000000000000000000000000000000000000000000000000000000
06006660600066600000606066606660600000006000660060600000606066606660600000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70000000777070707700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07000000707070707070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700000770070707070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07000000707070707070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70000000707007707070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3b3b3b3b3b3b3b3b3b3b3b3b0000000000000000000000131300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000131300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000a0a12120a0a0a000036310000000000001313000000130013000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a0a0a1231320a0a0a3631310a0a000000000000000000000013000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1818181818181c1a1a1918181818181818181813131313131313131300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1818181818181818181818181818181818181313131313131313131300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1818181818181818181818181818181818181813131313131313131300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1818181818181818181818181818181818181813131313131313130000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000002c2c2c2c2c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000002c2c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000