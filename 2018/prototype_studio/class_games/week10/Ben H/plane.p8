pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
--▤★plane★▤
--ben haderle,2018

--cam
cam={x=0,y=0}
--plane
p={x=63,y=63,r=0,a=.1,dx=0,dy=1,
   sx=0,sy=0,g=false,f=29}
h=5000
--jet
j={}
jx=0
jy=0

cloud1={}
cloud2={}
cloud3={}
cloud4={}

--instantiating clouds
for i=1,10 do
	add(cloud1,{x=rnd(127)-18,
	            y=rnd(127),
	            s=flr(rnd(4))+28,
	            sp=rnd()/4})
	add(cloud2,{x=rnd(127),
	            y=rnd(127),
	            s=flr(rnd(4))+28,
	            sp=rnd()/3})
	add(cloud3,{x=rnd(127),
	            y=rnd(127),
	            s=flr(rnd(4))+28,
	            sp=rnd()/2})
 add(cloud4,{x=rnd(127),
	            y=rnd(127),
	            s=flr(rnd(4))+28,
	            sp=rnd()})
end

--splash at the end
w={}
--over
over=false

function _update60()

	if p.y>5000 then
		p.sx=lerp(p.sx,0,.0166666)
		p.sy=lerp(p.sy,0,.0083333)
		p.x+=p.sx
		p.y+=p.sy
		add(w,{x=rnd(12)+p.x-2,
		       y=5000-p.sy*10})
		for i=1,10 do
			cloud1[i].x+=.001
			cloud2[i].x+=.005
			cloud3[i].x+=.01
			cloud4[i].x+=.05
		end
		if p.sy<.01 then
			over=true
		end
		return
	end

	if btn(⬆️) and p.f>0 then
		p.g=true
	else
		p.g=false
	end
	p.sy+=p.a*.25
	if p.g then
		p.f-=.06666666
		p.sx+=p.dx*p.a
		p.sy+=p.dy*p.a
		cam.x+=p.sx-.001
		cam.y+=p.sy-.001
		add(j,{x=jx+rnd(4)-2,
			      y=jy+rnd(4)-2,
		       l=10})
	
	else
		p.r+=2
		p.r%=96
		p.sx/=1.001
		p.sy/=1.001
		cam.x=lerp(cam.x,p.x-59,.075)
		cam.y=lerp(cam.y,p.y-40,.075)
	end
	
	p.sx=clamp(p.sx,-1.5,1.5)
	p.sy=clamp(p.sy,-2,2)
	
	p.x+=p.sx
	p.y+=p.sy
end

