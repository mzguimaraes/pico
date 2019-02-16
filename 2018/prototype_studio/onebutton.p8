pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
--sliver surfer
--by marcus zaeyen

function _init()
	player:init()
end

function _update60()

	player:update()
	cam:update()
	gamemgr:update()
	
	for s in all(stars) do
		s:update()
	end
	
	for b in all(bullets) do
		b:update()
	end
	
	for e in all(enemies) do
		e:update()
	end
	
	for w in all(walls) do
		w:update()
	end
	
	for p in all(particles) do
		p:update()
	end
	
	physics:update()
end

test=""
function _draw()
	cls()
	camera(cam.x,cam.y)
	
	--circfill(64,230,120,13)
	--circfill(64,230,118,12)
	
	for s in all(stars) do
		s:draw()
	end
	
	player:draw()
	
	for p in all(particles) do
		p:draw()
	end
		
	for e in all(enemies) do
		e:draw()
	end
	
	for w in all(walls) do
		w:draw()
	end
	
	for b in all(bullets) do
		b:draw()
	end
	
	--print score
	print("score: "..player.score,
		cam.x,cam.y,6)
	if gamemgr.gameover then
		print("game over!",0,8,6)
	end
	
	print(test,0,0,7)
	test=""
end
-->8
--object definitions

cam={x=0,y=0,stress=0,
	update=function(self)
		if self.stress>0 then
			local r = rnd()
			self.x=cos(r)*self.stress
			self.y=sin(r)*self.stress
			
			self.stress=lerp(self.stress,0,.15)
			if self.stress<.05 then
				self.stress=0
			end
		end
	end
}

gamemgr = {
	gameover=false,
	speedmult=1,
	speedmultstart=1,
	timer=0,
	spawntimer=0,
	dspawn=2,
	ddspawn=0.05,
	dspawnmin=0.5,
	
	init=function(self)
		for i=1,20 do
			local s = star:new()
			s.phys.x = rnd(128)
		end
	end,
	
	spawn=function(self)
		if rnd() > 0.2 then
			--enemy spawn
			enemy:new()
		else
			--wall spawn
			wall:new()
		end
	end,
	
	update=function(self)
		self.timer+=1/60
		self.spawntimer+=1/60
		if self.spawntimer>=self.dspawn then
			self:spawn()
			self.spawntimer=0
			self.dspawn=lerp(
				self.dspawn,self.dspawnmin,
				self.ddspawn)
		end
		self.speedmult=
			self.speedmultstart+(1/600)
		if rnd()<0.1 then
			star:new()
		end
	end

}

player = {
	phys=nil,
	btndown=false,
	jumpforce=-8,
	ymin=16,
	f=1,
	score=0,
	
	tail = {},
	
	init=function(self)
		self.phys=physicsbody:new{
			x=16, y=16, gravity=true
		}
		
		--create tail
		for i=self.phys.x,0,-1 do
			add(self.tail,
				{ x=i, y=self.phys.y+14 })
		end
	end,
	
	update=function(self)
		if gamemgr.gameover then
			return
		end
		--test=test.."dy: "..self.phys.dy.."\n"
		--test=test.."ddy: "..self.phys.ddy.."\n"
		self:input()
		if self.phys.y<self.ymin then
			--self.phys.dy=0
			self.phys.y=self.ymin+1
		end
		
		if p_hit() or self.phys.y>144 then
			self:destroy()
		end
	end,
	
	input=function(self)
		if gamemgr.gameover then 
			return 
		end
			--self.phys:addforce(
			--	0,self.phys.m*physics.gravity)
		if self.btndown then
			self.f=1
			if not btn(❎) then
					--jump
				self.btndown=false
				self.phys.gravity=true
				self:jump()
			end
		else
			self.f=3
			if btn(❎) then
				self.phys.dy=
					min(self.phys.dy/4,.5)
				self.btndown=true
				self.phys.gravity=false
			end
		end
	end,
	
	shoot=function(self)
		bullet:new()
		sfx(0)
	end,
	
	jump=function(self)
		--todo:
		--make sure jump in bounds
		local jf=self.jumpforce
		local g=physics.gravity
		local yi=self.phys.y
		local dy=self.phys.dy
		--stop(((-jf*jf)/(2*g))+yi,0,100)
		--if yi-((jf*jf)/(2*g))<
	--				self.ymin then
			--set jf to be in bounds
			--jf=-sqrt(2*g*(yi-self.ymin))
		--	test=test.."oob\n"
	--	end
		self.phys:addforce(0,jf)
		--cam.stress = 1
		self:shoot()
	end,
	
	draw=function(self)	
		--update tail
		for i=#self.tail,2,-1 do
			self.tail[i].y=self.tail[i-1].y
		end
		self.tail[1].y=
			flr(self.phys.y)+14

		--draw tail
		for i=1,#self.tail do
			--print("boop")
			local t=self.tail[i]
			--test=test..t.x.." "..t.y.."\n"
			pset(t.x,t.y,10)
			pset(t.x,t.y-1,10)
			pset(t.x,t.y+1,10)
			pset(t.x,t.y-2,9)
			pset(t.x,t.y+2,11)
			if i>1 then
				pset(t.x,t.y-3,9)
				pset(t.x,t.y+3,11)
				pset(t.x,t.y-4,8)
				pset(t.x,t.y+4,12)
			end
			if i>2 then
				pset(t.x,t.y-5,8)
				pset(t.x,t.y+5,12)
			end
		end
		
		--circfill(self.phys.x
		--	,self.phys.y,3,12)
		spr(self.f,self.phys.x,self.phys.y,
			2,2)
	end,
	
	destroy=function(self)
		for i=1,10 do
			particle:new(self.phys.x,
				self.phys.y,6)
		end
		--del(physics.bodies,self.phys)
		self.phys.gravity=true
		--self.phys:addforce(0,-1)
		gamemgr.gameover=true
		cam.stress=10
		sfx(3)
	end
	
}

