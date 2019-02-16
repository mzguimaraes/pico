pico-8 cartridge // http://www.pico-8.com
version 16
__lua__


function _init()
	
end

function _update60()

end

test=""

function _draw()
	cls()
	actor:draw()
	print(test,0,0,7)
	test=""
end
-->8

--default vertex definitions
lefthand = {
	x=-4,y=0,
	children={}
}
righthand = {
	x=4,y=0,
	children={}
}
leftfoot = {
	x=-4,y=16,
	children={}
}
rightfoot = {
	x=4,y=16,
	children={}
}
head = {
	x=0,y=-16,
	children={}
}
leftelbow = {
	x=-3,y=-7,
	children={lefthand}
}
rightelbow = {
	x=3,y=-7,
	children={righthand}
}
leftknee = {
	x=-3,y=8,
	children={leftfoot}
}
rightknee = {
	x=3,y=8,
	children={rightfoot}
}
neck = {
	x=0,y=-14,
	children={head,leftelbow,rightelbow}
}

actor = {
	x=64,y=64,c=7,bc=8,

	root = {
		x=0,y=0,
		children={neck,leftknee,rightknee}
	},

	draw = function(self)
		vertsdrawn=0

		self:drawrec(self.root,self.x,self.y)
		pset(self.x+self.root.x,
			 self.y+self.root.y,
			 self.bc)

		test=test.."verts drawn: "..vertsdrawn.."\n"
		test=test.."root children: "..#self.root.children
	end,

	drawrec=function(self,curr,absx,absy)
		--absx/y == screenspace pos of curr vertex
		if #curr.children==0 then return end

		for v in all(curr.children) do
			local xpos = absx+v.x
			local ypos = absy+v.y
			line(absx,absy,xpos,ypos,self.c)
			pset(xpos,ypos,self.bc)

			--recur on v
			vertsdrawn+=1
			self:drawrec(v,xpos,ypos)
		end
	end,
}

-- actor = {
-- 	x=64, y=64,
-- 	root = {
-- 		--pelvis
-- 		x=0,y=0,
-- 		children={
-- 			--neck
-- 			{x=0,y=-14,
-- 				children={
-- 					--head
-- 					{x=0,y=-16,
-- 						children={}
-- 					},
-- 					--leftelbow
-- 					{x=-3,y=-6,
-- 						children={
-- 							--lefthand
-- 							{x=-4,y=2,
-- 								children={}
-- 							}
-- 						}
-- 					},
-- 					--rightelbow
-- 					{x=3,y=-6,
-- 						children={
-- 							--righthand
-- 							{x=4,y=2,
-- 								children={}
-- 							}
-- 						}
-- 					}
-- 				}
-- 			}
-- 			--leftknee
-- 				--leftfoot
-- 			--rightknee
-- 				--rightfoot
-- 		}
-- 		--{0,-16},--head
-- 		--{0,-14},--neck
-- 		--{-3,-6},--leftelbow
-- 		--{-4,2},--lefthand
-- 		--{3,-6},--rightelbow
-- 		--{-4,2},--righthand
-- 		--{0,0},--pelvis
-- 		--leftknee
-- 		--leftfoot
-- 		--rightknee
-- 		--rightfoot
-- 	},
	
-- 	draw = function(self)
-- 		self:drawrec(self.root)
-- 		pset(self.x+self.root.x,
-- 			self.y+self.root.y,
-- 			8)
-- 	end,
	
-- 	drawrec=function(parent,vert)
-- 		if #vert.children==0 then
-- 			return
-- 		end
		
-- 		for v in all(vert.children) do
-- 			line(parent.x+vert.x,
-- 				parent.y+vert.y,
-- 				parent.x+v.x,
-- 				parent.y+v.y,
-- 				7)
-- 			self.drawrec(parent,v)
					
-- 			pset(parent.x+v.x,
-- 				parent.y+v.y,
-- 				8)
-- 		end
		
-- 	end
-- }