function _draw()
	cls()
	

	
	camera(cam.x,cam.y)
	
	--map
	map(0,0,cam.x,cam.y,16,16)
	
	--drawing back layers of clouds\
	pal(7,5)
	for i,d in pairs(cloud1) do
		sspr((d.s-16)*8,8,8,8,d.x,d.y,40,40)
		d.y-=p.sy*.01
		d.x-=p.sx*.01
		--wrap at screen edge
  while d.x-cam.x>128 do d.x-=169 end
  while d.x-cam.x<-41 do d.x+=169 end
  while d.y-cam.y>128 do d.y-=169 end
  while d.y-cam.y<-41 do d.y+=169 end
	end
	pal()
	pal(7,6)
	for i,d in pairs(cloud2) do
		sspr((d.s-16)*8,8,8,8,d.x,d.y,24,24)
		d.y-=p.sy*.1
		d.x-=p.sx*.1
		while d.x-cam.x>128 do d.x-=169 end
  while d.x-cam.x<-41 do d.x+=169 end
  while d.y-cam.y>128 do d.y-=169 end
  while d.y-cam.y<-41 do d.y+=169 end
	end
	pal()
	for i,d in pairs(cloud3) do
		sspr((d.s-16)*8,8,8,8,d.x,d.y,16,16)
		d.y-=p.sy*.5
		d.x-=p.sx*.5
		while d.x-cam.x>128 do d.x-=169 end
  while d.x-cam.x<-41 do d.x+=169 end
  while d.y-cam.y>128 do d.y-=169 end
  while d.y-cam.y<-41 do d.y+=169 end
	end
	--draw plane
	local s=0
	local fx=false
	local fy=false
 
	if p.r<12 then
		s=1
		fx=false
		fy=false
		p.dx=0
		p.dy=-1
		jx=p.x+4
		jy=p.y+8
	elseif p.r<24 then
		s=3
		fx=false
		fy=false
		p.dx=.5
		p.dy=-.5
		jx=p.x
		jy=p.y+8
	elseif p.r<36 then
		s=2
		fx=false
		fy=false
		p.dx=1
		p.dy=0
		jx=p.x
		jy=p.y+4
	elseif p.r<48 then
		s=3
		fx=false
		fy=true
		p.dx=.5
		p.dy=.5
		jx=p.x
		jy=p.y
	elseif p.r<60 then
		s=1
		fx=false
		fy=true
		p.dx=0
		p.dy=1
		jx=p.x+4
		jy=p.y
	elseif p.r<72 then
		s=3
		fx=true
		fy=true
		p.dx=-.5
		p.dy=.5
		jx=p.x+8
		jy=p.y
	elseif p.r<84 then
		s=2
		fx=true
		fy=false
		p.dx=-1
		p.dy=0
		jx=p.x+8
		jy=p.y+4
	else
		s=3
		fx=true
		fy=false
		p.dx=-.5
		p.dy=-.5
		jx=p.x+8
		jy=p.y+8
	end
	
	--draw praticles
	for i,d in pairs(j) do
		pset(d.x,d.y,9)
		d.l-=1
		if d.l<0 then
			del(j,d)
		end
	end
	
	spr(s,p.x,p.y,1,1,fx,fy)
	
	--lsat layer of clouds
	for i,d in pairs(cloud4) do
		sspr((d.s-16)*8,8,8,8,d.x,d.y,8,8)
		d.y-=p.sy*1.1
		d.x-=p.sx*1.1
		while d.x-cam.x>128 do d.x-=169 end
  while d.x-cam.x<-41 do d.x+=169 end
  while d.y-cam.y>128 do d.y-=169 end
  while d.y-cam.y<-41 do d.y+=169 end
	end
	
	--splash
	for i,d in pairs(w) do
		rect(d.x,d.y,d.x,5000,7)
		d.y+=.5
	end
	
	--water
	rectfill(cam.x,5000,cam.x+127,5100,12)
	
	if over then
		spr(18,cam.x+48,5002,5,2)
		printmessage("your impact depth was "..h,
		             cam.y+60,8)
	 local s
		if h>-100 then
			s="soft as a pillow"
		elseif h>-250 then
			s="minor bruises"
		elseif h>-500 then
			s="broken plane, broken bones, broken dreams"
		elseif h>-750 then
			s="the world is still spinning "
		else
			s="don't ever let me fly again"
		end
		printmessage(s,cam.y+90,9)
	end
	
	--ui
	rectfill(cam.x+110,cam.y,
	         cam.x+127,cam.y+6,6)
	rectfill(cam.x+110,cam.y+7,
			       cam.x+127,cam.y+40,6)
	rectfill(cam.x+112,cam.y+9,
	         cam.x+125,cam.y+38,5)
	rectfill(cam.x+112,cam.y+38-p.f,
	         cam.x+125,cam.y+38,9)
	h=flr(h-p.sy)
	print(h,cam.x+111,cam.y+1,8)
	
end
-->8
--math,print functions
function clamp(i,l,g) 
 if i<l then
 	i=l
 elseif i>g then
 	i=g
 end
 return i
end

function lerp(a,b,t)
 return a*(1-t) + b*t 
end


