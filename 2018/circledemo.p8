pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
center={x=64,y=64}

circles={}

function _init()
	for i=7,1,-1 do
		add(circles, {
			r=i*10,
			c=i
		})
	end
end

function _draw()
	cls()
	for c in all(circles) do
		c.r+=.5
		if c.r>70 then
			c.r=0
			local newcircles={}
			for i=#circles-1,1,-1 do
				add(newcircles,circles[i])
			end
			add(newcircles,c)
			circles=newcircles
		end
	end
	--for x=1,128 do
	--	for y=1,128 do
	--		for c in all(circles) do
		--		if sqrt((x-center.x)^2+(y-center.y)^2)<c.r then
		--			pset(x,y,c.c)
		--			break
		--		end
		--	end
	--	end
--	end
	for c in all(circles) do
		circfill(center.x,center.y,c.r,c.c)
	end
	print(stat(7),64,64,12)
end

function _update60()
	if btn(⬆️) then
		center.y-=1
	end
	if btn(⬇️) then
		center.y+=1
	end
	if btn(⬅️) then
		center.x-=1
	end
	if btn(➡️) then
		center.x+=1
	end
end