bullets = {}

bullet = {
	phys={},
	r=4,
	
	new=function(self)
		local o = {}
		setmetatable(o,self)
		self.__index=self
		
		o.phys=physicsbody.new(physicsbody,
		{
			x=player.phys.x+12,
			y=player.phys.y+14,
			dx=2,
			gravity=false,
			mu=0
		})
		
		add(bullets,o)
		return o
	end,
	
	update=function(self)
		if self.phys.x>128+self.r then
			self:destroy()
			return
		end
		local hit = b_e_hit(self)
		if hit then
			hit:destroy()
			self:destroy()
		end
	end,
	
	draw=function(self)
		circfill(self.phys.x,
			self.phys.y,
			self.r,
			12
		)
	end,
	
	destroy=function(self)
		del(physics.bodies,self.phys)
		del(bullets,self)
	end
}

enemies = {}

enemy = {
	phys=nil,
	points=100,
	speed=-1.25,
	
	new=function(self)
		local o = {}
		setmetatable(o,self)
		self.__index=self
		
		o.phys=physicsbody:new{
			x = 150,
			dx=speed,
			y=player.ymin+2+flr(rnd(120-player.ymin)),
			mu=0,
			gravity=false
		}
		
		add(enemies,o)
		return o
	end,
	
	update=function(self)
		if self.phys.x<0 then
			del(enemies,self)
		end
		self.phys.dx=self.speed*
			gamemgr.speedmult
	end,
	
	draw=function(self)
		rectfill(self.phys.x,
			self.phys.y,
			self.phys.x+8,
			self.phys.y+8,
			8)
	end,
	
	destroy=function(self)
		player.score+=self.points
		for i=1,20 do
			particle:new(self.phys.x,
				self.phys.y,8)
		end
		cam.stress=10
		sfx(2)
		del(physics.bodies,self.phys)
		del(enemies,self)
	end
}

walls = {}

wall = {
	phys={},
	bounds={},
	width = 8,
	speed=-1,
	scored=false,
	c=13,
	
	new=function(self)
		local o = {}
		setmetatable(o,self)
		self.__index = self
		
		o.phys=physicsbody:new{
			gravity=false,
			mu=0,
			x=130,
			dx=self.speed
		}
		
		--is top or bottom wall?
		local istop=true
		local y = 32 + rnd(64)
		if y>64 then istop=false end
		
		if istop then
			o.bounds = {
				xi=0,yi=0,
				xf=self.width,yf=y
			}
		else
			o.bounds = {
				xi=0,yi=y,
				xf=self.width,yf=128
			}
		end
		
		add(walls,o)
		return o
	end,
	
	update=function(self)
		self.phys.dx=self.speed*
			gamemgr.speedmult
		if self.phys.x < player.phys.x 
			and not self.scored 
			and not gamemgr.gameover then

			self.scored = true
			self.c = 12
			player.score += 30
			sfx(1)
						
		end
	end,
	
	draw=function(self)
		rectfill(
			self.phys.x+self.bounds.xi,
			self.bounds.yi,
			self.phys.x+self.bounds.xf,
			self.bounds.yf,
			self.c
		)
	end
}

particles = {}

particle = {
	phys=nil,
	c=7,
	
	new=function(self,x,y,c)
		local o = {}
		setmetatable(o,self)
		self.__index = self
		
		o.phys=physicsbody:new{
			x=x,y=y,
			dx=rnd(6)-3,
			dy=-rnd(5),
			mu=0
		}
		o.c=c
		
		add(particles,o)
		return o
	end,
	
	update=function(self)
		if self.phys.x<0 or
			self.phys.y<0 then
			
			del(physics.bodies,self.phys)
			del(particles,self)
		end
	end,
	
	draw=function(self)
		circfill(self.phys.x,
			self.phys.y,1,self.c)
		--pset(self.phys.x,self.phys.y,self.c)
	end
}

