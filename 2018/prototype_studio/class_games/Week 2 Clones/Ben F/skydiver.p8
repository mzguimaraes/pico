pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
--sky diver
--by ben fried

map_w = 16
map_h = 16
dropped = 0
redisfalling = 0
chutereleased = 0
landed = 0
score = 0
done = 0
movingright = 0
round = 1
gameover = 0





redplane={x=120,y=20,w=8,h=8,vx=0,
vy=0,rx=0,ry=0,s=1,f=false,t=0,
grounded=false,kick=0,alive=true}

redtarget={x=50,y=117,w=8,h=8,vx=0,
vy=0,rx=0,ry=0,s=1,f=false,t=0,
grounded=false,kick=0,alive=true}

redfalling={x=500,y=0,w=8,h=8,vx=0,
vy=0,rx=0,ry=0,s=36,f=false,t=0,
grounded=false,kick=0,alive=true}

function _init()

cls()

pal (0)

end

function _update60()

redplane.x=redplane.x -0.3
if redplane.x <=-20 and dropped == 0 then
redplane.x = 120
end

if btnp(🅾️,0) and dropped == 0 then
   dropped = 1
   redfalling.x=redplane.x+10
   redfalling.y=redplane.y
   end
   
if btnp(❎,0) and dropped == 1 then
  chutereleased = 1
  redfalling.s = 35
   end
   
if btnp(⬅️,0) and chutereleased == 1 and landed == 0 then
redfalling.x = redfalling.x - 1
end

if btnp(➡️,0) and chutereleased == 1 and landed == 0 then
redfalling.x = redfalling.x + 1
end 
   
if dropped == 1 and chutereleased == 0 then

redfalling.y = redfalling.y + 2
redfalling.x = redfalling.x - 0.2
score = score + 1
end


if done == 0 and movingright == 0 then
redtarget.x = redtarget.x + round - 0.5
end

if done == 0 and movingright == 1 then
redtarget.x = redtarget.x - round + 0.5
end



if dropped == 1 and chutereleased == 1 then

redfalling.y = redfalling.y + 0.4

end



if redfalling.y >= flr(115) and redfalling.x <= redtarget.x - 20 and
redfalling.x >= redtarget.x + 20  then




end

if redfalling.y >= 120 then
gameover = 1
redtarget.y = 1000
redplane.y = 1000
round = 0
score = 0
end


if redfalling.x >= redtarget.x and
redfalling.x <= redtarget.x + 10 and redfalling.y >= flr(115)
and redfalling.y >= flr(115) and redtarget.y < 150 and redfalling.y < 120 then

round = round + 1
redfalling.x = 5000
dropped = 0
redisfalling = 0
chutereleased = 0
redfalling.s = 36
landed = 0
done = 0
movingright = 0

end

if redfalling.x <= redtarget.x and
redfalling.x >= redtarget.x + 20 
and redfalling.y >= flr(115) then

round = 0

redplane.y = 5000

gameover = 1
redtarget.y = 1000

end

if redfalling.y >= flr(115) then




end

if redfalling.s == 35 then
done = 1
end


if redtarget.x >= 120 then
movingright = 1
end

if redtarget.x <= 0 then
movingright = 0
end

if gameover == 1 then
print("gameover",50,50,7)

end

end

function _draw()

cls()
palt(0,true)

map(0,0,0,0,map_w,map_h)
sspr(0,8,24,16,redplane.x,redplane.y)
sspr(24,24,16,16,redtarget.x,redtarget.y)
spr(redfalling.s,redfalling.x,redfalling.y)
print(score,10,8,7)
print(round,38,15,7)
print("round: ",10,15,7)

if gameover == 1 then
print("gameover",50,50,7)

end