function printmessage(s,y,c)
	if #s>100 then
		split=findsplit(s)
		local s2=sub(s,split+1,#s)
		s=sub(s,1,split-1)
		print(s,64-#s*2+cam.x,y,
		      c)
		print(s2,64-#s2*2+cam.x,y+8,
		      c)
	else
		print(s,64-#s*2+cam.x,y,c)
	end
end

function findsplit(str)
	for i=#str/2,#str do
    local c=sub(str,i,i)
    if c==" " then
    	return i
    end
	end
	return #str/2
end
__gfx__
0000000000088000000000000d000008000000000000000000000000000000000000000000000000000000000000000000000000ffffffff0000000000000000
0000000000666600000000000ddd0660000000000000000000000000000000000000000000000000000000000000000000000000ffffffff0000000000000000
00700700ddd66ddd00000000000d6660000000000000000000000000000000000000000000000000000000000000000000000000ffffffff0000000000000000
000770000d6666d0d000066000666600000000000000000000000000000000000000000000000000000000000000000000000000ffffffff0000000000000000
0007700000666600dd66666800666dd0000000000000000000000000000000000000000000000000000000000000000000000000ffffffff0000000000000000
0070070000066000066dd660066660d0000000000000000000000000000000000000000000000000000000000000000000000000ffffffff0000000000000000
00000000000dd000000dd0000d6000dd000000000000000000000000000000000000000000000000000000000000000000000000ffffffff0000000000000000
000000000000d00000000000d0000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffff0000000000000000
00000000000000000000000000000000880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000666000000000000000000000000000000000000000000000000000000000000000007000000000000077000000000000
00000000000000000060000000000000000000000000600000000000000000000000000000000000000000000000000000777700000770000777700000077700
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007777700007777000077770000777700
00000000000000000060660000000000000000000060006000000000000000000000000000000000000000000000000007777770077777770000777000777770
00000000000000000000000000000000000000000000600000000000000000000000000000000000000000000000000000777770007770000000070007777770
00000000000000000000060000000000000000000000000000000000000000000000000000000000000000000000000000007700000000000000000000000000
00000000000000000066000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000d00000000004400000000000d0000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000660000ddd000000045540000000000dd600000060000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000060000d00000000ff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000060066000000000000660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000060000000000000004444000000000000000000000060000000000000000000000000000000000000000000000000000000000000000000
00000000000000000060000600000000040000400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000400000040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff666666666666666666
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff686868886888688866
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff686866686868666866
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff688866686888668866
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff666866686668666866
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff666866686668688866
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff666666666666666666
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff666666666666666666
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff666666666666666666
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff669999999999999966
fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff777777fffffffffffffffffffff669999999999999966
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff77f777777fffffffffffffffffffff669999999999999966
fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff7777777777fffffffffffffffffffff669999999999999966
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff777777777fffffffffffffffffffff669999999999999966
fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff7777777777fffffffffffffffffff669999999999999966
fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff7777777777fffffffffffffffffff669999999999999966
fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff777777777777fffffffffffffffffff669999999999999966
fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff777777777777fffffffffffffffffff669999999999999966
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff669999999999999966
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff669999999999999966
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff669999999999999966
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff669999999999999966
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff669999999999999966
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff669999999999999966
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff669999999999999966
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff669999999999999966
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff777777ff669999999999999966
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff777777ff669999999999999966
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff77777777ff669999999999999966
fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff677777777ff669999999999999966
fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff67777777777669999999999999966
fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff7777777777777669999999999999966
fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff66667777777777777669999999999999966
fffffffffffffffffffffffffffff666fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff66777777777777777669999999999999966
fffffffffffffffffffffffffffff666fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff667777777766fffff669999999999999966
fffffffffffffffffffffffffffff666ffffffffffffffffffffffffffffffffffffffffffffffffffffffffff66677777777777777fff669999999999999966
fffffffffffffffffffffff666666666666fffffffffffffffffffffffffffffffffffffffffffffffffffffff66677777777777777fff669999999999999966
fffffffffffffffffffffff666666666666fffffffffffffffffffffffffffffffffffffffffffffffffffffff666667777776666fffff669999999999999966
fffffffffffffffffffffff666666666666fffffffffffffffffffffffffffffffffffffffffffffffffffffff666667777776666666ff669999999999999966
ffffffffffffffffffff666666666666666ffffffffffffffffffffffffffffffffff7777fffffffffffffffff666666666666666666ff666666666666666666
ffffffffffffffffffff666666666666666ffffffffffffffffffffffffffffffffff7777fffffffffffffffff666666666666666666ff666666666666666666
ffffffffffffffffffff666666666666666ffffffffffffffffffffffffffffffff77777777ffffffffffffffffff666666666666666fffffffffff777777fff
ffffffffffffffffffff666666666666666666f777777ffffffffffffffffffffff77777777ffffffffffffffff66666666666666666fffffffffff777777fff
ffffffffffffffffffff666666666666666666f777777ffffffffffffffffffffffff77777777ffffffffffffff66666666666666666fffffffff77777777fff
ffffffffffffffffffff6666666666666666677777777ffffffffffffffffffffffff77777777ffffffffffffff66666666666666ffffffffffff77777777fff
fffffffffffffffffffffff6666666666666677777777ffffffffffffffffffffffffffff777777fffffffff666666666666666666666ffffffff7777777777f
fffffffffffffffffffffff666666666666667777777777ffffffffffffffffffffffffff777777fffffffff666666666666666666666ffffffff7777777777f
fffffffffffffffffffffff666666666666667777777777ffffffffffffffffffffffffffff77fffffffffff666666666666666666666ffffff777777777777f
fffffffffffffffffffffffffffff666666777777777777ffffffffffffffffffffffffffff77ffffffffffffff666666666fffffffffffffff777777777777f
fffffffffffffffffffffffffffff666666777777777777ffffffffffffffffffffffffffffffffffffffffffff666666666ffffffffffffffffffffffffffff
fffffffffffffffffffffffffffff666666ffffffffffffffffffffffffffffffffffffffffffffffffffffffff666666666ffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffff666666ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffff666666ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffff666666ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffff666666667666fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffff666666777766fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffff666667777766fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffff667777776666ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffff666777776666ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffff666667766666ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffff666666666fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffff666666666fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffff666666666fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffff666ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffff666ffffffffffffffffffffffffffdfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffff666fffffffffffffffffffffffffddfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffff5555555555fffffffffffffffffffff66fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffff5555555555ffffffffffffffffffff6666ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffff5555555555fffffffffffffffffffd6666dfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffff5555555555ffffffffffffffffffddd66dddffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffff5555555555ffffffffffffffffff777666ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffff55555555555555555555ffffffffffff777788fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffff55555555555555555555ffffffffffff77777ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffff55555555555555555555fffffffffff777777ffffffffffffffffffffffffffffffffffffffffffffffffffffffff777fffff
fffffffffffffffffffffffffff55557555555555555555fffffffffffffffffffffff666666fffffffffffffffffffffffffffffffffffffffffff7777fffff
5555555555fffffffffffffffff55777755555555555555fffffffffffffffffffffff666666ffffffffffffffffffffffffffffffffff55555555577777ffff
5555555555ffffffffffffffffff777775555555555555555555ffffffffffffffffff666666ffffffffffffffffffffffffffffffffff55555555777777ffff
5555555555ffffffffffffffffff777777555555555555555555fffffffffffffff666666666666fffffffffffffffffffffffffffffff5555555555ffffffff
5555555555fffffffffffffffffff77777555555555555555555fffffffffffffff666666666666fffffffffffffffffffffffffffffff5555555555ffffffff
5555555555ffffffffffffffffff77f775555555555555555555fffffffffffffff666666666666fffffffffffffffffffffffffffffff5555555555ffffffff
555555555555555ffffffffffff7777f55555555555555555555ffffffffffff666666666666666666666ffffffffffffffffffff55555555555555555555fff
555555555555555fffffffffffff7777ffffffffff555555555555555fffffff666666666666666666666ffffffffffffffffffff55555555555555555555fff
555555555555555fffffffffffffff777fffffffff555555555555555fffffff666666666666666666666ffffffffffffffffffff55555555555555555555fff
555555555555555ffffffffffffffff7ffffffffff555555555555555ffffffffff666666666fffffffffffffffffffffffffffff55555555555555555555fff
555555555555555fffffffffffffffffffffffffff555555555555555ffffffffff666666666fffffffffffffffffffffffffffff55555555555555555555fff
55555555555555555555ffffffffffffffffffffff555555555555555ffffffffff666666666ffffffffffffffffffffffff5555555555555555555555555555
55555555555555555555fffffffffffffffffffffffffff5555555555555555ffffff55555ffffffffffffffffffffffffff5555555555555555555555555555
55555555555555555555fffffffffffffffffffffffffff5555555555555555ffffff55555ffffffffffffffffffffffffff5555555555555555555555555555
55555555555555555555fffffffffffffffffffffffffff5555555555555555ffffff55555ffffffffffffffffffffffffff5555555555555555555555555555
55555555555555555555fffffffffffffffffffffffffff5555555555555555ffffff55555ffffffffffffffffffffffffff5555555555555555555555555555
ffffffffff555555555555555ffffffffffffff555555555555555555555555ffffff55555fffffffffffffffffffffffffffffff555555555555555ffffffff
ffffffffff555555555555555ffffffffffffff5555555555555555555555555555555555555555ffffffffffffffffffffff6666666665555555555ffffffff
ffffffffff555555555555555ffffffffffffff5666666555555555555555555555555555555555ffffffffffffffffffffff6666666665555555555ffffffff
ffffffffff555555555555555ffffffffffffff5666666555555555555555566666666655555555fffffffffffffff55555ff666666666555555557777ffffff
ffffffffff555555555555555ffffffffffffff5666666555555555555555566666666655555555fffffffffffffff5555666666666666555555557777ffffff
fffffffffffffff55555ffffffffffffff555666666666666555555555555566666666655555555fffffffffffffff5555667766666666ffffff77777777ffff
fffffffffffffff55555ffffffffffffff555666666666666555555555566666666666655555555fffffffffffffff5555677776666666ffffff77777777ffff
fffffffffffffff55555ffffffffffffff555666666666666555555555566666666666655555555fffffffffffffff5555667777666666666fffff77777777ff
fffffffffffffff55555ffffffffffffff555555666666666666555555566666666666655555555fffff55555555555555666677766666666fffff77777777ff
fffffffffffffff55555ffffffffffffff555555666666666666555555566666666666666655555fffff55555555555555666667666666666fffffffff777777
fffffffffffffffffffffffffffff55555555555666666666666555555566666666666666655555fffff55555555555666666666666666666fffffffff777777
fffffffffffffffffffffffffffff555555555555555556666666665555666666666666666555555555555555555555666666666666666666fffffffffff77ff
fffffffffffffffffffffffffffff555555555555555556666666665666666666666666666666655555555555555555666666666666666666fffffffffff77ff
fffffffffffffffffffffffffffff555555555555555556666666665666666666666666666666655555555555555555555555555ffffffffffffffffffffffff
fffffffffffffffffffffffffffff555555555555555555556665555666666666666666666666655555555555555555555555555ffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffff5555555555555556665555555555555555566666666666655555555555555555555555fffffffffff7777fffffffff
ffffffffffffffffffffffffffffffffff555555555555555666fffffff555555555566666666666655555555555555555555555fffffffffff7777fffffffff
ffffffffffffffffffffffffffffffffff555555555555555ffffffffff555555555566666666666655555555555555555555555fffffffff77777777ff777ff
ffffffffffffffffffffffffffffffffff555555555555555ffffffffff55555556666666666666666666665555555555555555555555ffff77777777f7777ff
ffffffffffffffffffffffffffffffffff555555555555555ffffffffff55555556666666666666666666665555555555555555555555ffffff777777777777f
fffffffffffffffffffffffffffffffffffffffffffffffffffffffffff55555556666666666666666666665555555555555555555555ffffff777777777777f
fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff5555556666666665555555555555555555555555555555ffffffffff777777fff
fffffffffffff666666ffffffffffffffffffffffffffffffffffffffffffff5555556666666665555555555555555555555555555555ffffffffff777777fff
fffffffffffff666666ffffffffffffffffffffffffffffffffffffffffffff5555556666666665fffff5555555555555555555555555ffffffffffff77fffff
fffffffffffff666666fffffffffffffffffffffffffffffffffffffff555555555555555555555fffff5555555555555555555555555ffffffffffff77fffff
ffffffffff666666666666ffffffffffffffffffffffffffffffffffff555555555555555555555fffff5555555555555555555555555fffffffffff55555555
ffffffffff666666666666ffffffffffffffffffffffffffffffffffff55555555555555555555ffffff5555555555555555555555555fffffffffff55555555
ffffffffff666666666666ffffffffffffffffffffffffffffffffffff55555555555555555555ffffff5555555555555555555555555fffffffffff55555555
fffffffffffff666666666666fffffffffffffffffffffffffffffffff55555555555555555555ffffffffffffffff5555555555ffffffffffffffff55555555
fffffffffffff666666666666fffffffffffffffffffffffffffffffff5555555555555555555555555fffffffffff5555555555ffffffffffffffff55555555
fffffffffffff666666666666fffffffffffffffffffffffffffffffff5555555555555555555555555fffffffffff5555555555fffffffffff5555555555555
fffffffffffffffffff666666666ffffffffffffffffffffffffffffff5555555555555555555555555fffffffffff5555555555fffffffffff5555555555555
fffffffffffffffffff666666666ffffffffffffffffffffffffffffff5555555555555555555555555fffffffffff5555555555fffffffffff5555555555555
fffffffffffffffffff666666666ffffffffffffffffffffffffffffff5555555555555555555555555ffffffffffffffffffffffffffffffff5555555555555
ffffffffffffffffffffff666ffffffffffffffffffffffffffff555555555555555555555555555555ffffffffffffffffffffffffffffffff5555555555555
ffffffffffffffffffffff666ffffffffffffffffffffffffffff555555555555555555555555555555ffffffffffffffffffffffffffffffff5555555555555

__map__
0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