stars = {}

star = {
	phys = {},
	
	new = function(self)
		local o = {}
		setmetatable(o,self)
		self.__index = self
		
		o.phys = physicsbody:new{
			x = 130,
			y = rnd(120),
			gravity = false,
			mu = 0,
			dx = -gamemgr.speedmult
		}
		
		add(stars,o)
		return o
	end,
	
	update = function(self)
		if self.phys.x < 0 then
			del(stars,self)
		end
		self.phys.dx = -gamemgr.speedmult
	end,
	
	draw = function(self)
		pset(self.phys.x,self.phys.y,
			7)
	end
}

-->8
--helpers

physics = {
	bodies = {},
	
	gravity = 0.25,

	update = function(self)
		for b in all(self.bodies) do
			b:update()
		end
	end
}

physicsbody = {
	x=0,y=0,
	dx=0,dy=0,
	ddx=0,ddy=0,
	gravity=true,
	m=1,mu=0.05,
	
	new=function(self,t)
		--inspiration:
		--https://stackoverflow.com/questions/6022519/define-default-values-for-function-arguments
		setmetatable(t,
			{__index={
				x=0,y=0,
				dx=0,dy=0,
				ddx=0,ddy=0,
				gravity=true,
				m=1,mu=0.05,
			}
		})
		
		local o = {}
		setmetatable(o, self)
		self.__index = self
		
		o.x=t[1] or t.x
		o.y=t[2] or t.y
		o.dx=t[3] or t.dx
		o.dy=t[4] or t.dy
		o.ddx=t[5] or t.ddx
		o.ddy=t[6] or t.ddy
		o.gravity=t[7] or t.gravity
		o.m=t[8] or t.m
		o.mu=t[9] or t.mu
		
		add(physics.bodies,o)
		return o	
	end,
	
	update=function(self)
		--gravity
		if self.gravity then
			self:addforce(0,physics.gravity)
			--self.dy+=physics.gravity
		end
		--accelerate
		self.dx+=self.ddx
		self.dy+=self.ddy

		
		--move
		self.x+=self.dx
		self.y+=self.dy
	
		--test=test.."ddy: "..self.ddy.."\n"
		--reset
		self.ddx=0
		self.ddy=0
		--"drag"
		self.dx=lerp(self.dx,0,self.mu)
		self.dy=lerp(self.dy,0,self.mu)
	end,
	
	addforce=function(self,x,y)
		self.ddx+=x*self.m
		self.ddy+=y*self.m
	end
	
}

function lerp(a,b,t)
	return a + (b-a)*t
end

function inversevec(x,y)
	return -x,-y
end

function perpvec(x,y)
	return y,-x
end

function vecbtwn(xi,yi,xf,yf)
	return xf-xi,yf-yi
end

function distance(xi,yi,xf,yf)
	local dx=xf-xi
	local dy=yf-yi
	return sqrt(dx*dx + dy*dy)
end

function distsqr(xi,yi,xf,yf)
	local dx=xf-xi
	local dy=yf-yi
	return dx*dx + dy*dy
end

function mag(dx,dy)
	return distance(0,0,dx,dy)
end

function magsqr(dx,dy)
	return distsqr(0,0,dx,dy)
end

function overlapping(x1,y1,w1,h1,
	x2,y2,w2,h2)
	
	return (
		x1+w1>x2 and
		y1+h1>y2 and
		x2+w2>x1 and
		y2+h2>y1
	)
end

function b_e_hit(b)
	local r = b.r
	for e in all(enemies) do
		if overlapping(b.phys.x-r,
			b.phys.y-r,2*r,2*r,
			e.phys.x,e.phys.y,8,8) then
			
			return e
		end
	end
	return nil
end

function p_hit()
	--enemies
	for e in all(enemies) do
		if overlapping(player.phys.x,
			player.phys.y,8,12,
			e.phys.x,e.phys.y,8,8) then
			
			return e
		end
	end
	--walls
	for w in all(walls) do
		if overlapping(player.phys.x,
			player.phys.y, 8,12,
			w.phys.x,w.bounds.yi,
			w.width,w.bounds.yf-w.bounds.yi)
			then
				return w
		end
	end
	return nil