end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000ccccccc0cccc000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000c000cc11c000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000c0000000c0ccc11cc000000009999999999999999999999999999999999999999999999990000000000000000
000000000000000000000000000000000000000c00ccc1cccc111cc0000000009999999999999999999999999999999999997799999999990000000000000000
000000000000000000000000000000000000000ccc11c1111111cc00000000009999999999999999999999999999999999977779977779990000000000000000
000000000000000000000000000000000000000c0cccccccccccc000000000009999999999999999999999997999999999977777777779990000000000000000
000000000000000000000000000000000000000c0000000000000000000000009999999999999999999997777777799999977777777777990000000000000000
00000000000000000000000000000000000000000000000000000000000000009999999999999999977797777777779999977777777776990000000000000000
00000000000088888880888800000000000000000000000000000000000000009999999999999999977777777777777999777777777766990000000000000000
00000000000000080008822800000000000000000000000000000000000000009999999999999999777777777777777997777777777666990000000000000000
00000008000000080888228808888880000000000000000000000000000000009999999999999999667777777777779977777766666666690000000000000000
00000008008882888822288080000008000000000000000000000000000000009999999999999999966777777666669977777666666666690000000000000000
00000008882282222222880000000000000000000000000000000000000000009999999999999999996677776666669977776666996666990000000000000000
00000008088888888888800000088000000880000000000000000000000000009999999999999999999666666699999977766666999966990000000000000000
00000008000000000000000008088080000880000000000000000000000000009999999999999999999996666699999977769966999999990000000000000000
00000000000000000000000000888800088888800000000000000000000000009999999999999999999999999999999996699966999999990000000000000000
00000000000000000000000000088000000880000000000000000000000000009999999999999999999999999999999999999999999999990000000000000000
00000000000000000000000000800800088008800000000000000000000000009999999999999999999999999999999999999999999999990000000000000000
0000000000000000000000000000000000000000000000000000000000000000bbbbbbbb00000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000003333333300000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000003333333300000000000000000000000000000000000000000000000000000000
00000000000000000000000000778888888882000077cccccccc1100000000004444444400000000000000000000000000000000000000000000000000000000
00000000000000000000000007000000000000200700000000000010000000004444444400000000000000000000000000000000000000000000000000000000
00000000000000000000000070000000000000027000000000000001000000004444444400000000000000000000000000000000000000000000000000000000
00000000000000000000000007000000000000200700000000000010000000004444444400000000000000000000000000000000000000000000000000000000
000000000000000000000000008882222222220000ccc11111111100000000004444444400000000000000000000000000000000000000000000000000000000
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
70000000770077707070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07000000707070007070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700000707077007070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07000000707070007770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70000000707077707770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0ee0e0e0ee00eee0eee0e0e00000eee0eee0eee00ee0eee000000000000000000000000000000000000000000000000000000000000000000000000000000000
e000e0e0e0e00e00e0e0e0e00000e000e0e0e0e0e0e0e0e000000000000000000000000000000000000000000000000000000000000000000000000000000000
eee0eee0e0e00e00eee00e000000ee00ee00ee00e0e0ee0000000000000000000000000000000000000000000000000000000000000000000000000000000000
00e000e0e0e00e00e0e0e0e00000e000e0e0e0e0e0e0e0e000000000000000000000000000000000000000000000000000000000000000000000000000000000
ee00eee0e0e00e00e0e0e0e00000eee0e0e0e0e0ee00e0e000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70000000777070707700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07000000707070707070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700000770070707070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07000000707070707070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70000000707007707070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0ee0e0e0ee00eee0eee0e0e00000eee0eee0eee00ee0eee00000e000eee0ee00eee00000ee0000000e00eee0eee0eee00000eee00e0000000000000000000000
e000e0e0e0e00e00e0e0e0e00000e000e0e0e0e0e0e0e0e00000e0000e00e0e0e00000000e000000e0000e00e0e0e0e00000e0e000e000000000000000000000
eee0eee0e0e00e00eee00e000000ee00ee00ee00e0e0ee000000e0000e00e0e0ee0000000e000000e0000e00eee0ee000000e0e000e000000000000000000000
00e000e0e0e00e00e0e0e0e00000e000e0e0e0e0e0e0e0e00000e0000e00e0e0e00000000e000000e0000e00e0e0e0e00000e0e000e000000000000000000000
ee00eee0e0e00e00e0e0e0e00000eee0e0e0e0e0ee00e0e00000eee0eee0e0e0eee00000eee000000e000e00e0e0eee00000eee00e0000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07707070707000007700777070707770777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70007070707000007070070070707000707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77707700777000007070070070707700770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00707070007000007070070077707000707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77007070777000007770777007007770707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06606060660066606660606000006660666066600660666000006600666066606660000006006600666060606660666006000000000000000000000000000000
60006060606006006060606000006000606060606060606000006060600060606060000060006060060060606000606060000000000000000000000000000000
66606660606006006660060000006600660066006060660000006060660066606600000000006060060060606600660000000000000000000000000000000000
00600060606006006060606000006000606060606060606000006060600060606060000000006060060066606000606000000000000000000000000000000000
66006660606006006060606000006660606060606600606000006060666060606060000000006660666006006660606000000000000000000000000000000000
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

__map__
1819181818181818181818181818181818181818181818181818181818181818181829292929292918181818181818180000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1919191918181818181818191918181818181818181818181818181818181818181829292929292918181818181818180000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1919191918181818181818191918181818181818181818181818181818181818181829292929292918181818181818180000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1818181818181818181819191918181818181818181818181818181818181818181818181818181818181818181818181818181818181818000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1819181818181819191919181818181818181818181818181818181818181818181818181818181818181818181818181818181818181818000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1919181818181819191918181818181818181818181818181818181818181818181818181818181818181818181818181818181818181818000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1919181818181818181818181818181818181818181818181818181818181818181818181818181818181818181818181818181818181818000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1818181818181818181818181818181818181818181818181818181818181818181818181818181818181818181818181818181818181818000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2918181818181818181818181818181818181818181818181818181818181818181818181818181818181818181818181818181818181818000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2918181818181818181818181818181818181818181818181818181818181818181818181818181818181818181818181818181818181818000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2918181818181818181818181818181818181818181818181818181818181818181818181818181818181818182918180000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2918181818181818181818181818181818181818181818181818181818181818181818181818181818181818181818180000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2918181818181818181818181818181818181818181818181818181818181818181818181818181818181818181818180000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1818181818181818181818181818181818181818181818181818181818181818181818181818181818181818181818180000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1818181818282818181818181818181818181818181818181818181818181818181818181818181818181818181818180000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3838383838383838383838383838383818181818181818181818181818181818181818181818181818181818181818180000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1818181818181818181818181818181818181818181818181818181818181818181818181818181818181818181818180000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1818181818282818181818181818181818181818181818292929292929292918181818181818181818181818181818180000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1818181818181818181818181818181818181818181818292929292929292918181818181818181818181818181818180000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1818181818181818181818181818181818181818181818292929292929292918181818181818181818181818181818180000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1818181818181818181818181818181818181818181818181818181818181818181818181818181818181818181818180000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1818181818181818181818181818181818181818181818181818181818181818181818181818181818181818181818180000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1818181818181818181818181818181818181818181818181818181818181818181818181818181818181818181818180000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000001818181818181818181818000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
