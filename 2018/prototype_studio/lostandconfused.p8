pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
--game name
--by marcus zaeyen

--game loop

world={}

function _init()

	--transparencies
	palt(11,true)
	palt(0,false)
	
	add(world,p)
	
	add(world,hand:new(p.x+17,110,0))
	add(world,hand:new(p.x+5,110,1))
	
end

function _update60()
	for o in all(world) do
		if o.update~=nil then
			o:update()
		end
	end
	smokecontroller:update()
end

function _draw()
	cls(2)
	map(0,0,0,0,16,16)
	
	for o in all(world) do
		if o.draw~= nil then
			o:draw()
		end
	end
	
	smokecontroller:draw()

end
-->8
--object definitions

hand = {
	x=54,
	y=72,
	xo=54,
	yo=72,
	d=32,
	i=0,
	speed=0.5,
	new=function(self,x,y,i)
		o={}
		setmetatable(o,self)
		self.__index=self
		
		o.x=x
		o.xo=x
		o.yo=y
		o.y=y
		o.i=i
		
		return o
	end,
	draw=function(self)
		line(self.x,self.y,self.xo,self.yo,0)
		circfill(self.x,self.y,2,15)		
	end,
	update=function(self)
		if btn(⬅️, self.i) then
			self.x=easeout(self.x,self.xo-self.d,self.speed)
		elseif btn(➡️,self.i) then
			self.x=easeout(self.x,self.xo+self.d,self.speed)
		else
			self.x=easeout(self.x,self.xo,self.speed)
		end
		if btn(⬆️,self.i) then
			self.y=easeout(self.y,self.yo-self.d,self.speed)
		elseif btn(⬇️,self.i) then
			self.y=easeout(self.y,self.yo+self.d,self.speed)
		else
			self.y=easeout(self.y,self.yo,self.speed)
		end
	end
}

p = {
	x=32,
	y=96,
	draw=function(self)
		spr(1,self.x,self.y,3,4)
	end
}

smokecontroller = {
	delta=60/80, --80 bpm
	timer=0,
	particles={},
	exhalelen=7,
	exhaletimer=0,
	update=function(self)
		--print(self.exhaletimer,64,64,0)
		self.timer+=1/60
		if self.timer>=self.delta then
			self.timer=0
			if self.exhaletimer>0 then
				self.exhaletimer-=1
				add(self.particles,smoke:new())
			elseif rnd()<.10 then
				self.exhaletimer=
					self.exhalelen+flr(rnd(5))
			end
			for p in all(self.particles) do
				p:update()
			end
		end
	end,
	draw=function(self)
		for p in all(self.particles) do
			p:draw()
		end
	end
}

smoke = {
	x=p.x+18,
	y=p.y+7,
	odd=false,
	
	new=function(self)
		--all smoke particles are 
		--made identically
		o={}
		setmetatable(o,self)
		self.__index=self
		return o
	end,
	update=function(self)
		if self.odd then
			self.x+=1
		else
			self.x-=1
		end
		self.odd= not self.odd
		self.y-=1
		if self.y<p.y-3 then
			--add(smokecontroller.particles,smoke:new())
			del(smokecontroller,particles,self)
		end
	end,
	draw=function(self)
		pset(self.x,self.y,6)
	end
}
-->8
--utility functions

function lerp(a,b,t)
	return a + t*(b-a)
end

function invlerp(a,b,x)
	return (x-a)/(b-a)
end

function easeout(a,b,curr)
	local percent=invlerp(a,b,curr)
	return a+(1-(1-percent)*(1-percent))
end
__gfx__
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bb7bb7bbbbbbbbbbbb444bbbbbbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbb77bbbbbbbbbbbb44444bbbbbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbb77bbbbbbbbbbb1444441bbbbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bb7bb7bbbbbbbb44111111144bbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbb444444444bbbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbbb55556678bbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbb0fffff0bbbbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbb000000000bbbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbb00071117000bbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbb00077177000bbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbb00071117000bbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbb00071117000bbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbb00071117000bbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbb00071117000bbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbb00071117000bbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbb00071117000bbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbb00077177000bbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbb0000aa00000bbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbb00044444000bbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbb00044444000bbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbb00044444000bbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbb00044444000bbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbb00044044000bbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbb044404440bbbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbb44440444bbbbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbb44440444bbbbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbb44440444bbbbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbb444400400bbbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbb0000060060bbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbb0000000000bbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