end
__gfx__
00000000000006666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000006868000000000000006666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000006666000000000000006868000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000660000000000000006666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000066666600000000000000660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700006600660066000000000666666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000660000000000006006600600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000660000000000060066000060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000660000000000000066000001110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000660000dddd00000600600111880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000006006000dddd00000600061188110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000060000600ddcc00000601166811100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000060000600ddcc00000611881110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000111161111611ddcc00011668111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000018866888668dddd00118811100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000001111111111dddd00111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000dd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
06600660066066606660000000006600666066606660000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60006000606060606000060000000600600060006060000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66606000606066006600000000000600666066606060000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00606000606060606000060000000600006000606060000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66000660660060606660000000006660666066606660000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
00000000000000000000000066660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000068680000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000066660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000006600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000006666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000060066006000000000000000000000000000000000007000000000000000000000000000000000000000000000000000000000000000
00000000000000000000600660000600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000080000000660000011100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000880000006006001118800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000898000006000611881100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000999000006011668111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000089a9900006118811100000000000000000000000000000000000000000000007000000000000000000000000000000000000000000000000000
00000000000008aaaa00116681110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000009aaaa01188111000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000009abaa01111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000abbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000008abcb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000008accc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000009bc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000009b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000008ac000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000008ac000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000009a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000009b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000ab0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000ac0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000008ac0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000008b00000000000000000000000000000000000000000000000000070000000000000000000000000000000000000000000000000000000000000000
00000000009b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000009c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000ac00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000008a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000008a000000000000000000000000000000000000000000000008888888880000000000000000000000000000000000000000000000000000000000000
0000000009b000000000000000000000000000000000000000000000008888888880000000000000000000000000000000000000000000000000000000000000
0000000009b000000000000000000000000000000000000000000000008888888880000000000000000000000000000000000000000000000000000000000000
000000000ac000000000000000000000000000000000000000000000008888888880000000000000000000000000000000000000000000000000000000000000
000000000ac000000000000000000000000000000000000000000000008888888880000000000000000000000000000000000000000000000000000000000000
000000000a0000000000000000000000000000000000000000000000008888888880000000000000000000000000000000000000000000000000000000000000
000000008b0000000000000000000000000000000000000000000000008888888880000000000000000000000000000000000000000000000000000000000000
000000008b0000000000000000000000000000000000000000000000008888888880000000000000000000000000000000000000000000000000000000000000
000000009c0000000000000000000000000000000000000000000000008888888880000000000000000000000000000000000000000000000000000000000000
000000009c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000008b00000000000000000000000000000000000000000000000000000000000000000000000070000000000000000000000000000000000000000000000
00000008b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000009c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000009c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0880000a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0888888b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0998888b000000000000700000000000000000000000000000ccc000000000000000000000000000000000008000000000000000000000000000000000000000
0999999c0000000000000000000000000000000000000000ccccccc0000000000000000000000000000000088800000000000000000000000000000000000000
0aa9999c0000000000000000000000000000000000000000ccccccc0000000000000000000000000000000008000000000000000000000000000000000000000
0aaaaaa0000000000000000000000000000000000000000ccccccccc000000000000000000000000000000000000000000000000000000000000000000000008
0aaaaaa0000000000000000000000000000000000000000ccccccccc000000000000000000000000000000000000000000000000000000000000000000000088
0bbaaaa0000000000000000000000000000000000000000ccccccccc000000000000000000000000000000000000000000000000000000000000000000000008
0bbbbbb00000000000000000000000000000000000000000ccccccc0000000000000000000000000000000000000000000000000000000000000000000000000
0ccbbbb00000000000000000000000000000000000000000ccccccc0000000000000000000000000000000000000000000000000000000000000000000000000
0cccccc0000000000000000000000000000000000000000000ccc000000000000000000000000000000000000000000000000000000000000000000000000000
000cccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000700000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000ccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000800000000000000000000000000
00000000000ccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000008880000000000000000000000000
00000000000ccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000700000800000000000000000000000000
00000000000ccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000ccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000ccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000ccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000ccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000ccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000ccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000ccccccccc000000000000000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000ccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000ccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000ccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000ccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000ccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000800000000000000
00000000000ccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008880000000000000
00000000000ccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000800000000000000
00000000000ccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000ccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000ccccccccc000000000000000000000000000000000000000000000000000000000000000000800000000000000000000000000000000000000000
00000000000ccccccccc000000000000000000000000000000000000000000000000000000000000000008880000000000000000000000000000000000000000
00000000000ccccccccc000000000000000000000000000000000000000000000000000000000000000000800000000000000000000000000000000000000000
00000000000ccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000ccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000ccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000ccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000ccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000ccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000ccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000ccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000ccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000ccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

__sfx__
00010000027500575008750097500b7500c7500d7500f7500f7501075010750107500f7500f7500f7500e7500c7500b7500a7500a7500b7500e75013750177501a7501c7501e7501f75021750227502375023750
000600000000026550265502655026550215502155021550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000300002a1502815024150201501d1501b1501715014150101500b15000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100
000500002f6502f6502635026350296502135021350226501935019350186500f3500e3500c650083500265000000000000000000000000000000000000000000000000000000000000000000000000000000000
